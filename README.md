# EZVIZ Flutter SDK

A comprehensive Flutter plugin for EZVIZ camera integration with support for device management, live streaming, PTZ control, audio/intercom, recording, Wi-Fi configuration, and more. This plugin provides both native Android/iOS SDK integration and HTTP API access.

[![pub package](https://img.shields.io/pub/v/ezviz_flutter.svg)](https://pub.dev/packages/ezviz_flutter)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Looking for a example on how to use this,check out this repo which implements api auth,devvice list getting and display of camera stream 
https://github.com/akshaynexus/ezviz_flutter_example_app


## Features

### Native SDK Features (Android/iOS)
- 🎥 **Live Video Streaming** - Real-time video playback with native performance
- 🎮 **PTZ Control** - Pan, tilt, zoom camera control with circular touch panel
- 📱 **Device Management** - Add, remove, and manage EZVIZ devices
- 🔐 **Authentication** - Secure login and access token management
- 📹 **Video Playback** - Replay recorded videos with enhanced controls
- 🔧 **Video Quality Control** - Adjust streaming quality (smooth, balanced, HD, UHD)
- 🌐 **Network Device Support** - Connect to local network cameras
- 🎤 **Audio & Intercom** - Two-way audio communication (half/full-duplex)
- 📸 **Recording & Screenshots** - Capture video recordings and screenshots
- 📶 **Wi-Fi Configuration** - Configure device network settings (Wi-Fi, AP, Sound Wave)
- 🎛️ **Enhanced UI Controls** - Professional video player interface with full-screen support

### HTTP API Features
- 🔑 **Authentication** - Login, logout, refresh tokens
- 📋 **Device Management** - List, add, remove devices
- 🎯 **PTZ Control** - Camera movement and zoom
- 🚨 **Alarm Management** - Handle device alarms and notifications
- ☁️ **Cloud Storage** - Manage cloud recordings
- 👥 **Sub-Account Management** - RAM account operations
- 🔍 **Detector Management** - Motion detection settings

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  ezviz_flutter: ^1.0.4
```

Then run:

```bash
flutter pub get
```

## Platform Setup

### Android Setup

1. Add the following to your `android/app/build.gradle`:

```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
        ndk {
            abiFilters "armeabi-v7a", "arm64-v8a"
        }
    }

    sourceSets {
        main {
            jniLibs.srcDirs = ['libs']
        }
    }
}
```

2. Add network permissions to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WAKE_LOCK"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
```

### iOS Setup

1. Add the following to your `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to view EZVIZ cameras</string>
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access for audio streaming and intercom</string>
<key>NSLocalNetworkUsageDescription</key>
<string>This app needs local network access to connect to EZVIZ cameras</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>This app needs access to save screenshots and recordings</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs access to the photo library</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs location access for Wi-Fi configuration</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access for Wi-Fi configuration</string>
```

2. Set minimum iOS version to 12.0 in `ios/Runner.xcodeproj/project.pbxproj`:

```
IPHONEOS_DEPLOYMENT_TARGET = 12.0;
```

3. In Xcode, add capabilities:
   - Access WiFi Information
   - Hotspot Configuration

## Quick Start

### 1. Initialize the SDK

```dart
import 'package:ezviz_flutter/ezviz_flutter.dart';

// Initialize the native SDK
Future<void> initializeEzvizSDK() async {
  final options = EzvizInitOptions(
    appKey: 'your_app_key',
    accessToken: 'your_access_token',
    enableLog: true,
    enableP2P: false,
  );
  
  final success = await EzvizManager.shared().initSDK(options);
  if (success) {
    print('EZVIZ SDK initialized successfully');
  }
}
```

### 2. Enhanced Live Video Streaming

```dart
class EnhancedLiveStreamPage extends StatefulWidget {
  @override
  _EnhancedLiveStreamPageState createState() => _EnhancedLiveStreamPageState();
}

class _EnhancedLiveStreamPageState extends State<EnhancedLiveStreamPage> {
  EzvizPlayerController? playerController;
  bool isPlaying = false;
  bool isRecording = false;
  bool soundEnabled = false;
  bool isFullScreen = false;
  int currentQuality = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Video Player
          Container(
            width: double.infinity,
            height: isFullScreen ? MediaQuery.of(context).size.height : 300,
            child: EzvizPlayer(
              onCreated: (controller) {
                playerController = controller;
                _initializePlayer();
              },
            ),
          ),
          // Enhanced Controls Overlay
          Container(
            width: double.infinity,
            height: isFullScreen ? MediaQuery.of(context).size.height : 300,
            child: EnhancedPlayerControls(
              isPlaying: isPlaying,
              isRecording: isRecording,
              soundEnabled: soundEnabled,
              isFullScreen: isFullScreen,
              currentQuality: currentQuality,
              onPlayPause: _togglePlayback,
              onStop: _stopPlayback,
              onRecord: _toggleRecording,
              onScreenshot: _takeScreenshot,
              onSoundToggle: _toggleSound,
              onFullScreenToggle: _toggleFullScreen,
              onQualityChange: _changeQuality,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _initializePlayer() async {
    await playerController?.initPlayerByDevice('DEVICE_SERIAL', 1);
    await playerController?.setPlayVerifyCode('VERIFY_CODE');
  }

  Future<void> _togglePlayback() async {
    if (isPlaying) {
      await playerController?.stopRealPlay();
    } else {
      await playerController?.startRealPlay();
    }
    setState(() => isPlaying = !isPlaying);
  }

  Future<void> _toggleRecording() async {
    if (isRecording) {
      await playerController?.stopRecording();
    } else {
      await playerController?.startRecording();
    }
    setState(() => isRecording = !isRecording);
  }

  Future<void> _takeScreenshot() async {
    final imagePath = await playerController?.capturePicture();
    if (imagePath != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Screenshot saved: $imagePath')),
      );
    }
  }

  Future<void> _toggleSound() async {
    if (soundEnabled) {
      await playerController?.closeSound();
    } else {
      await playerController?.openSound();
    }
    setState(() => soundEnabled = !soundEnabled);
  }

  // ... other methods
}
```

### 3. Circular PTZ Control Panel

```dart
class PTZControlPage extends StatelessWidget {
  final String deviceSerial = "YOUR_DEVICE_SERIAL";
  final int cameraId = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PTZ Control')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular PTZ Control Panel
            PTZControlPanel(
              size: 250,
              backgroundColor: Colors.black.withOpacity(0.3),
              activeColor: Colors.blue,
              borderColor: Colors.white,
              centerIcon: Icon(Icons.camera_alt, color: Colors.grey[700]),
              onDirectionStart: (direction) => _startPTZ(direction),
              onDirectionStop: (direction) => _stopPTZ(direction),
              onCenterTap: () => _centerCamera(),
            ),
            SizedBox(height: 40),
            // Zoom Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildZoomButton('Zoom In', EzvizPtzCommands.ZoomIn),
                _buildZoomButton('Zoom Out', EzvizPtzCommands.ZoomOut),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startPTZ(String direction) async {
    String command;
    switch (direction) {
      case 'UP':
        command = EzvizPtzCommands.Up;
        break;
      case 'DOWN':
        command = EzvizPtzCommands.Down;
        break;
      case 'LEFT':
        command = EzvizPtzCommands.Left;
        break;
      case 'RIGHT':
        command = EzvizPtzCommands.Right;
        break;
      default:
        return;
    }

    await EzvizManager.shared().controlPTZ(
      deviceSerial,
      cameraId,
      command,
      EzvizPtzActions.Start,
      EzvizPtzSpeeds.Normal,
    );
  }

  Future<void> _stopPTZ(String direction) async {
    String command;
    switch (direction) {
      case 'UP':
        command = EzvizPtzCommands.Up;
        break;
      case 'DOWN':
        command = EzvizPtzCommands.Down;
        break;
      case 'LEFT':
        command = EzvizPtzCommands.Left;
        break;
      case 'RIGHT':
        command = EzvizPtzCommands.Right;
        break;
      default:
        return;
    }

    await EzvizManager.shared().controlPTZ(
      deviceSerial,
      cameraId,
      command,
      EzvizPtzActions.Stop,
      EzvizPtzSpeeds.Normal,
    );
  }

  // ... other methods
}
```

### 4. Audio & Intercom Features

```dart
// Two-way audio communication
class IntercomPage extends StatefulWidget {
  @override
  _IntercomPageState createState() => _IntercomPageState();
}

class _IntercomPageState extends State<IntercomPage> {
  bool isTalking = false;
  final String deviceSerial = "YOUR_DEVICE_SERIAL";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Intercom')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Full-duplex intercom button
            GestureDetector(
              onTapDown: (_) => _startIntercom(supportTalk: 1), // Full-duplex
              onTapUp: (_) => _stopIntercom(),
              onTapCancel: () => _stopIntercom(),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: isTalking ? Colors.red : Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.mic,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(isTalking ? 'Talking...' : 'Hold to Talk'),
            SizedBox(height: 40),
            // Half-duplex intercom button
            ElevatedButton(
              onPressed: () => _startIntercom(supportTalk: 3), // Half-duplex
              child: Text('Start Half-Duplex Talk'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startIntercom({required int supportTalk}) async {
    final success = await EzvizAudio.startVoiceTalk(
      deviceSerial: deviceSerial,
      verifyCode: 'VERIFY_CODE',
      cameraNo: 1,
      isPhone2Dev: 1, // Phone speaks, device listens
      supportTalk: supportTalk,
    );
    
    if (success) {
      setState(() => isTalking = true);
    }
  }

  Future<void> _stopIntercom() async {
    await EzvizAudio.stopVoiceTalk();
    setState(() => isTalking = false);
  }
}
```

### 5. Wi-Fi Configuration

```dart
// Configure device Wi-Fi settings
class WiFiConfigPage extends StatefulWidget {
  @override
  _WiFiConfigPageState createState() => _WiFiConfigPageState();
}

class _WiFiConfigPageState extends State<WiFiConfigPage> {
  final _ssidController = TextEditingController();
  final _passwordController = TextEditingController();
  final String deviceSerial = "NEW_DEVICE_SERIAL";

  @override
  void initState() {
    super.initState();
    _setupConfigEventHandler();
  }

  void _setupConfigEventHandler() {
    EzvizWifiConfig.setConfigEventHandler((result) {
      if (result.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wi-Fi configuration successful!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Configuration failed: ${result.errorMessage}')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wi-Fi Configuration')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _ssidController,
              decoration: InputDecoration(labelText: 'Wi-Fi SSID'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Wi-Fi Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _startWiFiConfig,
                  child: Text('Wi-Fi Config'),
                ),
                ElevatedButton(
                  onPressed: _startSoundWaveConfig,
                  child: Text('Sound Wave'),
                ),
                ElevatedButton(
                  onPressed: _startAPConfig,
                  child: Text('AP Config'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _startWiFiConfig() async {
    await EzvizWifiConfig.startWifiConfig(
      deviceSerial: deviceSerial,
      ssid: _ssidController.text,
      password: _passwordController.text,
      mode: EzvizWifiConfigMode.wifi,
    );
  }

  Future<void> _startSoundWaveConfig() async {
    await EzvizWifiConfig.startWifiConfig(
      deviceSerial: deviceSerial,
      ssid: _ssidController.text,
      password: _passwordController.text,
      mode: EzvizWifiConfigMode.wave,
    );
  }

  Future<void> _startAPConfig() async {
    await EzvizWifiConfig.startAPConfig(
      deviceSerial: deviceSerial,
      ssid: _ssidController.text,
      password: _passwordController.text,
      verifyCode: 'VERIFY_CODE',
    );
  }

  @override
  void dispose() {
    EzvizWifiConfig.removeConfigEventHandler();
    super.dispose();
  }
}
```

### 6. Recording & Screenshots

```dart
// Recording and screenshot management
class RecordingManager {
  static Future<void> startRecording(EzvizPlayerController controller) async {
    final success = await controller.startRecording();
    if (success) {
      print('Recording started');
    }
  }

  static Future<void> stopRecording(EzvizPlayerController controller) async {
    final success = await controller.stopRecording();
    if (success) {
      print('Recording stopped');
    }
  }

  static Future<void> takeScreenshot(EzvizPlayerController controller) async {
    final imagePath = await controller.capturePicture();
    if (imagePath != null) {
      print('Screenshot saved: $imagePath');
      // Show image or save to gallery
    }
  }

  static Future<bool> getRecordingStatus(EzvizPlayerController controller) async {
    return await controller.isRecording();
  }
}
```

### 7. Enhanced Video Playback

```dart
// Enhanced playback with pause/resume
class PlaybackControlsExample extends StatefulWidget {
  @override
  _PlaybackControlsExampleState createState() => _PlaybackControlsExampleState();
}

class _PlaybackControlsExampleState extends State<PlaybackControlsExample> {
  EzvizPlayerController? controller;
  bool isPaused = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: _startPlayback,
          child: Text('Play'),
        ),
        ElevatedButton(
          onPressed: _pauseResume,
          child: Text(isPaused ? 'Resume' : 'Pause'),
        ),
        ElevatedButton(
          onPressed: _stopPlayback,
          child: Text('Stop'),
        ),
      ],
    );
  }

  Future<void> _startPlayback() async {
    final startTime = DateTime.now().subtract(Duration(hours: 1));
    final endTime = DateTime.now();
    await controller?.startReplay(startTime, endTime);
    setState(() => isPaused = false);
  }

  Future<void> _pauseResume() async {
    if (isPaused) {
      await controller?.resumePlayback();
    } else {
      await controller?.pausePlayback();
    }
    setState(() => isPaused = !isPaused);
  }

  Future<void> _stopPlayback() async {
    await controller?.stopReplay();
    setState(() => isPaused = false);
  }
}
```

## New API Components

### EzvizAudio
Audio and intercom functionality:
- `EzvizAudio.openSound()` - Enable audio
- `EzvizAudio.closeSound()` - Disable audio  
- `EzvizAudio.startVoiceTalk()` - Start intercom
- `EzvizAudio.stopVoiceTalk()` - Stop intercom

### EzvizRecording
Recording and screenshot features:
- `EzvizRecording.startRecording()` - Start video recording
- `EzvizRecording.stopRecording()` - Stop video recording
- `EzvizRecording.capturePicture()` - Take screenshot
- `EzvizRecording.isRecording()` - Check recording status

### EzvizWifiConfig
Wi-Fi configuration management:
- `EzvizWifiConfig.startWifiConfig()` - Wi-Fi configuration
- `EzvizWifiConfig.startAPConfig()` - AP mode configuration
- `EzvizWifiConfig.stopConfig()` - Stop configuration

### UI Components

#### PTZControlPanel
Circular touch control panel for intuitive PTZ control:
```dart
PTZControlPanel(
  size: 250,
  onDirectionStart: (direction) => print('Start $direction'),
  onDirectionStop: (direction) => print('Stop $direction'),
  onCenterTap: () => print('Center tapped'),
)
```

#### EnhancedPlayerControls
Professional video player controls:
```dart
EnhancedPlayerControls(
  isPlaying: true,
  isRecording: false,
  soundEnabled: true,
  onPlayPause: () => print('Play/Pause'),
  onRecord: () => print('Record'),
  onScreenshot: () => print('Screenshot'),
)
```

## Feature Comparison

| Feature | HTTP API | Native SDK |
|---------|----------|------------|
| Device Management | ✅ | ✅ |
| Live Streaming | 🔗 URLs only | ✅ Native player |
| PTZ Control | ✅ | ✅ Enhanced |
| Video Playback | 🔗 URLs only | ✅ Native player |
| Audio/Intercom | ❌ | ✅ |
| Recording | ❌ | ✅ |
| Screenshots | ❌ | ✅ |
| Wi-Fi Config | ❌ | ✅ |
| Real-time Events | ❌ | ✅ |

## Migration from v1.0.2

The new features are fully backward compatible. To use enhanced features:

1. Update your `pubspec.yaml` to version `^1.0.4`
2. Import new components: `import 'package:ezviz_flutter/ezviz_flutter.dart';`
3. Use new widgets and APIs as needed

## Troubleshooting

### Audio Issues
- Ensure microphone permissions are granted
- Check device supports audio features
- Verify intercom parameters (half vs full-duplex)

### Recording Issues  
- Check storage permissions
- Ensure sufficient device storage
- Verify recording format support

### Wi-Fi Configuration Issues
- Ensure location permissions for Wi-Fi scanning
- Check device is in configuration mode
- Verify network credentials

## Credits and Acknowledgments

This library integrates and builds upon code from several sources:

### Native SDK Integration
- **flutter_ezviz**: Native Android and iOS SDK implementation for EZVIZ cameras
  - Original native SDK wrapper and player components
  - Device management and PTZ control functionality
  - Core platform channel communication

### Enhanced Features
- **ezviz_flutter_cam** by [thanhdang198](https://github.com/thanhdang198/ezviz_flutter_cam)
  - Audio and intercom functionality
  - Recording and screenshot capabilities  
  - Wi-Fi configuration features
  - Enhanced UI components and controls
  - Advanced playback controls (pause/resume)

We extend our gratitude to the original authors and contributors of these repositories for their excellent work in EZVIZ SDK integration. This library combines the best features from both implementations to provide a comprehensive Flutter plugin for EZVIZ camera integration.

### Original Repositories
- 🔗 [ezviz_flutter_cam](https://github.com/thanhdang198/ezviz_flutter_cam) - Enhanced camera features and UI components
- 📁 flutter_ezviz - Core native SDK implementation (local source)

## API Reference

### Core Classes
- `EzvizManager` - Main SDK manager (singleton)
- `EzvizPlayer` - Video player widget  
- `EzvizPlayerController` - Player control interface
- `EzvizAudio` - Audio and intercom management
- `EzvizRecording` - Recording and screenshot features
- `EzvizWifiConfig` - Wi-Fi configuration management

### UI Widgets
- `PTZControlPanel` - Circular PTZ control interface
- `EnhancedPlayerControls` - Advanced video player controls

### Models
- `EzvizWifiConfigResult` - Wi-Fi configuration result
- `EzvizWifiConfigMode` - Configuration mode enumeration

## Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📧 Email: support@example.com
- 🐛 Issues: [GitHub Issues](https://github.com/akshaynexus/ezviz_flutter/issues)
- 📖 Documentation: [API Docs](https://pub.dev/documentation/ezviz_flutter/latest/)

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed list of changes.

# EZVIZ Flutter Example App

This is a comprehensive example application demonstrating the EZVIZ Flutter package capabilities, including both Native SDK and HTTP API integration.

## 🚨 IMPORTANT: Credentials Required

**The error you're encountering (\"AppKey doesn't exist\", \"AccessToken expired\") is due to invalid or missing EZVIZ developer credentials.**

### Getting Valid EZVIZ Credentials

1. **Register as EZVIZ Developer**:
   - Go to [https://open.ezvizlife.com/](https://open.ezvizlife.com/)
   - Create a developer account
   - Complete the registration process

2. **Create Application**:
   - Log into the developer console
   - Create a new application
   - Get your **App Key** and **App Secret**

3. **Update Credentials**:
   - Replace `YOUR_APP_KEY_HERE` with your actual App Key
   - Replace `YOUR_APP_SECRET_HERE` with your actual App Secret
   - The app will automatically get access tokens and area domains

## ✅ **MAJOR FIX: Area Domain Support**

This version includes a **critical fix** for the Native SDK authentication issue:

### **The Problem**
- **HTTP API**: ✅ Correctly used area domains from token response
- **Native SDK**: ❌ **Missing area domain support entirely**

### **The Solution**  
The Native SDK initialization now properly:

1. **Gets Access Token**: Makes API call to `https://open.ezvizlife.com/api/lapp/token/get`
2. **Extracts Area Domain**: Retrieves the regional API endpoint (e.g., `https://iusopen.ezvizlife.com`)
3. **Uses Proper Credentials**: Initializes Native SDK with the real access token (not app secret!)
4. **Shows Status**: Displays the area domain being used in the UI

### **Why This Matters**
- **Regional API Endpoints**: Different regions use different EZVIZ servers
- **Authentication Tokens**: Access tokens are only valid in their specific region
- **Error Prevention**: Eliminates \"AppKey doesn't exist\" and \"AccessToken expired\" errors

### **Before vs After**
**Before (Broken)**:
```dart
// Used app secret instead of access token
accessToken: appSecret
// No area domain support
```

**After (Fixed)**:
```dart
// Gets real access token from API
accessToken: "at.7jrcjmna8qnqg8d3dgnzs87m4v2dme3l-32enpqgusd-1jvdfe4-uxo15ik0s"
// Uses correct regional endpoint
areaDomain: "https://iusopen.ezvizlife.com"
```

## 📱 Features

### Dual API Integration
- **HTTP API**: Camera listing, multiple streaming protocols, PTZ control
- **Native SDK**: Hardware acceleration, audio control, recording, screenshots

### 7-Tab Interface
1. **SDK Init**: Initialize both APIs with proper area domain support
2. **Devices**: Load device lists from both APIs with device selection
3. **Native Player**: Hardware-accelerated native video player with live streaming
4. **HTTP Streams**: Generate streaming URLs for multiple protocols (EZOPEN, HLS, RTMP, FLV)
5. **PTZ Control**: Interactive pan-tilt-zoom controls for both APIs
6. **Audio/Record**: Audio controls, recording, and screenshot capabilities
7. **WiFi Config**: Placeholder for future network configuration features

### Streaming Protocols Supported
- **EZOPEN**: Native app integration protocol
- **HLS**: Web and mobile streaming
- **RTMP**: Live streaming protocol
- **FLV**: Flash video format

## 🛠 Installation & Setup

### Prerequisites
- Flutter 3.32.0 or later
- Valid EZVIZ developer account
- Android 5.0+ / iOS 11.0+

### Setup Instructions

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd ezviz_example_app
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Update credentials** in `lib/ui/pages/native_sdk_demo_page.dart`:
   ```dart
   _appKeyController.text = 'your_actual_app_key_here';
   _appSecretController.text = 'your_actual_app_secret_here';
   ```

4. **Run the app**:
   ```bash
   flutter run
   ```

### Android Configuration

Ensure your `android/app/src/main/AndroidManifest.xml` includes:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
<uses-permission android:name="android.permission.CHANGE_WIFI_STATE" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.MANAGE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_PHONE_STATE" />
<uses-permission android:name="android.permission.WAKE_LOCK" />

<application
    android:usesCleartextTraffic="true"
    android:requestLegacyExternalStorage="true">
```

## 📖 Usage Guide

### Step 1: Initialize APIs
1. Open the **Init** tab
2. Enter your valid EZVIZ App Key and App Secret
3. Click **Init HTTP API** first to get access token and area domain
4. Click **Init Native SDK** to initialize with proper credentials
5. ✅ Look for success message showing area domain (e.g., `https://iusopen.ezvizlife.com`)

### Step 2: Load Devices
1. Switch to **Devices** tab
2. Select HTTP API or Native SDK
3. Click **Load HTTP Cameras** or **Load Native Devices**
4. Select a device from the list

### Step 3: Stream Video
- **Native Player**: Go to **Native** tab, initialize player, start live stream
- **HTTP URLs**: Go to **HTTP** tab, generate URLs for different protocols

### Step 4: Control Camera
- **PTZ Control**: Use **PTZ** tab for pan/tilt/zoom operations
- **Audio**: Use **Audio** tab for sound and recording controls

## 🔧 Error Handling

### Common Error Codes
- **10017**: Invalid App Key - check your credentials
- **10030**: App Key/Secret mismatch - verify both values
- **10002**: Access token expired - reinitialize the APIs
- **10005**: App Key suspended - contact EZVIZ support

### Authentication Flow
1. **Credential Validation**: Checks for placeholder values
2. **Token Request**: Gets access token from EZVIZ API
3. **Area Domain**: Extracts regional endpoint
4. **SDK Initialization**: Uses proper credentials for both APIs
5. **Error Feedback**: Shows specific error messages in UI

## 🌍 Regional Support

The app now properly handles EZVIZ's regional architecture:

- **Global Endpoint**: `https://open.ezvizlife.com` (for getting tokens)
- **Regional Endpoints**: Automatically detected (e.g., `https://iusopen.ezvizlife.com`)
- **Token Validity**: Tokens are only valid in their assigned region
- **Automatic Routing**: API calls use the correct regional endpoint

## 🚨 Troubleshooting

### \"AppKey doesn't exist\" Error
- ✅ **FIXED**: Now gets proper access token and uses area domain
- Check that you're using real credentials (not placeholders)
- Verify App Key exists in EZVIZ developer console

### \"AccessToken expired\" Error  
- ✅ **FIXED**: Now uses proper access token instead of app secret
- The app automatically refreshes tokens when needed
- Check your internet connection

### No devices found
- Make sure devices are added to your EZVIZ account
- Check device online status in EZVIZ app
- Verify account permissions for device access

### Native SDK timeout
- ✅ **FIXED**: Now uses proper authentication flow
- Check internet connection stability
- Try HTTP API first to test credentials

## 💡 Code Examples

### Getting Access Token with Area Domain
```dart
final response = await http.post(
  Uri.parse('https://open.ezvizlife.com/api/lapp/token/get'),
  headers: {'Content-Type': 'application/x-www-form-urlencoded'},
  body: {'appKey': appKey, 'appSecret': appSecret},
);

final data = jsonDecode(response.body);
String accessToken = data['data']['accessToken'];
String areaDomain = data['data']['areaDomain']; // Critical!
```

### Native SDK Initialization
```dart
final options = EzvizInitOptions(
  appKey: appKey,
  accessToken: accessToken, // Use real token, not app secret!
  enableLog: true,
  enableP2P: false,
);

await EzvizManager.shared().initSDK(options);
await EzvizManager.shared().setAccessToken(accessToken);
```

### HTTP API with Area Domain
```dart
final client = EzvizClient(appKey: appKey, appSecret: appSecret);
// Client automatically uses area domain for all requests
final cameras = await DeviceService(client).getCameraList();
```

## 📝 License

This project is for demonstration purposes. Make sure to comply with EZVIZ's Terms of Service when using their APIs.

---

**✅ This version resolves the critical authentication issues by implementing proper area domain support for both Native SDK and HTTP API integration.**
