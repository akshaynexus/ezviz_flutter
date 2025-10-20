# EZVIZ Flutter SDK - Complete API Reference

## Core Native SDK Integration

### EzvizAuthManager
Comprehensive authentication and global SDK management:
- `EzvizAuthManager.getAccessToken()` - Get current access token
- `EzvizAuthManager.openLoginPage()` - Open native login page
- `EzvizAuthManager.logout()` - Logout and clear tokens
- `EzvizAuthManager.getAreaList()` - Get available global regions/areas
- `EzvizAuthManager.initGlobalSDK()` - Initialize global SDK with area

### EzvizDeviceManager
Complete device lifecycle management:
- `EzvizDeviceManager.getDeviceList()` - Get paginated device list
- `EzvizDeviceManager.addDevice()` - Add device by serial number
- `EzvizDeviceManager.deleteDevice()` - Remove device from account
- `EzvizDeviceManager.probeDeviceInfo()` - Check if device exists and status
- `EzvizDeviceManager.searchCloudRecordFiles()` - Search cloud recordings
- `EzvizDeviceManager.searchDeviceRecordFiles()` - Search device recordings
- `EzvizDeviceManager.getDeviceInfo()` - Get detailed device information

### EzvizPlaybackController
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

### EzvizPlaybackUtils
Playback utilities and helpers:
- `EzvizPlaybackUtils.formatPlaybackTime()` - Format time display
- `EzvizPlaybackUtils.calculateProgress()` - Calculate progress percentage
- `EzvizPlaybackUtils.progressToTime()` - Convert progress to time
- `EzvizPlaybackUtils.getPlaybackSpeeds()` - Get available speed options

## Enhanced Audio & Intercom

### EzvizAudio
Audio and intercom functionality:
- `EzvizAudio.openSound()` - Enable audio
- `EzvizAudio.closeSound()` - Disable audio  
- `EzvizAudio.startVoiceTalk()` - Start intercom (half/full-duplex)
- `EzvizAudio.stopVoiceTalk()` - Stop intercom

## Recording & Media Capture

### EzvizRecording
Recording and screenshot features:
- `EzvizRecording.startRecording()` - Start video recording
- `EzvizRecording.stopRecording()` - Stop video recording
- `EzvizRecording.capturePicture()` - Take screenshot
- `EzvizRecording.isRecording()` - Check recording status

## Network Configuration

### EzvizWifiConfig
Wi-Fi configuration management:
- `EzvizWifiConfig.startWifiConfig()` - Wi-Fi configuration
- `EzvizWifiConfig.startAPConfig()` - AP mode configuration
- `EzvizWifiConfig.stopConfig()` - Stop configuration
- `EzvizWifiConfig.setConfigEventHandler()` - Handle configuration events

## Data Models

### Device Information
- `EzvizDeviceInfo` - Complete device information
- `EzvizProbeDeviceInfo` - Device probe result
- `EzvizCameraInfo` - Camera channel information

### Authentication & Areas
- `EzvizAccessToken` - Access token with expiration
- `EzvizAreaInfo` - Global region/area information

### Recording & Playback
- `EzvizCloudRecordFile` - Cloud recording file information
- `EzvizDeviceRecordFile` - Device recording file information
- `PlaybackSpeed` - Playback speed option
- `RecordingType` - Recording type enumeration (All, Timing, Alarm, Manual)

## UI Components

### EzvizSimplePlayer
The easiest way to integrate EZVIZ cameras with automatic handling of all functionality:
```dart
EzvizSimplePlayer(
  deviceSerial: 'DEVICE_SERIAL',
  channelNo: 1,
  config: EzvizPlayerConfig(
    appKey: 'APP_KEY',
    accessToken: 'ACCESS_TOKEN',
    autoPlay: true,
    enableAudio: true,
    enableEncryptionDialog: true,
  ),
  onStateChanged: (state) => print('State: $state'),
  onError: (error) => print('Error: $error'),
)
```

### PTZControlPanel
Circular touch control panel for intuitive PTZ control:
```dart
PTZControlPanel(
  size: 250,
  onDirectionStart: (direction) => print('Start $direction'),
  onDirectionStop: (direction) => print('Stop $direction'),
  onCenterTap: () => print('Center tapped'),
)
```

### EnhancedPlayerControls
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

## Core Classes

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