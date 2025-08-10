import 'package:flutter/material.dart';
import 'package:ezviz_flutter/ezviz_flutter.dart';

/// Simple example showing how to use EzvizSimplePlayer
class SimplePlayerExample extends StatefulWidget {
  const SimplePlayerExample({super.key});

  @override
  State<SimplePlayerExample> createState() => _SimplePlayerExampleState();
}

class _SimplePlayerExampleState extends State<SimplePlayerExample> {
  EzvizSimplePlayerState? _playerState;
  String? _lastError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EZVIZ Simple Player Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Player Status Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Player State: ${_playerState?.name ?? 'Unknown'}'),
                if (_lastError != null)
                  Text(
                    'Last Error: $_lastError',
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),

          // Video Player
          Expanded(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: EzvizSimplePlayer(
                deviceSerial:
                    'YOUR_DEVICE_SERIAL', // Replace with actual device serial
                channelNo: 1,
                config: EzvizPlayerConfig(
                  appKey: 'YOUR_APP_KEY', // Replace with your app key
                  appSecret: 'YOUR_APP_SECRET', // Replace with your app secret
                  accessToken:
                      'YOUR_ACCESS_TOKEN', // Replace with your access token
                  autoPlay: true,
                  enableAudio: true,
                  showControls: true,
                  enableEncryptionDialog: true,
                  allowFullscreen: true, // Enable YouTube-style fullscreen
                  autoRotate: true, // Auto-rotate to landscape in fullscreen
                  loadingTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  controlsBackgroundColor: Colors.black.withOpacity(0.8),
                  controlsIconColor: Colors.white,
                ),
                onStateChanged: (state) {
                  setState(() {
                    _playerState = state;
                  });
                  debugPrint('Player state changed: ${state.name}');
                },
                onPasswordRequired: () async {
                  // Custom password dialog
                  return await _showPasswordDialog();
                },
                onError: (error) {
                  setState(() {
                    _lastError = error;
                  });
                  debugPrint('Player error: $error');

                  // Show error snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $error'),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
              ),
            ),
          ),

          // Instructions
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Instructions:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  '1. Replace the device serial, app key, and access token with your actual values',
                ),
                Text(
                  '2. The player will auto-initialize, connect, and start playing',
                ),
                Text('3. Use the controls to play/pause and toggle audio'),
                Text(
                  '4. Tap the fullscreen button for YouTube-style fullscreen with quality controls',
                ),
                Text(
                  '5. For encrypted cameras, a password dialog will appear automatically',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Custom password dialog
  Future<String?> _showPasswordDialog() async {
    final TextEditingController passwordController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.lock, color: Colors.orange),
            SizedBox(width: 8),
            Text('Encrypted Camera'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This camera requires a verification code to access the stream.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Verification Code',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.password),
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
          FilledButton(
            onPressed: () => Navigator.of(context).pop(passwordController.text),
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }
}

/// Even simpler example - minimal setup
class MinimalPlayerExample extends StatelessWidget {
  const MinimalPlayerExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minimal EZVIZ Player')),
      body: EzvizSimplePlayer(
        deviceSerial: 'YOUR_DEVICE_SERIAL',
        channelNo: 1,
        config: const EzvizPlayerConfig(
          appKey: 'YOUR_APP_KEY',
          appSecret: 'YOUR_APP_SECRET',
          accessToken: 'YOUR_ACCESS_TOKEN',
          allowFullscreen: true, // Enable fullscreen support
        ),
      ),
    );
  }
}

/// Advanced example with custom UI
class AdvancedPlayerExample extends StatefulWidget {
  const AdvancedPlayerExample({super.key});

  @override
  State<AdvancedPlayerExample> createState() => _AdvancedPlayerExampleState();
}

class _AdvancedPlayerExampleState extends State<AdvancedPlayerExample> {
  EzvizSimplePlayerState _state = EzvizSimplePlayerState.initializing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Advanced EZVIZ Player')),
      body: Column(
        children: [
          // Custom status bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: _getStatusColor(),
            child: Row(
              children: [
                Icon(_getStatusIcon(), color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  _getStatusText(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Player with custom styling
          Expanded(
            child: EzvizSimplePlayer(
              deviceSerial: 'YOUR_DEVICE_SERIAL',
              channelNo: 1,
              config: EzvizPlayerConfig(
                appKey: 'YOUR_APP_KEY',
                appSecret: 'YOUR_APP_SECRET',
                accessToken: 'YOUR_ACCESS_TOKEN',
                autoPlay: true,
                enableAudio: true,
                showControls: false, // We'll add custom controls
                loadingWidget: _buildCustomLoadingWidget(),
                errorWidget: _buildCustomErrorWidget(),
              ),
              onStateChanged: (state) {
                setState(() {
                  _state = state;
                });
              },
              onError: (error) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(error)));
              },
            ),
          ),

          // Custom controls
          _buildCustomControls(),
        ],
      ),
    );
  }

  Widget _buildCustomLoadingWidget() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[900]!, Colors.blue[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 24),
            Text(
              'Connecting to camera...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomErrorWidget() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red[900]!, Colors.red[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.white, size: 64),
            SizedBox(height: 24),
            Text(
              'Failed to connect',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(Icons.play_arrow, 'Play', () {}),
          _buildControlButton(Icons.pause, 'Pause', () {}),
          _buildControlButton(Icons.volume_up, 'Audio', () {}),
          _buildControlButton(Icons.fullscreen, 'Fullscreen', () {}),
        ],
      ),
    );
  }

  Widget _buildControlButton(
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: onPressed,
        ),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Color _getStatusColor() {
    switch (_state) {
      case EzvizSimplePlayerState.playing:
        return Colors.green;
      case EzvizSimplePlayerState.error:
        return Colors.red;
      case EzvizSimplePlayerState.passwordRequired:
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  IconData _getStatusIcon() {
    switch (_state) {
      case EzvizSimplePlayerState.playing:
        return Icons.play_circle;
      case EzvizSimplePlayerState.error:
        return Icons.error;
      case EzvizSimplePlayerState.passwordRequired:
        return Icons.lock;
      default:
        return Icons.info;
    }
  }

  String _getStatusText() {
    switch (_state) {
      case EzvizSimplePlayerState.initializing:
        return 'Initializing SDK...';
      case EzvizSimplePlayerState.initialized:
        return 'SDK Ready';
      case EzvizSimplePlayerState.connecting:
        return 'Connecting to camera...';
      case EzvizSimplePlayerState.playing:
        return 'Live Stream Active';
      case EzvizSimplePlayerState.paused:
        return 'Stream Paused';
      case EzvizSimplePlayerState.stopped:
        return 'Stream Stopped';
      case EzvizSimplePlayerState.error:
        return 'Connection Error';
      case EzvizSimplePlayerState.passwordRequired:
        return 'Verification Required';
    }
  }
}
