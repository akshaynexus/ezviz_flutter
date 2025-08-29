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

Run this command in the root of your flutter project

```bash
flutter pub add ezviz_flutter
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

## 📚 Examples & Documentation

All example code has been organized into comprehensive documentation. See the **[docs](docs/)** folder for detailed examples:

### 🎯 Quick Links to Examples

| Feature | Example | Description |
|---------|---------|-------------|
| **Simple Integration** | [Simple Player Examples](docs/examples/simple_player_example.md) | EzvizSimplePlayer - 3 lines to get started |
| **Complete SDK** | [Comprehensive SDK Integration](docs/examples/comprehensive_sdk_example.md) | Full device management with authentication |
| **Multi-Region** | [Global SDK Support](docs/examples/global_sdk_example.md) | Multi-region deployment and area selection |
| **Advanced Playback** | [Advanced Playback Controls](docs/examples/advanced_playback_example.md) | Enhanced video playback with all features |
| **Camera Control** | [PTZ Control Examples](docs/examples/ptz_control_example.md) | Pan-Tilt-Zoom camera control |
| **Audio/Intercom** | [Audio & Intercom Examples](docs/examples/audio_intercom_example.md) | Two-way audio communication |
| **WiFi Setup** | [WiFi Configuration](docs/examples/wifi_config_example.md) | Device network configuration |
| **Recording** | [Recording & Screenshots](docs/examples/recording_screenshots_example.md) | Video recording and image capture |
| **Professional UI** | [Enhanced Video Playback](docs/examples/enhanced_video_playback_example.md) | Professional video player interface |
| **Live Streaming** | [Live Streaming Examples](docs/examples/live_streaming_example.md) | Real-time streaming with controls |

### 📖 Complete Documentation
- **[Documentation Index](docs/README.md)** - Complete overview of all examples and guides
- **Implementation Levels** - From 3-line simple integration to professional implementations
- **Best Practices** - Error handling, performance optimization, and resource management
- **Troubleshooting** - Common issues and solutions for each feature

## Quick Start

### 🚀 Three Integration Levels

#### Level 1: Simple Integration (3 lines of code)
Perfect for getting started quickly:

```dart
EzvizSimplePlayer(
  deviceSerial: 'YOUR_DEVICE_SERIAL',
  channelNo: 1,
  config: EzvizPlayerConfig(
    appKey: 'YOUR_APP_KEY',
    appSecret: 'YOUR_APP_SECRET',
    accessToken: 'YOUR_ACCESS_TOKEN',
  ),
)
```

**🎯 [View Complete Simple Player Examples →](docs/examples/simple_player_example.md)**

#### Level 2: Standard Integration
Full-featured implementation with state management:

```dart
EzvizSimplePlayer(
  deviceSerial: 'YOUR_DEVICE_SERIAL',
  channelNo: 1,
  config: EzvizPlayerConfig(/* full config */),
  onStateChanged: (state) => handleStateChange(state),
  onError: (error) => handleError(error),
  onPasswordRequired: () => showPasswordDialog(),
)
```

**🎯 [View Comprehensive SDK Integration →](docs/examples/comprehensive_sdk_example.md)**

#### Level 3: Advanced Integration
Professional implementations with custom UI and advanced features:

**🎯 [View All Advanced Examples →](docs/examples/)**

### 🎯 Choose Your Starting Point

- **New to EZVIZ?** Start with [Simple Player Examples](docs/examples/simple_player_example.md)
- **Need full device management?** See [Comprehensive SDK Integration](docs/examples/comprehensive_sdk_example.md)  
- **Building professional app?** Browse [Advanced Examples](docs/examples/) for your specific needs

### ✨ Key Features Available

- **EzvizSimplePlayer**: Auto-handles SDK initialization, authentication, and streaming
- **Native SDK Integration**: Complete device lifecycle management
- **Multi-Region Support**: Global deployment with area selection
- **Advanced Controls**: PTZ, audio, recording, WiFi configuration
- **Professional UI**: Enhanced player controls and fullscreen support

## Configuration

### Region/Base URL Configuration

The EZVIZ API endpoints vary by region. Configure the region using the convenient enum-based approach:

#### Method 1: Global Configuration (Affects all instances)
```dart
import 'package:ezviz_flutter/ezviz_flutter.dart';

void main() {
  // Set region globally at app startup
  EzvizConstants.setRegion(EzvizRegion.europe);
  
  // Or use a custom URL for private deployments
  EzvizConstants.setBaseUrl('https://custom.ezvizlife.com');
  
  runApp(MyApp());
}
```

#### Method 2: Per-Instance Configuration

##### For EzvizClient (HTTP API):
```dart
// Using region enum (recommended)
final client = EzvizClient(
  appKey: 'YOUR_APP_KEY',
  appSecret: 'YOUR_APP_SECRET',
  region: EzvizRegion.usa,
);

// Or using custom URL
final client = EzvizClient(
  appKey: 'YOUR_APP_KEY',
  appSecret: 'YOUR_APP_SECRET',
  baseUrl: 'https://custom.ezvizlife.com',
);
```

##### For EzvizSimplePlayer:
```dart
EzvizSimplePlayer(
  deviceSerial: 'YOUR_DEVICE_SERIAL',
  channelNo: 1,
  config: EzvizPlayerConfig(
    appKey: 'YOUR_APP_KEY',
    appSecret: 'YOUR_APP_SECRET',
    region: EzvizRegion.europe,  // Simply specify the region
    // or use baseUrl for custom endpoints
  ),
)
```

#### Available Regions
| Region | Enum Value | Base URL |
|--------|------------|----------|
| India (Default) | `EzvizRegion.india` | `https://iindiaopen.ezvizlife.com` |
| China | `EzvizRegion.china` | `https://iopen.ezvizlife.com` |
| Europe | `EzvizRegion.europe` | `https://ieuopen.ezvizlife.com` |
| Russia | `EzvizRegion.russia` | `https://iruopen.ezvizlife.com` |
| USA | `EzvizRegion.usa` | `https://iusopen.ezvizlife.com` |
| Custom | `EzvizRegion.custom` | Use with `baseUrl` parameter |

> **Note**: If no region is configured, the library defaults to the Global region endpoint.

## Complete API Components

### Core Native SDK Integration

#### EzvizAuthManager
Comprehensive authentication and global SDK management:
- `EzvizAuthManager.getAccessToken()` - Get current access token
- `EzvizAuthManager.openLoginPage()` - Open native login page
- `EzvizAuthManager.logout()` - Logout and clear tokens
- `EzvizAuthManager.getAreaList()` - Get available global regions/areas
- `EzvizAuthManager.initGlobalSDK()` - Initialize global SDK with area

#### EzvizDeviceManager
Complete device lifecycle management:
- `EzvizDeviceManager.getDeviceList()` - Get paginated device list
- `EzvizDeviceManager.addDevice()` - Add device by serial number
- `EzvizDeviceManager.deleteDevice()` - Remove device from account
- `EzvizDeviceManager.probeDeviceInfo()` - Check if device exists and status
- `EzvizDeviceManager.searchCloudRecordFiles()` - Search cloud recordings
- `EzvizDeviceManager.searchDeviceRecordFiles()` - Search device recordings
- `EzvizDeviceManager.getDeviceInfo()` - Get detailed device information

#### EzvizPlaybackController
Enhanced playback control with extensions:
- `controller.pausePlayback()` - Pause recorded video playback
- `controller.resumePlayback()` - Resume paused playback
- `controller.seekPlayback()` - Seek to specific time
- `controller.getOSDTime()` - Get current playback time
- `controller.setPlaySpeed()` - Set playback speed (0.25x to 4x)
- `controller.startLocalRecord()` - Start local recording
- `controller.stopLocalRecord()` - Stop local recording
- `controller.captureImage()` - Capture current frame
- `controller.scalePlayWindow()` - Scale playback window

#### EzvizPlaybackUtils
Playback utilities and helpers:
- `EzvizPlaybackUtils.formatPlaybackTime()` - Format time display
- `EzvizPlaybackUtils.calculateProgress()` - Calculate progress percentage
- `EzvizPlaybackUtils.progressToTime()` - Convert progress to time
- `EzvizPlaybackUtils.getPlaybackSpeeds()` - Get available speed options

### Enhanced Audio & Intercom

#### EzvizAudio
Audio and intercom functionality:
- `EzvizAudio.openSound()` - Enable audio
- `EzvizAudio.closeSound()` - Disable audio  
- `EzvizAudio.startVoiceTalk()` - Start intercom (half/full-duplex)
- `EzvizAudio.stopVoiceTalk()` - Stop intercom

### Recording & Media Capture

#### EzvizRecording
Recording and screenshot features:
- `EzvizRecording.startRecording()` - Start video recording
- `EzvizRecording.stopRecording()` - Stop video recording
- `EzvizRecording.capturePicture()` - Take screenshot
- `EzvizRecording.isRecording()` - Check recording status

### Network Configuration

#### EzvizWifiConfig
Wi-Fi configuration management:
- `EzvizWifiConfig.startWifiConfig()` - Wi-Fi configuration
- `EzvizWifiConfig.startAPConfig()` - AP mode configuration
- `EzvizWifiConfig.stopConfig()` - Stop configuration
- `EzvizWifiConfig.setConfigEventHandler()` - Handle configuration events

### Data Models

#### Device Information
- `EzvizDeviceInfo` - Complete device information
- `EzvizProbeDeviceInfo` - Device probe result
- `EzvizCameraInfo` - Camera channel information

#### Authentication & Areas
- `EzvizAccessToken` - Access token with expiration
- `EzvizAreaInfo` - Global region/area information

#### Recording & Playback
- `EzvizCloudRecordFile` - Cloud recording file information
- `EzvizDeviceRecordFile` - Device recording file information
- `PlaybackSpeed` - Playback speed option
- `RecordingType` - Recording type enumeration (All, Timing, Alarm, Manual)

### UI Components

#### EzvizSimplePlayer
The easiest way to integrate EZVIZ cameras with automatic handling of all functionality:
```dart
EzvizSimplePlayer(
  deviceSerial: 'DEVICE_SERIAL',
  channelNo: 1,
  config: EzvizPlayerConfig(
    appKey: 'APP_KEY',
    appSecret: 'APP_SECRET',
    accessToken: 'ACCESS_TOKEN',
    autoPlay: true,
    enableAudio: true,
    enableEncryptionDialog: true,
  ),
  onStateChanged: (state) => print('State: $state'),
  onError: (error) => print('Error: $error'),
)
```

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

### Common SDK Issues

#### Authentication Problems
- **Token Expired**: Use `EzvizAuthManager.getAccessToken()` to check token validity
- **Login Failed**: Ensure correct area/region selection with `EzvizAuthManager.getAreaList()`
- **Global SDK Issues**: Initialize proper area with `EzvizAuthManager.initGlobalSDK()`

#### Device Management Issues
- **Device Not Found**: Use `EzvizDeviceManager.probeDeviceInfo()` first to verify device exists
- **Add Device Failed**: Check device status codes (20020, 20022, 20023) and provide verification code if needed
- **Empty Device List**: Ensure user is logged in and has devices associated with account

#### Playback Issues
- **Pause/Resume Not Working**: Only works for recorded video, not live streams
- **Seek Failed**: Ensure you're using recorded video playback, not live streaming
- **No Audio**: Check device audio capabilities and enable with `controller.openSound()`
- **Playback Speed**: Use `controller.setPlaySpeed()` only during recorded video playback

#### Recording Search Issues
- **No Records Found**: Check time range and recording types (timing, alarm, manual)
- **Cloud vs Device Records**: Use appropriate search method for storage type
- **Time Range**: Ensure start/end times are in milliseconds since epoch

### Audio Issues
- Ensure microphone permissions are granted
- Check device supports audio features
- Verify intercom parameters (half vs full-duplex)
- For full-duplex: use `supportTalk: 1`
- For half-duplex: use `supportTalk: 3`

### Recording Issues  
- Check storage permissions
- Ensure sufficient device storage
- Verify recording format support
- Use `controller.isLocalRecording()` to check recording status

### Wi-Fi Configuration Issues
- Ensure location permissions for Wi-Fi scanning
- Check device is in configuration mode
- Verify network credentials
- Use appropriate config mode (wifi, wave, AP)

### Video Player Issues
- **Black Screen**: Check device serial, verify code, and network connectivity
- **Fullscreen Problems**: Ensure proper controller lifecycle management
- **Auto-play Failed**: Verify access token and device status
- **Encryption Dialog**: Enable with `enableEncryptionDialog: true` in config

### Performance Issues
- **Slow Loading**: Use `EzvizSimplePlayer` for optimized performance
- **Memory Usage**: Dispose controllers properly in `dispose()` method
- **Multiple Players**: Limit concurrent video streams for better performance

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
- `EzvizAuthManager` - Authentication and global SDK management ⭐
- `EzvizDeviceManager` - Complete device lifecycle management ⭐
- `EzvizPlayer` - Low-level video player widget  
- `EzvizSimplePlayer` - High-level easy-to-use player widget ⭐
- `EzvizPlayerController` - Enhanced player control interface with extensions ⭐
- `EzvizPlaybackUtils` - Playback utilities and helpers ⭐
- `EzvizAudio` - Audio and intercom management
- `EzvizRecording` - Recording and screenshot features
- `EzvizWifiConfig` - Wi-Fi configuration management

### UI Widgets
- `EzvizSimplePlayer` - Complete player solution with auto-handling ⭐
- `PTZControlPanel` - Circular PTZ control interface
- `EnhancedPlayerControls` - Advanced video player controls

### Models & Data Types

#### Core Models
- `EzvizDeviceInfo` - Complete device information with status, capabilities, and camera details
- `EzvizAccessToken` - Authentication token with expiration tracking
- `EzvizAreaInfo` - Global region/area information for multi-region support
- `EzvizProbeDeviceInfo` - Device probe result with availability status
- `EzvizCameraInfo` - Individual camera channel information

#### Recording & Playback
- `EzvizCloudRecordFile` - Cloud recording file with metadata
- `EzvizDeviceRecordFile` - Device storage recording file
- `PlaybackSpeed` - Playback speed option (0.25x to 4x)
- `RecordingType` - Enumeration: All, Timing, Alarm, Manual

#### Configuration
- `EzvizWifiConfigResult` - Wi-Fi configuration result with status
- `EzvizWifiConfigMode` - Configuration mode: wifi, wave, AP

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
