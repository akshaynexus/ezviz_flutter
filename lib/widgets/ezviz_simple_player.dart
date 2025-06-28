import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../ezviz_flutter.dart';
import 'dart:async';

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
    this.allowFullscreen = false,
    this.hideControlsOnTap = true,
    this.compactControls = false,
    this.autoRotate = true,
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

class _EzvizSimplePlayerState extends State<EzvizSimplePlayer> {
  EzvizPlayerController? _controller;
  EzvizSimplePlayerState _state = EzvizSimplePlayerState.initializing;
  String? _error;
  bool _isPlaying = false;
  bool _soundEnabled = false;
  bool _isSDKInitialized = false;
  String? _currentPassword;

  // Add connection attempt tracking
  int _connectionAttempts = 0;
  static const int _maxConnectionAttempts = 3;
  static const Duration _connectionTimeout = Duration(seconds: 15);
  Timer? _connectionTimer;
  bool _isConnecting = false;
  bool _isPlayerInitialized = false; // Track if player is properly initialized

  // New: Controls and fullscreen management
  bool _showControls = true;
  bool _isFullscreen = false;
  Timer? _controlsTimer;

  @override
  void initState() {
    super.initState();
    _currentPassword = widget.encryptionPassword;
    debugPrint('🎬 EzvizSimplePlayer initialized with external controls');
    debugPrint('🎬 showControls: ${widget.config.showControls}');
    _initializeSDK();
  }

  @override
  void dispose() {
    _connectionTimer?.cancel();
    _controlsTimer?.cancel();
    _controller?.stopRealPlay();
    _controller?.release();
    super.dispose();
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
        if (event.eventType == EzvizChannelEvents.playerStatusChange) {
          if (event.data is EzvizPlayerStatus) {
            final status = event.data as EzvizPlayerStatus;
            _handlePlayerStatus(status);
          }
        }
      },
      (error) {
        debugPrint('💥 Player event handler error: $error');
        _handleError('Player event error: $error');
      },
    );
  }

  /// Handle player status changes (based on working example)
  void _handlePlayerStatus(EzvizPlayerStatus status) {
    // Cancel connection timer if we get any status update
    _connectionTimer?.cancel();

    debugPrint(
      '🎮 Player status: ${status.status}, message: ${status.message}',
    );

    if (!mounted) return;

    setState(() {
      // Update playing state like the working example
      _isPlaying = status.status == 2; // 2 = Start/Playing state

      // Clear loading state when player is initialized or playing
      if (status.status == 1 || status.status == 2) {
        // 1 = Init, 2 = Start
        _isConnecting = false;
      }
    });

    switch (status.status) {
      case 1: // Init - Player is ready but not playing
        _isPlayerInitialized = true;
        _connectionAttempts = 0; // Reset attempts when properly initialized
        _updateState(EzvizSimplePlayerState.initialized);
        debugPrint('✅ Player initialized and ready');

        // Only auto-start if configured and not already connecting
        if (widget.config.autoPlay && !_isConnecting && !_isPlaying) {
          debugPrint('🚀 Auto-starting stream...');
          // Use the same approach as the working example
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted && !_isConnecting && !_isPlaying) {
              _startLiveStream();
            }
          });
        }
        break;

      case 2: // Start/Playing
        _connectionAttempts = 0; // Reset attempts on successful connection
        _isConnecting = false;
        _updateState(EzvizSimplePlayerState.playing);
        debugPrint('🎬 Stream is now playing');

        // Auto-enable audio if configured
        if (widget.config.enableAudio && !_soundEnabled) {
          _enableAudio();
        }
        break;

      case 3: // Pause
        _isConnecting = false;
        _updateState(EzvizSimplePlayerState.paused);
        break;

      case 4: // Stop
        _isConnecting = false;
        _updateState(EzvizSimplePlayerState.stopped);
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
            // Handle other errors without automatic retry like working example
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

  /// Initialize player (like the working example)
  Future<void> _initializePlayer() async {
    if (_controller == null) return;

    setState(() {
      _error = null;
    });

    try {
      debugPrint(
        '🎯 Initializing player for device: ${widget.deviceSerial}, channel: ${widget.channelNo}',
      );

      // Re-initialize SDK like the working example does
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

      // Set encryption password if available
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

  /// Start live stream (separated like in working example)
  Future<void> _startLiveStream() async {
    if (_controller == null || _isConnecting) return;

    // Check if we've exceeded max attempts
    if (_connectionAttempts >= _maxConnectionAttempts) {
      _handleError(
        'Maximum connection attempts exceeded. Please check camera status in EZviz mobile app.',
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

      final success = await _controller!.startRealPlay();
      if (success) {
        debugPrint('✅ Live stream started successfully');
        // Don't set _isPlaying here, let the status handler do it
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
      final success = await _controller!.stopRealPlay();
      if (success) {
        debugPrint('🛑 Live stream stopped successfully');
      }
    } catch (e) {
      debugPrint('❌ Error stopping live stream: $e');
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
              final textField = context
                  .findAncestorWidgetOfExactType<TextField>();
              // This is a simplified implementation - in practice you'd use a TextEditingController
              Navigator.of(context).pop(
                '',
              ); // Return empty for now, user should implement onPasswordRequired
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

    // Restart controls timer on user interaction
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

  /// Toggle play/pause
  Future<void> _togglePlayPause() async {
    if (_controller == null) return;

    // Restart controls timer on user interaction
    if (widget.config.hideControlsOnTap && _showControls) {
      _startControlsTimer();
    }

    if (_isPlaying) {
      await _stopLiveStream();
    } else {
      // Reset connection attempts when manually starting
      _connectionAttempts = 0;
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
    if (!mounted) return; // Prevent errors when widget is disposed

    setState(() {
      _state = newState;
    });
    widget.onStateChanged?.call(newState);
  }

  /// Handle errors
  void _handleError(String error) {
    if (!mounted) return; // Prevent errors when widget is disposed

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

  /// Build controls overlay
  Widget _buildControlsOverlay() {
    // This method is deprecated - we now use external controls
    return const SizedBox.shrink();
  }

  /// Start controls auto-hide timer
  void _startControlsTimer() {
    // No longer needed - controls are always visible externally
    return;
  }

  /// Handle tap on video area
  void _onVideoTap() {
    // No longer needed - controls are external
    return;
  }

  /// Toggle fullscreen mode
  void _toggleFullscreen() {
    if (!widget.config.allowFullscreen) return;

    setState(() {
      _isFullscreen = !_isFullscreen;
    });

    if (_isFullscreen) {
      _enterFullscreen();
    }
  }

  /// Enter fullscreen mode using overlay
  void _enterFullscreen() async {
    debugPrint('🎬 Entering fullscreen mode...');

    // Hide system UI for immersive fullscreen
    debugPrint('🖥️ Hiding system UI...');
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    if (!mounted) return; // Check if widget is still mounted after awaits

    debugPrint('🚀 Navigating to fullscreen overlay');
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, _) => _FullscreenOverlay(
          child: _buildVideoArea(), // Reuse the same video area
          deviceSerial: widget.deviceSerial,
          channelNo: widget.channelNo,
          isPlaying: _isPlaying,
          soundEnabled: _soundEnabled,
          onTogglePlayPause: _togglePlayPause,
          onToggleSound: _toggleAudio,
          autoRotate: widget.config.autoRotate, // Pass the setting
          onExit: () {
            _exitFullscreen();
          },
        ),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  /// Exit fullscreen mode and restore orientation
  void _exitFullscreen() {
    debugPrint('🎬 Exiting fullscreen mode...');

    // Restore portrait orientation (if auto-rotate was enabled)
    if (widget.config.autoRotate) {
      debugPrint('🔄 Restoring portrait orientation...');
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      debugPrint('✅ Portrait orientation restored');
    } else {
      debugPrint('📱 Auto-rotate was disabled, keeping current orientation');
    }

    // Restore system UI
    debugPrint('🖥️ Restoring system UI...');
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );

    debugPrint('🚀 Closing fullscreen overlay');
    Navigator.of(context).pop();
    setState(() {
      _isFullscreen = false;
    });
    debugPrint('✅ Fullscreen mode exited');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          // Video area (no overlays, no gesture conflicts)
          Expanded(
            child: Container(width: double.infinity, child: _buildVideoArea()),
          ),

          // Controls area (always visible, outside video)
          if (widget.config.showControls) _buildExternalControls(),
        ],
      ),
    );
  }

  /// Build video area without any overlays
  Widget _buildVideoArea() {
    if (_state == EzvizSimplePlayerState.error) {
      return _buildErrorWidget();
    } else if (_state == EzvizSimplePlayerState.initializing ||
        _state == EzvizSimplePlayerState.connecting ||
        _state == EzvizSimplePlayerState.passwordRequired) {
      return _buildLoadingWidget();
    } else {
      return EzvizPlayer(
        onCreated: (controller) {
          _controller = controller;
          _setupPlayerEventHandlers();
          _initializePlayer();
        },
      );
    }
  }

  /// Build external controls (always visible, below video)
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

          // Connection status indicator (compact)
          if (!isCompact) // Hide status in ultra-compact mode
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
                  Icons.fullscreen,
                  color: widget.config.controlsIconColor ?? Colors.white,
                  size: iconSize - 2,
                ),
                onPressed: _toggleFullscreen,
                tooltip: 'Fullscreen',
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

  /// Get shorter text for state indicator
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

/// Fullscreen overlay that reuses the existing video player
class _FullscreenOverlay extends StatefulWidget {
  final Widget child; // The existing video player widget
  final String deviceSerial;
  final int channelNo;
  final bool isPlaying;
  final bool soundEnabled;
  final VoidCallback onTogglePlayPause;
  final VoidCallback onToggleSound;
  final bool autoRotate;
  final VoidCallback onExit;

  const _FullscreenOverlay({
    required this.child,
    required this.deviceSerial,
    required this.channelNo,
    required this.isPlaying,
    required this.soundEnabled,
    required this.onTogglePlayPause,
    required this.onToggleSound,
    required this.autoRotate,
    required this.onExit,
  });

  @override
  State<_FullscreenOverlay> createState() => _FullscreenOverlayState();
}

class _FullscreenOverlayState extends State<_FullscreenOverlay> {
  bool _showControls = true;
  Timer? _controlsTimer;

  @override
  void initState() {
    super.initState();
    _startControlsTimer();

    // Set landscape orientation after the page is displayed (more aggressive approach)
    if (widget.autoRotate) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        debugPrint('🔄 Setting landscape orientation in fullscreen...');

        // Try landscape left first
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
        ]);

        // Wait longer for the change to take effect
        await Future.delayed(const Duration(milliseconds: 300));

        // Then allow both landscape orientations
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);

        debugPrint('✅ Landscape orientation set in fullscreen');
      });
    }
  }

  @override
  void dispose() {
    _controlsTimer?.cancel();

    // Ensure orientation is restored if user exits via system navigation (only if auto-rotate was enabled)
    if (widget.autoRotate) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );

    super.dispose();
  }

  void _startControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _showControls) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _onTap() {
    setState(() {
      _showControls = !_showControls;
    });

    if (_showControls) {
      _startControlsTimer();
    } else {
      _controlsTimer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _onTap,
        child: Stack(
          children: [
            // Reuse the existing video player (no new stream!)
            SizedBox.expand(child: widget.child),

            // Fullscreen controls overlay
            Positioned.fill(
              child: AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: IgnorePointer(
                  ignoring: !_showControls,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
                        ],
                        stops: const [0.0, 0.3, 0.7, 1.0],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        children: [
                          // Top controls
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                // Back button
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  onPressed: widget.onExit,
                                ),
                                const Spacer(),
                                // Device info
                                Text(
                                  '${widget.deviceSerial} - Channel ${widget.channelNo}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),

                          // Bottom controls
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Play/Pause button for fullscreen
                                IconButton(
                                  icon: Icon(
                                    widget.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 48,
                                  ),
                                  onPressed: widget.onTogglePlayPause,
                                ),

                                const SizedBox(width: 32),

                                // Audio button for fullscreen
                                IconButton(
                                  icon: Icon(
                                    widget.soundEnabled
                                        ? Icons.volume_up
                                        : Icons.volume_off,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                  onPressed: widget.onToggleSound,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
