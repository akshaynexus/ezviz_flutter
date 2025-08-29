# EZVIZ Flutter SDK Examples

Complete examples demonstrating all features of the EZVIZ Flutter SDK.

## 🚀 Quick Start

### Basic Setup

1. **Configure your region** (optional - defaults to global):
```dart
import 'package:ezviz_flutter/ezviz_flutter.dart';

void main() {
  // Set region globally
  EzvizConstants.setRegion(EzvizRegion.europe);
  runApp(MyApp());
}
```

2. **Create a simple player**:
```dart
EzvizSimplePlayer(
  deviceSerial: 'YOUR_DEVICE_SERIAL',
  channelNo: 1,
  config: EzvizPlayerConfig(
    appKey: 'YOUR_APP_KEY',
    appSecret: 'YOUR_APP_SECRET',
    region: EzvizRegion.usa,  // Or configure per-instance
  ),
)
```

## 📋 Available Examples

### Core Examples
- **[main.dart](lib/main.dart)** - Main demo application with multiple features
- **[simple_player_example.dart](lib/simple_player_example.dart)** - Basic player implementation
- **[comprehensive_sdk_example.dart](lib/comprehensive_sdk_example.dart)** - Full SDK integration
- **[audio_test_example.dart](lib/audio_test_example.dart)** - Audio and intercom functionality
- **[fullscreen_player_example.dart](lib/fullscreen_player_example.dart)** - Fullscreen video player

### Service Examples
- **[auth_service_example.dart](auth_service_example.dart)** - Authentication service
- **[device_service_example.dart](device_service_example.dart)** - Device management
- **[live_service_example.dart](live_service_example.dart)** - Live streaming
- **[ptz_service_example.dart](ptz_service_example.dart)** - PTZ camera control
- **[alarm_service_example.dart](alarm_service_example.dart)** - Alarm management
- **[cloud_storage_service_example.dart](cloud_storage_service_example.dart)** - Cloud storage
- **[detector_service_example.dart](detector_service_example.dart)** - Motion detection
- **[ram_account_service_example.dart](ram_account_service_example.dart)** - Sub-account management

## 🌍 Region Configuration

### Available Regions
- `EzvizRegion.india` - India region
- `EzvizRegion.china` - China region  
- `EzvizRegion.europe` - Europe region
- `EzvizRegion.russia` - Russia region
- `EzvizRegion.usa` - USA region

### Configuration Methods

#### Global Configuration
```dart
// Set once at app startup
EzvizConstants.setRegion(EzvizRegion.europe);

// Or use custom URL
EzvizConstants.setBaseUrl('https://custom.ezvizlife.com');
```

#### Per-Instance Configuration
```dart
// For EzvizClient
final client = EzvizClient(
  appKey: 'YOUR_APP_KEY',
  appSecret: 'YOUR_APP_SECRET',
  region: EzvizRegion.usa,
);

// For EzvizSimplePlayer
EzvizSimplePlayer(
  config: EzvizPlayerConfig(
    region: EzvizRegion.europe,
    // other config...
  ),
)
```

## 🏃 Running the Examples

1. Clone the repository
2. Navigate to the example folder:
   ```bash
   cd example
   ```
3. Update credentials in the example files or `api_config.dart`
4. Run the example:
   ```bash
   flutter run
   ```

## 🔑 Getting Started

### Prerequisites
- Flutter SDK installed
- EZVIZ App Key and App Secret from [EZVIZ Open Platform](https://open.ezvizlife.com)
- A registered EZVIZ device

### Platform Setup

#### Android
Add permissions to `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
```

#### iOS
Add to `Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to view EZVIZ cameras</string>
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access for audio streaming</string>
```

## 📖 Documentation

For complete documentation, see:
- [Package README](../README.md) - Complete feature list and API reference
- [API Documentation](https://pub.dev/documentation/ezviz_flutter/latest/) - Auto-generated API docs

## ⚠️ Security Notes

- Never commit real API credentials
- Use environment variables or secure storage for production
- Rotate access tokens regularly

## 📄 License

These examples are part of the EZVIZ Flutter SDK and are licensed under the same terms.