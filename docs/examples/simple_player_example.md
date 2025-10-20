# EzvizSimplePlayer Examples

This document demonstrates various usage patterns for the `EzvizSimplePlayer` widget - the easiest way to integrate EZVIZ cameras with automatic handling of all functionality.

## Features

- ✅ **Auto SDK initialization** - Handles all SDK setup automatically
- ✅ **Auto authentication** - Manages login and tokens internally  
- ✅ **Auto-play** - Starts streaming immediately when ready
- ✅ **Error handling** - Comprehensive error management with callbacks
- ✅ **Encryption support** - Auto-detects and prompts for encrypted cameras
- ✅ **Audio control** - Easy enable/disable audio functionality
- ✅ **Built-in controls** - Play/pause and audio toggle controls
- ✅ **State management** - Real-time state updates and notifications
- ✅ **Customizable UI** - Custom loading/error widgets and styling

## Basic Usage Examples

### Minimal Setup (3 lines of code)

The simplest possible integration:

```dart
import 'package:ezviz_flutter/ezviz_flutter.dart';

class MinimalVideoPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('EZVIZ Camera')),
      body: EzvizSimplePlayer(
        deviceSerial: 'YOUR_DEVICE_SERIAL',
        channelNo: 1,
        config: EzvizPlayerConfig(
          appKey: 'YOUR_APP_KEY',
          accessToken: 'YOUR_ACCESS_TOKEN',
        ),
      ),
    );
  }
}
```

### Standard Setup with Basic Callbacks

Add state monitoring and error handling:

```dart
class StandardVideoPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('EZVIZ Camera')),
      body: EzvizSimplePlayer(
        deviceSerial: 'YOUR_DEVICE_SERIAL',
        channelNo: 1,
        config: EzvizPlayerConfig(
          appKey: 'YOUR_APP_KEY',
          accessToken: 'YOUR_ACCESS_TOKEN',
          autoPlay: true,
          enableAudio: true,
          showControls: true,
        ),
        onStateChanged: (state) {
          switch (state) {
            case EzvizSimplePlayerState.playing:
              print('Stream is playing');
              break;
            case EzvizSimplePlayerState.stopped:
              print('Stream stopped');
              break;
            case EzvizSimplePlayerState.error:
              print('Error occurred');
              break;
            case EzvizSimplePlayerState.loading:
              print('Loading stream...');
              break;
          }
        },
        onError: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Player Error: $error'),
              backgroundColor: Colors.red,
            ),
          );
        },
      ),
    );
  }
}
```

### Advanced Setup with All Features

Complete setup with custom UI and callbacks:

```dart
class AdvancedVideoPlayer extends StatefulWidget {
  @override
  _AdvancedVideoPlayerState createState() => _AdvancedVideoPlayerState();
}

class _AdvancedVideoPlayerState extends State<AdvancedVideoPlayer> {
  EzvizSimplePlayerState currentState = EzvizSimplePlayerState.loading;
  String? lastError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advanced EZVIZ Player'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          // Status indicator
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _getStatusColor(),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Status Bar
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            color: Colors.grey[100],
            child: Row(
              children: [
                Icon(_getStatusIcon(), color: _getStatusColor()),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getStatusText(),
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          
          // Video Player
          Expanded(
            child: EzvizSimplePlayer(
              deviceSerial: 'YOUR_DEVICE_SERIAL',
              channelNo: 1,
              config: EzvizPlayerConfig(
                appKey: 'YOUR_APP_KEY',
                accessToken: 'YOUR_ACCESS_TOKEN',
                autoPlay: true,
                enableAudio: true,
                showControls: false, // We'll use custom controls
                enableEncryptionDialog: true,
                loadingWidget: _buildCustomLoadingWidget(),
                errorWidget: _buildCustomErrorWidget(),
                loadingTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                controlsBackgroundColor: Colors.black.withOpacity(0.8),
                controlsIconColor: Colors.white,
              ),
              onStateChanged: (state) {
                setState(() {
                  currentState = state;
                });
              },
              onError: (error) {
                setState(() {
                  lastError = error;
                });
                _showErrorDialog(error);
              },
              onPasswordRequired: () async {
                return await _showPasswordDialog();
              },
            ),
          ),
          
          // Custom Controls
          _buildCustomControls(),
        ],
      ),
    );
  }

  Widget _buildCustomLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.blue),
          SizedBox(height: 16),
          Text(
            'Connecting to camera...',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 48),
          SizedBox(height: 16),
          Text(
            'Connection Failed',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(height: 8),
          Text(
            lastError ?? 'Unknown error',
            style: TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomControls() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey[900],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: currentState == EzvizSimplePlayerState.playing 
                ? Icons.pause : Icons.play_arrow,
            label: currentState == EzvizSimplePlayerState.playing 
                ? 'Pause' : 'Play',
            onPressed: _togglePlayback,
            color: Colors.blue,
          ),
          _buildControlButton(
            icon: Icons.stop,
            label: 'Stop',
            onPressed: _stopPlayback,
            color: Colors.red,
          ),
          _buildControlButton(
            icon: Icons.volume_up,
            label: 'Audio',
            onPressed: _toggleAudio,
            color: Colors.green,
          ),
          _buildControlButton(
            icon: Icons.fullscreen,
            label: 'Fullscreen',
            onPressed: _toggleFullscreen,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            shape: CircleBorder(),
            padding: EdgeInsets.all(12),
          ),
          child: Icon(icon),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }

  Future<String?> _showPasswordDialog() async {
    final controller = TextEditingController();
    
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Device Password Required'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('This camera requires a password to access.'),
            SizedBox(height: 16),
            TextField(
              controller: controller,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter device password',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: Text('Connect'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Connection Error'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Retry connection logic could go here
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (currentState) {
      case EzvizSimplePlayerState.playing:
        return Colors.green;
      case EzvizSimplePlayerState.loading:
        return Colors.orange;
      case EzvizSimplePlayerState.error:
        return Colors.red;
      case EzvizSimplePlayerState.stopped:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon() {
    switch (currentState) {
      case EzvizSimplePlayerState.playing:
        return Icons.play_circle;
      case EzvizSimplePlayerState.loading:
        return Icons.hourglass_empty;
      case EzvizSimplePlayerState.error:
        return Icons.error;
      case EzvizSimplePlayerState.stopped:
        return Icons.stop_circle;
    }
  }

  String _getStatusText() {
    switch (currentState) {
      case EzvizSimplePlayerState.playing:
        return 'Live stream active';
      case EzvizSimplePlayerState.loading:
        return 'Connecting to camera...';
      case EzvizSimplePlayerState.error:
        return 'Connection failed: ${lastError ?? "Unknown error"}';
      case EzvizSimplePlayerState.stopped:
        return 'Stream stopped';
    }
  }

  void _togglePlayback() {
    // Control methods would be exposed by the player widget
    // For now, this is a placeholder
  }

  void _stopPlayback() {
    // Stop playback logic
  }

  void _toggleAudio() {
    // Toggle audio logic
  }

  void _toggleFullscreen() {
    // Toggle fullscreen logic
  }
}
```

## Configuration Options

### EzvizPlayerConfig Properties

```dart
EzvizPlayerConfig(
  // Required credentials
  appKey: 'YOUR_APP_KEY',
  accessToken: 'YOUR_ACCESS_TOKEN',

  // Behavior settings
  autoPlay: true,              // Start playing automatically
  enableAudio: true,           // Enable audio by default
  showControls: true,          // Show built-in controls
  enableEncryptionDialog: true, // Auto-handle encrypted cameras

  // UI customization
  loadingWidget: CustomWidget(),     // Custom loading indicator
  errorWidget: CustomErrorWidget(),  // Custom error display
  loadingTextStyle: TextStyle(...),  // Loading text styling
  controlsBackgroundColor: Colors.black.withOpacity(0.8),
  controlsIconColor: Colors.white,
)
```

## State Management

### Player States

```dart
enum EzvizSimplePlayerState {
  loading,    // Connecting to camera
  playing,    // Stream is active
  stopped,    // Stream has stopped
  error,      // Error occurred
}
```

### State Handling Example

```dart
class StateAwarePlayer extends StatefulWidget {
  @override
  _StateAwarePlayerState createState() => _StateAwarePlayerState();
}

class _StateAwarePlayerState extends State<StateAwarePlayer> {
  EzvizSimplePlayerState currentState = EzvizSimplePlayerState.loading;
  
  @override
  Widget build(BuildContext context) {
    return EzvizSimplePlayer(
      deviceSerial: 'YOUR_DEVICE_SERIAL',
      channelNo: 1,
      config: EzvizPlayerConfig(
        appKey: 'YOUR_APP_KEY',
        accessToken: 'YOUR_ACCESS_TOKEN',
      ),
      onStateChanged: (state) {
        setState(() {
          currentState = state;
        });
        
        // Handle state changes
        switch (state) {
          case EzvizSimplePlayerState.playing:
            _onStreamStarted();
            break;
          case EzvizSimplePlayerState.error:
            _onStreamError();
            break;
          case EzvizSimplePlayerState.stopped:
            _onStreamStopped();
            break;
          case EzvizSimplePlayerState.loading:
            _onStreamLoading();
            break;
        }
      },
    );
  }

  void _onStreamStarted() {
    print('Stream started successfully');
    // Update UI, start analytics, etc.
  }

  void _onStreamError() {
    print('Stream encountered an error');
    // Show error message, retry logic, etc.
  }

  void _onStreamStopped() {
    print('Stream stopped');
    // Clean up resources, update UI, etc.
  }

  void _onStreamLoading() {
    print('Stream is loading');
    // Show loading indicators, etc.
  }
}
```

## Integration Tips

### 1. Error Handling Best Practices

Always provide comprehensive error handling:

```dart
onError: (error) {
  // Log error for debugging
  print('Player error: $error');
  
  // Show user-friendly message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(_getFriendlyErrorMessage(error)),
      action: SnackBarAction(
        label: 'Retry',
        onPressed: () {
          // Retry logic
        },
      ),
    ),
  );
},

String _getFriendlyErrorMessage(String error) {
  if (error.contains('network')) {
    return 'Network connection failed. Please check your internet.';
  } else if (error.contains('auth')) {
    return 'Authentication failed. Please check your credentials.';
  } else if (error.contains('device')) {
    return 'Camera is not available. Please check device status.';
  } else {
    return 'Connection failed. Please try again.';
  }
}
```

### 2. Credential Management

Store credentials securely:

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CredentialManager {
  static const _storage = FlutterSecureStorage();
  
  static Future<EzvizPlayerConfig> loadConfig() async {
    final appKey = await _storage.read(key: 'ezviz_app_key');
    final accessToken = await _storage.read(key: 'ezviz_access_token');

    return EzvizPlayerConfig(
      appKey: appKey ?? '',
      accessToken: accessToken ?? '',
    );
  }
}
```

### 3. Performance Optimization

Optimize for better performance:

```dart
class OptimizedPlayer extends StatefulWidget {
  @override
  _OptimizedPlayerState createState() => _OptimizedPlayerState();
}

class _OptimizedPlayerState extends State<OptimizedPlayer> 
    with AutomaticKeepAliveClientMixin {
  
  @override
  bool get wantKeepAlive => true; // Keep widget alive
  
  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    return EzvizSimplePlayer(
      deviceSerial: 'YOUR_DEVICE_SERIAL',
      channelNo: 1,
      config: EzvizPlayerConfig(
        appKey: 'YOUR_APP_KEY',
        accessToken: 'YOUR_ACCESS_TOKEN',
        autoPlay: false, // Don't auto-play for better control
      ),
    );
  }
  
  @override
  void dispose() {
    // Clean up resources
    super.dispose();
  }
}
```

## Common Use Cases

### Multi-Camera Display

```dart
class MultiCameraView extends StatelessWidget {
  final List<String> deviceSerials = ['DEVICE1', 'DEVICE2', 'DEVICE3', 'DEVICE4'];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 16/9,
      ),
      itemCount: deviceSerials.length,
      itemBuilder: (context, index) {
        return Card(
          child: EzvizSimplePlayer(
            deviceSerial: deviceSerials[index],
            channelNo: 1,
            config: EzvizPlayerConfig(
              appKey: 'YOUR_APP_KEY',
              accessToken: 'YOUR_ACCESS_TOKEN',
              autoPlay: true,
              enableAudio: false, // Disable audio for multi-camera
              showControls: false, // Minimal UI for grid view
            ),
          ),
        );
      },
    );
  }
}
```

### Fullscreen Player

```dart
class FullscreenPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Fullscreen player
            EzvizSimplePlayer(
              deviceSerial: 'YOUR_DEVICE_SERIAL',
              channelNo: 1,
              config: EzvizPlayerConfig(
                appKey: 'YOUR_APP_KEY',
                accessToken: 'YOUR_ACCESS_TOKEN',
                autoPlay: true,
                enableAudio: true,
                showControls: true,
              ),
            ),
            
            // Back button
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```