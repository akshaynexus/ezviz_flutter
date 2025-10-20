# EZVIZ Flutter SDK

A Flutter plugin for EZVIZ camera integration with live streaming, device management, PTZ control, and more.

[![pub package](https://img.shields.io/pub/v/ezviz_flutter.svg)](https://pub.dev/packages/ezviz_flutter)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Tests](https://github.com/akshaynexus/ezviz_flutter/workflows/Tests/badge.svg)](https://github.com/akshaynexus/ezviz_flutter/actions)
[![codecov](https://codecov.io/gh/akshaynexus/ezviz_flutter/branch/main/graph/badge.svg)](https://codecov.io/gh/akshaynexus/ezviz_flutter)

## ⚡ Quick Start

### 1. Install
```bash
flutter pub add ezviz_flutter
```

### 2. Configure Region (Important!)
```dart
import 'package:ezviz_flutter/ezviz_flutter.dart';

void main() {
  // Set your region BEFORE any API calls
  EzvizConstants.setRegion(EzvizRegion.europe);  // Match your account region
  runApp(MyApp());
}
```

### 3. Simple Player
```dart
EzvizSimplePlayer(
  deviceSerial: 'YOUR_DEVICE_SERIAL',
  channelNo: 1,
  config: EzvizPlayerConfig(
    appKey: 'YOUR_APP_KEY',
    accessToken: 'YOUR_ACCESS_TOKEN',
    region: EzvizRegion.northAmerica,  // Optional: per-instance region
  ),
)
```

## 🌍 Region Configuration

⚠️ **Most authentication issues are caused by incorrect region settings!**

Your EZVIZ account is tied to a specific region. Set the correct one:

```dart
// Choose your region
EzvizConstants.setRegion(EzvizRegion.europe);      // Europe
EzvizConstants.setRegion(EzvizRegion.northAmerica);         // USA/Canada
EzvizConstants.setRegion(EzvizRegion.india);       // India/South Asia
EzvizConstants.setRegion(EzvizRegion.singapore);   // Singapore/SEA
EzvizConstants.setRegion(EzvizRegion.china);       // China
```

## 📱 Platform Setup

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

2. Add permissions to `android/app/src/main/AndroidManifest.xml`:

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

## ✨ Key Features

- **Live Video Streaming** - Real-time camera viewing
- **PTZ Control** - Pan, tilt, zoom camera control  
- **Device Management** - Add, remove, manage devices
- **Audio/Intercom** - Two-way audio communication
- **Recording** - Video recording and screenshots
- **Wi-Fi Config** - Device network setup
- **Multi-Region** - Global deployment support

## 📚 Examples & Documentation

- **[Complete Examples](example/)** - Working code examples
- **[API Documentation](https://pub.dev/documentation/ezviz_flutter/latest/)** - Auto-generated API docs
- **[FAQ & Troubleshooting](FAQ.md)** - Common issues and solutions

## 🆘 Need Help?

**Can't authenticate?** → Check your [region configuration](#-region-configuration)

**Other issues?** → See our **[FAQ & Troubleshooting Guide](FAQ.md)**

**More examples?** → Check the **[example folder](example/)**

## 🔗 Links

- [Package on pub.dev](https://pub.dev/packages/ezviz_flutter)
- [Example App Repository](https://github.com/akshaynexus/ezviz_flutter_example_app)
- [Issues & Support](https://github.com/akshaynexus/ezviz_flutter/issues)

## 🙏 Credits and Acknowledgments

This library integrates and builds upon code from several sources:

### Native SDK Integration
[**flutter_ezviz**](https://github.com/pam3ec555/flutter_ezviz) by pam3ec555: Native Android and iOS SDK implementation for EZVIZ cameras
- Original native SDK wrapper and player components
- Device management and PTZ control functionality
- Core platform channel communication

### Enhanced Features
[**ezviz_flutter_cam**](https://github.com/thanhdang198/ezviz_flutter_cam) by thanhdang198
- Audio and intercom functionality
- Recording and screenshot capabilities
- Wi-Fi configuration features
- Enhanced UI components and controls
- Advanced playback controls (pause/resume)

We extend our gratitude to the original authors and contributors of these repositories for their excellent work in EZVIZ SDK integration. This library combines the best features from both implementations to provide a comprehensive Flutter plugin for EZVIZ camera integration.

### Original Repositories
- 🔗 [ezviz_flutter_cam](https://github.com/thanhdang198/ezviz_flutter_cam) - Enhanced camera features and UI components
- 📁 [flutter_ezviz](https://github.com/pam3ec555/flutter_ezviz) - Core native SDK implementation

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.