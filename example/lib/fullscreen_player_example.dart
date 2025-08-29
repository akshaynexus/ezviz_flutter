import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ezviz_flutter/widgets/ezviz_simple_player.dart';

/// Example demonstrating the fullscreen-capable EZVIZ simple player
class FullscreenPlayerExample extends StatefulWidget {
  final String appKey;
  final String appSecret;
  final String accessToken;
  final String deviceSerial;
  final int channelNo;
  final String? encryptionPassword;

  const FullscreenPlayerExample({
    super.key,
    required this.appKey,
    required this.appSecret,
    required this.accessToken,
    required this.deviceSerial,
    required this.channelNo,
    this.encryptionPassword,
  });

  @override
  State<FullscreenPlayerExample> createState() => _FullscreenPlayerExampleState();
}

class _FullscreenPlayerExampleState extends State<FullscreenPlayerExample> {
  bool _isFullscreen = false;

  @override
  void initState() {
    super.initState();
    // Lock to portrait initially
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    // Restore all orientations when leaving
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  void _onStateChanged(EzvizSimplePlayerState state) {
    debugPrint('Player state changed: $state');
  }

  void _handleError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Player Error: $error'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check orientation to determine if we're in fullscreen
    _isFullscreen = MediaQuery.of(context).orientation == Orientation.landscape;
    
    return Scaffold(
      appBar: !_isFullscreen
          ? AppBar(
              title: const Text('EZVIZ Fullscreen Player'),
            )
          : null,
      body: Column(
        children: [
          // The player widget with fullscreen support
          EzvizSimplePlayer(
            deviceSerial: widget.deviceSerial,
            channelNo: widget.channelNo,
            config: EzvizPlayerConfig(
              appKey: widget.appKey,
              appSecret: widget.appSecret,
              accessToken: widget.accessToken,
              autoPlay: true,
              enableAudio: true,
              showControls: true,
              allowFullscreen: true,
              autoRotate: true,
              enableDoubleTapSeek: true,
              enableSwipeSeek: true,
            ),
            encryptionPassword: widget.encryptionPassword,
            onStateChanged: _onStateChanged,
            onError: _handleError,
          ),
          
          // Other UI elements (hidden in fullscreen)
          if (!_isFullscreen) ...[
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Device Information',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text('Serial: ${widget.deviceSerial}'),
                          Text('Channel: ${widget.channelNo}'),
                          Text('Status: ${_isFullscreen ? "Fullscreen" : "Normal"}'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tips:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('• Tap the fullscreen button in player controls to enter fullscreen mode'),
                  const Text('• In fullscreen, tap the screen to show/hide controls'),
                  const Text('• Use back button or exit button to leave fullscreen'),
                  const Text('• Audio controls are available in both modes'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Usage example for the fullscreen player
class FullscreenPlayerUsageExample extends StatelessWidget {
  const FullscreenPlayerUsageExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EZVIZ Fullscreen Player Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const FullscreenPlayerExample(
        appKey: 'YOUR_APP_KEY',
        appSecret: 'YOUR_APP_SECRET',
        accessToken: 'YOUR_ACCESS_TOKEN',
        deviceSerial: 'YOUR_DEVICE_SERIAL',
        channelNo: 1,
        encryptionPassword: null, // Optional: Add if device is encrypted
      ),
    );
  }
}
