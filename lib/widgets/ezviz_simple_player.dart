import 'package:flutter/material.dart';
import '../ezviz_flutter.dart';

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
  
  /// UI customization
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final TextStyle? loadingTextStyle;
  final Color? controlsBackgroundColor;
  final Color? controlsIconColor;
  
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
    this.loadingWidget,
    this.errorWidget,
    this.loadingTextStyle,
    this.controlsBackgroundColor,
    this.controlsIconColor,
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

  @override
  void initState() {
    super.initState();
    _currentPassword = widget.encryptionPassword;
    _initializeSDK();
  }

  @override
  void dispose() {
    _controller?.stopRealPlay();
    _controller?.release();
    super.dispose();
  }

  /// Initialize the EZVIZ SDK
  Future<void> _initializeSDK() async {
    try {
      _updateState(EzvizSimplePlayerState.initializing);
      
      // Initialize SDK
      final initOptions = EzvizInitOptions(
        appKey: widget.config.appKey,
        accessToken: widget.config.accessToken ?? "",
        enableLog: true,
        enableP2P: false,
      );
      await EzvizManager.shared().initSDK(initOptions);
      
      _isSDKInitialized = true;
      _updateState(EzvizSimplePlayerState.initialized);
      
    } catch (e) {
      _handleError('SDK initialization failed: $e');
    }
  }

  /// Setup player event handlers
  void _setupPlayerEventHandlers() {
    if (_controller == null) return;
    
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
        _handleError('Player event error: $error');
      },
    );
  }

  /// Handle player status changes
  void _handlePlayerStatus(EzvizPlayerStatus status) {
    switch (status.status) {
      case 1: // Init
        _updateState(EzvizSimplePlayerState.initialized);
        if (widget.config.autoPlay) {
          _startStream();
        }
        break;
      case 2: // Start/Playing
        setState(() {
          _isPlaying = true;
        });
        _updateState(EzvizSimplePlayerState.playing);
        
        // Auto-enable audio if configured
        if (widget.config.enableAudio && !_soundEnabled) {
          _enableAudio();
        }
        break;
      case 3: // Pause
        setState(() {
          _isPlaying = false;
        });
        _updateState(EzvizSimplePlayerState.paused);
        break;
      case 4: // Stop
        setState(() {
          _isPlaying = false;
        });
        _updateState(EzvizSimplePlayerState.stopped);
        break;
      case 5: // Error
        if (status.message != null) {
          final errorMsg = status.message!.toLowerCase();
          if (errorMsg.contains('password') || 
              errorMsg.contains('verification') ||
              errorMsg.contains('encrypt')) {
            _handlePasswordRequired();
          } else {
            _handleError(status.message!);
          }
        }
        break;
    }
  }

  /// Start the video stream
  Future<void> _startStream() async {
    if (_controller == null) return;
    
    try {
      _updateState(EzvizSimplePlayerState.connecting);
      
      // Initialize player for device
      await _controller!.initPlayerByDevice(widget.deviceSerial, widget.channelNo);
      
      // Set encryption password if available
      if (_currentPassword != null) {
        await _controller!.setPlayVerifyCode(_currentPassword!);
      }
      
      // Start real play
      final success = await _controller!.startRealPlay();
      if (!success && _currentPassword == null) {
        _handlePasswordRequired();
      }
    } catch (e) {
      _handleError('Failed to start stream: $e');
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
        await _startStream();
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
            const Text('This camera is encrypted and requires a verification code.'),
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
              final textField = context.findAncestorWidgetOfExactType<TextField>();
              // This is a simplified implementation - in practice you'd use a TextEditingController
              Navigator.of(context).pop(''); // Return empty for now, user should implement onPasswordRequired
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
    
    if (_isPlaying) {
      await _controller!.stopRealPlay();
    } else {
      await _startStream();
    }
  }

  /// Update state and notify callback
  void _updateState(EzvizSimplePlayerState newState) {
    setState(() {
      _state = newState;
    });
    widget.onStateChanged?.call(newState);
  }

  /// Handle errors
  void _handleError(String error) {
    setState(() {
      _error = error;
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
            style: widget.config.loadingTextStyle ??
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
          ElevatedButton(
            onPressed: () {
              setState(() {
                _error = null;
              });
              _initializeSDK();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  /// Build controls overlay
  Widget _buildControlsOverlay() {
    if (!widget.config.showControls) return const SizedBox.shrink();
    
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: widget.config.controlsBackgroundColor ?? 
              Colors.black.withOpacity(0.7),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                color: widget.config.controlsIconColor ?? Colors.white,
              ),
              onPressed: _togglePlayPause,
            ),
            if (widget.config.enableAudio)
              IconButton(
                icon: Icon(
                  _soundEnabled ? Icons.volume_up : Icons.volume_off,
                  color: widget.config.controlsIconColor ?? Colors.white,
                ),
                onPressed: _toggleAudio,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // Main player area
          if (_state == EzvizSimplePlayerState.error)
            _buildErrorWidget()
          else if (_state == EzvizSimplePlayerState.initializing ||
                   _state == EzvizSimplePlayerState.connecting ||
                   _state == EzvizSimplePlayerState.passwordRequired)
            _buildLoadingWidget()
          else
            EzvizPlayer(
              onCreated: (controller) {
                _controller = controller;
                _setupPlayerEventHandlers();
                if (_isSDKInitialized && widget.config.autoPlay) {
                  _startStream();
                }
              },
            ),
          
          // Controls overlay
          _buildControlsOverlay(),
        ],
      ),
    );
  }
}