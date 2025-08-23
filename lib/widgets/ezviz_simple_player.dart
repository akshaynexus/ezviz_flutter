import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../ezviz_flutter.dart';
import 'dart:async';
import 'dart:io';

/// Configuration for EzvizSimplePlayer
class EzvizPlayerConfig {
  /// EZVIZ API configuration
  final String appKey;
  final String appSecret;
  final String? baseUrl;

  /// Authentication credentials
  final String? accessToken;
  final String? account;
  final String? password;

  /// Player settings
  final bool autoPlay;
  final bool enableAudio;
  final bool showControls;
  final bool enableEncryptionDialog;
  final bool allowFullscreen;
  final bool hideControlsOnTap;
  final bool compactControls;
  final bool autoRotate;
  final bool enableDoubleTapSeek;
  final bool enableSwipeSeek;
  final bool showDeviceInfo;

  /// UI customization
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final TextStyle? loadingTextStyle;
  final Color? controlsBackgroundColor;
  final Color? controlsIconColor;
  final Duration controlsHideTimeout;

  const EzvizPlayerConfig({
    required this.appKey,
    required this.appSecret,
    this.baseUrl,
    this.accessToken,
    this.account,
    this.password,
    this.autoPlay = true,
    this.enableAudio = true,
    this.showControls = true,
    this.enableEncryptionDialog = true,
    this.allowFullscreen = true,
    this.hideControlsOnTap = true,
    this.compactControls = false,
    this.autoRotate = true,
    this.enableDoubleTapSeek = true,
    this.enableSwipeSeek = true,
    this.showDeviceInfo = false,
    this.loadingWidget,
    this.errorWidget,
    this.loadingTextStyle,
    this.controlsBackgroundColor,
    this.controlsIconColor,
    this.controlsHideTimeout = const Duration(seconds: 3),
  });
}

/// Simple-to-use EZVIZ player widget that handles all complexity internally
class EzvizSimplePlayer extends StatefulWidget {
  /// Camera device serial number
  final String deviceSerial;

  /// Camera channel number
  final int channelNo;

  /// Player configuration
  final EzvizPlayerConfig config;

  /// Optional encryption password (if known)
  final String? encryptionPassword;

  /// Callback when player state changes
  final Function(EzvizSimplePlayerState state)? onStateChanged;

  /// Callback when encryption password is needed
  final Future<String?> Function()? onPasswordRequired;

  /// Callback when errors occur
  final Function(String error)? onError;

  const EzvizSimplePlayer({
    super.key,
    required this.deviceSerial,
    required this.channelNo,
    required this.config,
    this.encryptionPassword,
    this.onStateChanged,
    this.onPasswordRequired,
    this.onError,
  });

  @override
  State<EzvizSimplePlayer> createState() => _EzvizSimplePlayerState();
}

/// Player states for easy monitoring
enum EzvizSimplePlayerState {
  initializing,
  initialized,
  connecting,
  playing,
  paused,
  stopped,
  error,
  passwordRequired,
}

class _EzvizSimplePlayerState extends State<EzvizSimplePlayer> 
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  EzvizPlayerController? _controller;
  EzvizSimplePlayerState _state = EzvizSimplePlayerState.initializing;
  String? _error;
  bool _isPlaying = false;
  bool _soundEnabled = false;
  bool _isSDKInitialized = false;
  String? _currentPassword;
  bool _isDisposed = false;
  bool _wasPlayingBeforeBackground = false;

  // Add connection attempt tracking
  int _connectionAttempts = 0;
  static const int _maxConnectionAttempts = 3;
  static const Duration _connectionTimeout = Duration(seconds: 15);
  Timer? _connectionTimer;
  bool _isConnecting = false;
  bool _isPlayerInitialized = false;

  // Controls and fullscreen management
  bool _showControls = false; // Start hidden
  Timer? _controlsTimer;

  // Track if player widget has been created
  bool _playerCreated = false;

  /// Check if we're in fullscreen (landscape mode)
  bool get isFullScreen =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _currentPassword = widget.encryptionPassword;
    debugPrint('🎬 EzvizSimplePlayer initialized with external controls');
    debugPrint('🎬 showControls: ${widget.config.showControls}');
    _initializeSDK();
  }

  @override
  void dispose() {
    _isDisposed = true;
    WidgetsBinding.instance.removeObserver(this);
    
    // Cancel all timers first
    _connectionTimer?.cancel();
    _controlsTimer?.cancel();

    // Clean up controller
    if (_controller != null) {
      _controller!.removePlayerEventHandler();
      _controller!.stopRealPlay();
      _controller!.release();
      _controller = null;
    }

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    if (_isDisposed) return;
    
    debugPrint('🔄 App lifecycle state changed: $state');
    
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        // App going to background or being closed
        debugPrint('🔄 App backgrounding - saving state and cleaning up');
        _wasPlayingBeforeBackground = _isPlaying;
        _controller?.removePlayerEventHandler();
        if (_isPlaying) {
          _controller?.stopRealPlay();
        }
        break;
        
      case AppLifecycleState.resumed:
        // App coming back to foreground
        debugPrint('🔄 App resuming - restoring state');
        if (_controller != null && _wasPlayingBeforeBackground && !_isDisposed) {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted && !_isDisposed) {
              _setupPlayerEventHandlers();
              _startLiveStream();
            }
          });
        }
        break;
        
      case AppLifecycleState.inactive:
        // App temporarily inactive (e.g., during screen lock)
        debugPrint('🔄 App inactive - pausing operations');
        _controller?.removePlayerEventHandler();
        break;
        
      case AppLifecycleState.hidden:
        // App hidden but still running
        debugPrint('🔄 App hidden - maintaining minimal state');
        break;
    }
  }

  /// Initialize the EZVIZ SDK
  Future<void> _initializeSDK() async {
    try {
      _updateState(EzvizSimplePlayerState.initializing);

      debugPrint('🔧 Initializing EZviz SDK...');
      debugPrint('🔧 AppKey: ${widget.config.appKey.substring(0, 8)}...');
      debugPrint(
        '🔧 AccessToken: ${widget.config.accessToken?.substring(0, 8)}...',
      );

      // Initialize SDK
      final initOptions = EzvizInitOptions(
        appKey: widget.config.appKey,
        accessToken: widget.config.accessToken ?? "",
        enableLog: true,
        enableP2P: false,
        baseUrl: widget.config.baseUrl,
      );

      final result = await EzvizManager.shared().initSDK(initOptions);
      debugPrint('🔧 SDK initialization result: $result');

      _isSDKInitialized = true;
      _updateState(EzvizSimplePlayerState.initialized);
    } catch (e) {
      debugPrint('💥 SDK initialization failed: $e');
      _handleError('SDK initialization failed: $e');
    }
  }

  /// Setup player event handlers
  void _setupPlayerEventHandlers() {
    if (_controller == null) return;

    debugPrint(
      '🎮 Setting up player event handlers for ${widget.deviceSerial}',
    );

    _controller!.setPlayerEventHandler(
      (EzvizEvent event) {
        // Check if widget is still mounted before processing events
        if (!mounted) return;

        if (event.eventType == EzvizChannelEvents.playerStatusChange) {
          if (event.data is EzvizPlayerStatus) {
            final status = event.data as EzvizPlayerStatus;
            _handlePlayerStatus(status);
          }
        }
      },
      (error) {
        if (!mounted) return;
        debugPrint('💥 Player event handler error: $error');
        _handleError('Player event error: $error');
      },
    );
  }

  /// Handle player status changes
  void _handlePlayerStatus(EzvizPlayerStatus status) {
    // Cancel connection timer if we get any status update
    _connectionTimer?.cancel();

    debugPrint(
      '🎮 Player status: ${status.status}, message: ${status.message}',
    );

    if (!mounted) return;

    setState(() {
      _isPlaying = status.status == 2;

      if (status.status == 1 || status.status == 2) {
        _isConnecting = false;
      }
    });

    switch (status.status) {
      case 1: // Init
        _isPlayerInitialized = true;
        _connectionAttempts = 0;
        _updateState(EzvizSimplePlayerState.initialized);
        debugPrint('✅ Player initialized and ready');

        if (widget.config.autoPlay && !_isConnecting && !_isPlaying) {
          debugPrint('🚀 Auto-starting stream...');
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted && !_isConnecting && !_isPlaying) {
              _startLiveStream();
            }
          });
        }
        break;

      case 2: // Playing
        _connectionAttempts = 0;
        _isConnecting = false;
        _updateState(EzvizSimplePlayerState.playing);
        debugPrint('🎬 Stream is now playing');

        if (widget.config.enableAudio && !_soundEnabled) {
          _enableAudio();
        }
        break;

      case 3: // Pause (only for playback, not live streams)
        _isConnecting = false;
        _updateState(EzvizSimplePlayerState.paused);
        debugPrint('🎬 Stream paused (playback only)');
        break;

      case 4: // Stop
        _isConnecting = false;
        _updateState(EzvizSimplePlayerState.stopped);
        debugPrint('🛑 Stream stopped');
        break;

      case 5: // Error
        _isConnecting = false;
        debugPrint('🚨 Player error: ${status.message}');

        if (status.message != null) {
          final errorMsg = status.message!.toLowerCase();

          if (errorMsg.contains('password') ||
              errorMsg.contains('verification') ||
              errorMsg.contains('encrypt')) {
            _handlePasswordRequired();
          } else {
            _handleError('Player error: ${status.message}');
          }
        } else {
          _handleError('Unknown player error (status code: ${status.status})');
        }
        break;

      case 0: // Unknown/Stopped
        debugPrint('🔄 Player stopped or unknown status');
        _isConnecting = false;
        _updateState(EzvizSimplePlayerState.stopped);
        break;

      default:
        debugPrint('🤔 Unknown player status: ${status.status}');
        break;
    }
  }

  /// Initialize player
  Future<void> _initializePlayer() async {
    if (_controller == null) return;

    setState(() {
      _error = null;
    });

    try {
      debugPrint(
        '🎯 Initializing player for device: ${widget.deviceSerial}, channel: ${widget.channelNo}',
      );

      if (!_isSDKInitialized) {
        debugPrint('🔧 Re-initializing SDK before player creation...');
        await _initializeSDK();
        if (!_isSDKInitialized) {
          throw Exception('Failed to initialize SDK');
        }
      }

      await _controller!.initPlayerByDevice(
        widget.deviceSerial,
        widget.channelNo,
      );

      if (_currentPassword != null) {
        debugPrint('🔐 Setting verification code');
        await _controller!.setPlayVerifyCode(_currentPassword!);
      }

      debugPrint('✅ Player initialized successfully');
      _isPlayerInitialized = true;
    } catch (e) {
      debugPrint('❌ Error initializing player: $e');
      _handleError('Failed to initialize player: $e');
    }
  }

  /// Start live stream
  Future<void> _startLiveStream() async {
    if (_controller == null || _isConnecting || !mounted) {
      debugPrint('⚠️ Cannot start stream: controller=${_controller != null}, connecting=$_isConnecting, mounted=$mounted');
      return;
    }

    // Check if we've exceeded max attempts
    if (_connectionAttempts >= _maxConnectionAttempts) {
      _handleError(
        'Maximum connection attempts exceeded. Please check camera status.',
      );
      return;
    }

    try {
      _isConnecting = true;
      _connectionAttempts++;
      _updateState(EzvizSimplePlayerState.connecting);

      debugPrint(
        '🔄 Starting live stream attempt $_connectionAttempts/$_maxConnectionAttempts',
      );

      // Ensure player is initialized first
      if (!_isPlayerInitialized) {
        debugPrint('⚠️ Player not initialized, initializing first...');
        await _initializePlayer();
        if (!_isPlayerInitialized) {
          throw Exception('Player initialization failed');
        }
      }

      // Check mounted state before continuing
      if (!mounted) return;

      final success = await _controller!.startRealPlay();
      if (success) {
        debugPrint('✅ Live stream started successfully');
        // Set a fallback timer in case we don't get a status update
        Timer(const Duration(seconds: 5), () {
          if (mounted && _isConnecting) {
            debugPrint('⚠️ Stream start timeout, updating state manually');
            setState(() {
              _isConnecting = false;
              _isPlaying = true;
            });
            _updateState(EzvizSimplePlayerState.playing);
          }
        });
      } else {
        // Check if this is an encrypted camera and we need password
        if (_currentPassword == null) {
          debugPrint('❓ Live stream failed - might need encryption password');
          _handlePasswordRequired();
        } else {
          throw Exception('Failed to start live stream');
        }
      }
    } catch (e) {
      debugPrint('❌ Error starting live stream: $e');
      _isConnecting = false;

      // Check if error is related to encryption
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('password') ||
          errorStr.contains('verification') ||
          errorStr.contains('encrypt')) {
        _handlePasswordRequired();
      } else {
        if (_connectionAttempts < _maxConnectionAttempts) {
          debugPrint('🔄 Retrying in 3 seconds...');
          Timer(const Duration(seconds: 3), () {
            if (mounted && !_isConnecting) {
              _startLiveStream();
            }
          });
        } else {
          _handleError(
            'Failed to start stream after $_maxConnectionAttempts attempts: $e',
          );
        }
      }
    }
  }

  /// Stop live stream
  Future<void> _stopLiveStream() async {
    if (_controller == null) return;

    try {
      _connectionTimer?.cancel();
      _isConnecting = false;
      
      // Stop the stream
      final success = await _controller!.stopRealPlay();
      if (success) {
        setState(() {
          _isPlaying = false;
        });
        _updateState(EzvizSimplePlayerState.stopped);
        debugPrint('🛑 Live stream stopped successfully');
      } else {
        debugPrint('⚠️ Stop live stream returned false');
      }
    } catch (e) {
      debugPrint('❌ Error stopping live stream: $e');
      // Even if stopping fails, update UI state
      setState(() {
        _isPlaying = false;
      });
      _updateState(EzvizSimplePlayerState.stopped);
    }
  }

  /// Handle password requirement
  Future<void> _handlePasswordRequired() async {
    if (!widget.config.enableEncryptionDialog) {
      _handleError('This camera requires a verification code');
      return;
    }

    _updateState(EzvizSimplePlayerState.passwordRequired);

    String? password;
    if (widget.onPasswordRequired != null) {
      password = await widget.onPasswordRequired!();
    } else {
      password = await _showDefaultPasswordDialog();
    }

    if (password != null) {
      _currentPassword = password;
      if (_controller != null) {
        await _controller!.setPlayVerifyCode(password);
        await _startLiveStream();
      }
    } else {
      _handleError('Verification code required');
    }
  }

  /// Show default password dialog
  Future<String?> _showDefaultPasswordDialog() async {
    final TextEditingController passwordController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verification Code Required'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'This camera is encrypted and requires a verification code.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Verification Code',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) => Navigator.of(context).pop(value),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(passwordController.text);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Enable audio
  Future<void> _enableAudio() async {
    if (_controller == null || _soundEnabled) return;

    try {
      final success = await _controller!.openSound();
      if (success) {
        setState(() {
          _soundEnabled = true;
        });
      }
    } catch (e) {
      debugPrint('Failed to enable audio: $e');
    }
  }

  /// Toggle audio
  Future<void> _toggleAudio() async {
    if (_controller == null) return;

    if (widget.config.hideControlsOnTap && _showControls) {
      _startControlsTimer();
    }

    try {
      bool success;
      if (_soundEnabled) {
        success = await _controller!.closeSound();
      } else {
        success = await _controller!.openSound();
      }

      if (success) {
        setState(() {
          _soundEnabled = !_soundEnabled;
        });
      }
    } catch (e) {
      debugPrint('Failed to toggle audio: $e');
    }
  }

  /// Public method to toggle audio - can be called from external widgets
  Future<void> toggleAudio() async {
    return _toggleAudio();
  }

  /// Public getter for audio state - can be accessed from external widgets
  bool get isAudioEnabled => _soundEnabled;
  
  /// Public getter for the controller - can be accessed from external widgets
  EzvizPlayerController? get controller => _controller;

  /// Toggle play/pause
  Future<void> _togglePlayPause() async {
    if (_controller == null) return;

    if (widget.config.hideControlsOnTap && _showControls) {
      _startControlsTimer();
    }

    if (_isPlaying) {
      // For live streams, we need to stop since there's no true pause
      await _stopLiveStream();
    } else {
      // Reset state and restart stream
      _connectionAttempts = 0;
      setState(() {
        _error = null;
      });
      await _startLiveStream();
    }
  }

  /// Reset connection state and retry
  void _resetAndRetry() {
    _connectionTimer?.cancel();
    _isConnecting = false;
    _connectionAttempts = 0;
    setState(() {
      _error = null;
      _isPlaying = false;
    });
    _initializeSDK();
  }

  /// Update state and notify callback
  void _updateState(EzvizSimplePlayerState newState) {
    if (!mounted) return;

    setState(() {
      _state = newState;
    });
    widget.onStateChanged?.call(newState);
  }

  /// Handle errors
  void _handleError(String error) {
    if (!mounted) return;

    _connectionTimer?.cancel();
    _isConnecting = false;
    debugPrint('🚨 Error: $error');

    setState(() {
      _error = error;
      _isPlaying = false;
    });
    _updateState(EzvizSimplePlayerState.error);
    widget.onError?.call(error);
  }

  /// Build loading widget
  Widget _buildLoadingWidget() {
    if (widget.config.loadingWidget != null) {
      return widget.config.loadingWidget!;
    }

    String message;
    switch (_state) {
      case EzvizSimplePlayerState.initializing:
        message = 'Initializing...';
        break;
      case EzvizSimplePlayerState.connecting:
        message = 'Connecting...';
        break;
      case EzvizSimplePlayerState.passwordRequired:
        message = 'Password required...';
        break;
      default:
        message = 'Loading...';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.white),
          const SizedBox(height: 16),
          Text(
            message,
            style:
                widget.config.loadingTextStyle ??
                const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  /// Build error widget
  Widget _buildErrorWidget() {
    if (widget.config.errorWidget != null) {
      return widget.config.errorWidget!;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(
            _error ?? 'Unknown error',
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _resetAndRetry, child: const Text('Retry')),
        ],
      ),
    );
  }

  /// Start controls auto-hide timer
  void _startControlsTimer() {
    // No longer needed - controls are always visible externally
    return;
  }

  /// Toggle fullscreen mode
  void _toggleFullscreen() async {
    if (!widget.config.allowFullscreen) return;

    // Store current state before transition
    final currentlyPlaying = _isPlaying;
    final currentState = _state;
    
    if (isFullScreen) {
      // Exit fullscreen
      await _exitFullscreen();
    } else {
      // Enter fullscreen
      await _enterFullscreen();
    }
    
    // Force a rebuild to recreate the video area
    setState(() {});
    
    debugPrint('🎆 Fullscreen toggle complete - was playing: $currentlyPlaying, state: $currentState');
  }

  /// Enter fullscreen mode
  Future<void> _enterFullscreen() async {
    debugPrint('🎆 Entering fullscreen mode - current state: $_state, isPlaying: $_isPlaying');
    
    // Set landscape orientation
    DeviceOrientation deviceOrientation = DeviceOrientation.landscapeLeft;
    if (Platform.isIOS) {
      deviceOrientation = DeviceOrientation.landscapeRight;
    }

    await SystemChrome.setPreferredOrientations([deviceOrientation]);

    // Hide system UI
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Show controls initially and start auto-hide timer
    setState(() {
      _showControls = true;
    });
    _startFullscreenControlsTimer();
    
    // If we were playing, ensure stream continues in fullscreen
    if (_state == EzvizSimplePlayerState.playing && _controller != null && !_isConnecting) {
      debugPrint('🎆 Stream was playing, ensuring continuation in fullscreen');
    }
  }

  /// Exit fullscreen mode
  Future<void> _exitFullscreen() async {
    debugPrint('🎆 Exiting fullscreen mode - current state: $_state, isPlaying: $_isPlaying');
    
    // Restore portrait orientation
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Show system UI
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    // Reset controls
    _controlsTimer?.cancel();
    setState(() {
      _showControls = true;
    });
    
    // If we were playing, ensure stream continues in portrait mode
    if (_state == EzvizSimplePlayerState.playing && _controller != null && !_isConnecting) {
      debugPrint('🎆 Stream was playing, ensuring continuation in portrait mode');
    }
  }

  /// Start fullscreen controls auto-hide timer
  void _startFullscreenControlsTimer() {
    _controlsTimer?.cancel();
    if (isFullScreen) {
      _controlsTimer = Timer(widget.config.controlsHideTimeout, () {
        if (mounted && isFullScreen) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  /// Build fullscreen controls
  Widget _buildFullscreenControls() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.transparent,
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
          stops: const [0.0, 0.2, 0.8, 1.0],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Top bar (without back button)
            if (widget.config.showDeviceInfo)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '${widget.deviceSerial} - Channel ${widget.channelNo}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),

            const Spacer(),

            // Center play/pause button
            if (!_isPlaying)
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 48,
                    ),
                    onPressed: _togglePlayPause,
                  ),
                ),
              ),

            const Spacer(),

            // Bottom controls
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Play/Pause button
                  IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: _togglePlayPause,
                  ),

                  // Volume button
                  IconButton(
                    icon: Icon(
                      _soundEnabled ? Icons.volume_up : Icons.volume_off,
                      color: Colors.white,
                    ),
                    onPressed: _toggleAudio,
                  ),

                  const Spacer(),

                  // Live indicator
                  if (_isPlaying)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.circle, color: Colors.white, size: 8),
                          SizedBox(width: 4),
                          Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(width: 16),

                  // Exit fullscreen button
                  IconButton(
                    icon: const Icon(
                      Icons.fullscreen_exit,
                      color: Colors.white,
                    ),
                    onPressed: _toggleFullscreen,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build portrait player with controls
  Widget _buildPortraitPlayer() {
    return Stack(
      children: [
        // Video area
        _buildVideoArea(),

        // Controls area at bottom
        if (widget.config.showControls)
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildExternalControls(),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    if (_isDisposed) {
      return Container(color: Colors.black);
    }
    
    if (isFullScreen) {
      // Fullscreen mode - return a widget that takes over the parent's constraints
      return WillPopScope(
        onWillPop: () async {
          _toggleFullscreen();
          return false;
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Video player centered
              Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: _buildVideoArea(),
                ),
              ),

              // Touch detector
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showControls = !_showControls;
                  });
                  if (_showControls) {
                    _startFullscreenControlsTimer();
                  }
                },
                child: Container(color: Colors.transparent),
              ),

              // Controls overlay
              AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: _buildFullscreenControls(),
              ),
            ],
          ),
        ),
      );
    } else {
      // Portrait mode
      return Container(
        height: 250.0,
        color: Colors.black,
        child: _buildPortraitPlayer(),
      );
    }
  }

  /// Build video area without any overlays
  Widget _buildVideoArea() {
    if (_isDisposed) {
      return Container(color: Colors.black);
    }
    
    if (_state == EzvizSimplePlayerState.error) {
      return _buildErrorWidget();
    } else if (_state == EzvizSimplePlayerState.initializing ||
        _state == EzvizSimplePlayerState.connecting ||
        _state == EzvizSimplePlayerState.passwordRequired) {
      return _buildLoadingWidget();
    } else {
      return _buildSafePlatformView();
    }
  }
  
  /// Build safe platform view with error handling
  Widget _buildSafePlatformView() {
    try {
      return Container(
        constraints: const BoxConstraints(
          minWidth: 1.0,
          minHeight: 1.0,
          maxWidth: double.infinity,
          maxHeight: double.infinity,
        ),
        child: EzvizPlayer(
          onCreated: (controller) {
            if (_isDisposed) return;
            
            // Always reinitialize if controller is null or different
            // This handles fullscreen transitions properly
            if (_controller == null || _controller != controller) {
              final wasPlaying = _isPlaying;
              debugPrint('🎆 Creating new controller, wasPlaying: $wasPlaying');
              
              _controller = controller;
              _setupPlayerEventHandlers();
              _initializePlayer().then((_) {
                if (_isDisposed) return;
                
                // If we were playing before, restart the stream
                if (wasPlaying && _state != EzvizSimplePlayerState.playing && !_isConnecting) {
                  debugPrint('🎆 Restarting stream after controller recreation');
                  _startLiveStream();
                }
              });
              _playerCreated = true;
            }
          },
        ),
      );
    } catch (e) {
      debugPrint('Error building platform view: $e');
      return Container(
        color: Colors.black,
        child: const Center(
          child: Text(
            'Video player unavailable',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  /// Build external controls
  Widget _buildExternalControls() {
    final bool isCompact = widget.config.compactControls;
    final double controlsHeight = isCompact ? 36 : 48;
    final double iconSize = isCompact ? 16 : 20;
    final double buttonSize = isCompact ? 30 : 36;

    return Container(
      width: double.infinity,
      height: controlsHeight,
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 8 : 12,
        vertical: isCompact ? 3 : 6,
      ),
      decoration: BoxDecoration(
        color: widget.config.controlsBackgroundColor ?? Colors.grey.shade900,
        border: Border(
          top: BorderSide(color: Colors.grey.shade700, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Play/Pause button
          SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: widget.config.controlsIconColor ?? Colors.white,
                size: iconSize,
              ),
              onPressed: _togglePlayPause,
              tooltip: _isPlaying ? 'Pause' : 'Play',
            ),
          ),

          SizedBox(width: isCompact ? 2 : 4),

          // Audio button
          if (widget.config.enableAudio)
            SizedBox(
              width: buttonSize,
              height: buttonSize,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  _soundEnabled ? Icons.volume_up : Icons.volume_off,
                  color: widget.config.controlsIconColor ?? Colors.white,
                  size: iconSize - 2,
                ),
                onPressed: _toggleAudio,
                tooltip: _soundEnabled ? 'Mute' : 'Unmute',
              ),
            ),

          SizedBox(width: isCompact ? 4 : 8),

          // Connection status indicator
          if (!isCompact)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _getStateColor(_state).withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _getStateColor(_state), width: 0.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getStateIcon(_state),
                    color: _getStateColor(_state),
                    size: 12,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    _getStateText(_state),
                    style: TextStyle(
                      color: _getStateColor(_state),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          const Spacer(),

          // Fullscreen button
          if (widget.config.allowFullscreen)
            SizedBox(
              width: buttonSize,
              height: buttonSize,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(
                  isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                  color: widget.config.controlsIconColor ?? Colors.white,
                  size: iconSize - 2,
                ),
                onPressed: _toggleFullscreen,
                tooltip: isFullScreen ? 'Exit Fullscreen' : 'Fullscreen',
              ),
            ),
        ],
      ),
    );
  }

  /// Get color for state indicator
  Color _getStateColor(EzvizSimplePlayerState state) {
    switch (state) {
      case EzvizSimplePlayerState.playing:
        return Colors.green;
      case EzvizSimplePlayerState.error:
        return Colors.red;
      case EzvizSimplePlayerState.connecting:
        return Colors.orange;
      case EzvizSimplePlayerState.initialized:
        return Colors.blue;
      case EzvizSimplePlayerState.paused:
        return Colors.yellow;
      case EzvizSimplePlayerState.stopped:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  /// Get icon for state indicator
  IconData _getStateIcon(EzvizSimplePlayerState state) {
    switch (state) {
      case EzvizSimplePlayerState.playing:
        return Icons.play_circle;
      case EzvizSimplePlayerState.error:
        return Icons.error;
      case EzvizSimplePlayerState.connecting:
        return Icons.sync;
      case EzvizSimplePlayerState.initialized:
        return Icons.check_circle;
      case EzvizSimplePlayerState.paused:
        return Icons.pause_circle;
      case EzvizSimplePlayerState.stopped:
        return Icons.stop_circle;
      default:
        return Icons.circle;
    }
  }

  /// Get text for state indicator
  String _getStateText(EzvizSimplePlayerState state) {
    switch (state) {
      case EzvizSimplePlayerState.playing:
        return 'LIVE';
      case EzvizSimplePlayerState.error:
        return 'ERROR';
      case EzvizSimplePlayerState.connecting:
        return 'CONNECTING';
      case EzvizSimplePlayerState.initialized:
        return 'READY';
      case EzvizSimplePlayerState.paused:
        return 'PAUSED';
      case EzvizSimplePlayerState.stopped:
        return 'STOPPED';
      case EzvizSimplePlayerState.initializing:
        return 'INIT';
      default:
        return 'UNKNOWN';
    }
  }
}

/// Fullscreen player overlay that takes over the entire screen
class _FullscreenPlayerOverlay extends StatefulWidget {
  final EzvizPlayerController? controller;
  final String deviceSerial;
  final int channelNo;
  final bool isPlaying;
  final bool soundEnabled;
  final bool showDeviceInfo;
  final VoidCallback onPlayPause;
  final VoidCallback onToggleAudio;
  final Widget Function() buildVideoArea;
  final Duration controlsHideTimeout;

  const _FullscreenPlayerOverlay({
    required this.controller,
    required this.deviceSerial,
    required this.channelNo,
    required this.isPlaying,
    required this.soundEnabled,
    required this.showDeviceInfo,
    required this.onPlayPause,
    required this.onToggleAudio,
    required this.buildVideoArea,
    required this.controlsHideTimeout,
  });

  @override
  State<_FullscreenPlayerOverlay> createState() =>
      _FullscreenPlayerOverlayState();
}

class _FullscreenPlayerOverlayState extends State<_FullscreenPlayerOverlay> {
  bool _showControls = true;
  Timer? _controlsTimer;

  @override
  void initState() {
    super.initState();
    _startControlsTimer();
  }

  @override
  void dispose() {
    _controlsTimer?.cancel();
    super.dispose();
  }

  void _startControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(widget.controlsHideTimeout, () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _onScreenTap() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _startControlsTimer();
    }
  }

  void _exitFullscreen() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _exitFullscreen();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Video player filling entire screen
            Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: widget.buildVideoArea(),
              ),
            ),

            // Touch detector
            GestureDetector(
              onTap: _onScreenTap,
              child: Container(color: Colors.transparent),
            ),

            // Controls overlay
            AnimatedOpacity(
              opacity: _showControls ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: const [0.0, 0.2, 0.8, 1.0],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      // Top bar (without back button)
                      if (widget.showDeviceInfo)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            '${widget.deviceSerial} - Channel ${widget.channelNo}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      const Spacer(),

                      // Center play/pause button
                      if (!widget.isPlaying)
                        Center(
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 48,
                              ),
                              onPressed: widget.onPlayPause,
                            ),
                          ),
                        ),

                      const Spacer(),

                      // Bottom controls
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Play/Pause button
                            IconButton(
                              icon: Icon(
                                widget.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.white,
                                size: 24,
                              ),
                              onPressed: widget.onPlayPause,
                            ),

                            // Volume button
                            IconButton(
                              icon: Icon(
                                widget.soundEnabled
                                    ? Icons.volume_up
                                    : Icons.volume_off,
                                color: Colors.white,
                              ),
                              onPressed: widget.onToggleAudio,
                            ),

                            const Spacer(),

                            // Live indicator
                            if (widget.isPlaying)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.circle,
                                      color: Colors.white,
                                      size: 8,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'LIVE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            const SizedBox(width: 16),

                            // Exit fullscreen button
                            IconButton(
                              icon: const Icon(
                                Icons.fullscreen_exit,
                                color: Colors.white,
                              ),
                              onPressed: _exitFullscreen,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
