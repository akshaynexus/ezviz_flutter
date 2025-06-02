# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.1] - 2025-06-02
- Fix crashes and bugs with ezviz_simple_player

## [1.1.0] - 2025-06-02

### Added - EzvizSimplePlayer: Ultimate Easy Integration Component
- **🎯 EzvizSimplePlayer Widget**: Revolutionary new component that makes EZVIZ camera integration incredibly simple
  - **Auto SDK Initialization**: Handles all SDK setup automatically with app key, secret, and access token
  - **Auto Authentication**: Manages login and token handling internally without user intervention
  - **Auto-Play Capability**: Starts streaming immediately when SDK and device are ready
  - **Comprehensive Error Handling**: Built-in error management with customizable error callbacks
  - **Encryption Auto-Detection**: Automatically detects encrypted cameras and prompts for verification codes
  - **Audio Management**: Easy enable/disable audio functionality with one-line configuration
  - **Built-in Controls**: Optional play/pause and audio toggle controls with customizable styling
  - **Real-time State Management**: Live state updates with detailed status callbacks
  - **Customizable UI**: Custom loading widgets, error widgets, and control styling options

### Enhanced Features
- **🔒 Smart Encryption Handling**: Automatic password dialog with remember functionality
- **🎵 Seamless Audio Integration**: Auto-enable audio when stream starts playing
- **🎨 Flexible UI Customization**: Custom loading/error widgets and control styling
- **📱 State Management**: Comprehensive state machine with 8 different player states
- **🔄 Retry Logic**: Automatic retry mechanisms for failed connections and encryption errors
- **💾 Password Storage**: Optional secure storage of encryption passwords per device

### New Configuration Class
- **EzvizPlayerConfig**: Comprehensive configuration object supporting:
  - SDK credentials (appKey, appSecret, accessToken)
  - Authentication options (account/password alternative)
  - Player behavior (autoPlay, enableAudio, showControls)
  - Encryption settings (enableEncryptionDialog)
  - UI customization (loadingWidget, errorWidget, styling options)

### Developer Experience Improvements
- **📝 Comprehensive Documentation**: Updated README with multiple integration examples
  - Minimal setup (3 lines of code)
  - Standard setup with callbacks
  - Advanced setup with custom UI
- **🔧 Example Implementations**: Three complete example implementations:
  - `SimplePlayerExample`: Standard integration with status tracking
  - `MinimalPlayerExample`: Absolute minimal setup demonstration
  - `AdvancedPlayerExample`: Custom UI and advanced state management
- **🎯 Integration Patterns**: Clear progression from simple to complex use cases

### Code Quality & Reliability
- **Fixed Kotlin Serialization Issues**: Resolved persistent kotlinx.serialization runtime errors
- **Manual JSON Building**: Replaced problematic serialization with reliable manual JSON construction
- **Double Encoding Fix**: Fixed JSON parsing issues in Flutter event handling
- **State Synchronization**: Improved player state management and UI updates
- **Memory Management**: Proper disposal and cleanup of controllers and resources

### Migration & Compatibility
- **100% Backward Compatible**: All existing APIs remain unchanged
- **Progressive Enhancement**: Existing apps can adopt EzvizSimplePlayer incrementally
- **Legacy Support**: Traditional EzvizPlayer still available for advanced use cases

## [1.0.8] - 2025-06-02
- Fix crashes from deserialization and add proper encrypted stream support
## [1.0.6] - 2025-06-02
- Revert last changes
## [1.0.5] - 2025-06-02
- Fix serialization errors

## [1.0.4] - 2025-12-19

### Added - Publication Ready Release with Credits
- **Publication Preparation**: Updated package configuration for pub.dev publishing
- **Credits and Acknowledgments**: Added proper attribution to source repositories
  - flutter_ezviz: Core native SDK implementation
  - ezviz_flutter_cam: Enhanced features and UI components
- **Channel Name Consistency**: Standardized method channel names to use `ezviz_flutter` prefix
- **Documentation Updates**: Enhanced README with proper credits and migration guide

### Fixed
- Method channel naming consistency across all components
- Event channel naming alignment with package standards
- Wi-Fi configuration event channel naming

### Documentation
- Added comprehensive credits section acknowledging source repositories
- Updated version references to 1.0.4
- Enhanced migration instructions
- Added links to original repositories

## [1.0.3] - 2025-12-19

### Added - Major Native SDK Integration + Enhanced Features from ezviz_flutter_cam
- **Native Android/iOS SDK Support**: Complete integration with EZVIZ native SDKs for both platforms
- **Live Video Streaming**: Real-time video playback with native performance using `EzvizPlayer` widget
- **PTZ Control**: Full pan, tilt, zoom camera control with `EzvizManager.controlPTZ()`
- **Video Player Widget**: Native video player component with platform-specific implementations
- **Device Management**: Native device discovery and management through `EzvizManager.shared()`
- **Video Quality Control**: Adjust streaming quality (smooth, balanced, HD, UHD)
- **Network Device Support**: Connect to local network cameras with login/logout functionality
- **Event Handling**: Real-time event system for player status and SDK events
- **Error Code Mapping**: Comprehensive error code definitions with descriptions

### New Enhanced Features (from ezviz_flutter_cam)
- **Audio & Intercom**: Two-way audio communication with half-duplex and full-duplex support
  - `EzvizAudio.startVoiceTalk()` - Start intercom session
  - `EzvizAudio.stopVoiceTalk()` - Stop intercom session
  - `EzvizAudio.openSound()` / `EzvizAudio.closeSound()` - Audio control
- **Recording & Screenshots**: Video recording and image capture during playback
  - `EzvizRecording.startRecording()` / `EzvizRecording.stopRecording()`
  - `EzvizRecording.capturePicture()` - Take screenshots
  - `EzvizRecording.isRecording()` - Check recording status
- **Wi-Fi Configuration**: Device network setup capabilities
  - `EzvizWifiConfig.startWifiConfig()` - Wi-Fi configuration mode
  - `EzvizWifiConfig.startAPConfig()` - Access Point configuration mode
  - Sound wave configuration support
- **Enhanced Playback Controls**: Advanced video playback features
  - `pausePlayback()` / `resumePlayback()` - Pause and resume playback
  - Enhanced video player with full-screen support

### New UI Components
- **PTZControlPanel**: Circular touch control panel for intuitive camera movement
  - 360-degree touch control with visual feedback
  - Direction indicators and center tap functionality
  - Customizable size, colors, and icons
- **EnhancedPlayerControls**: Professional video player interface
  - Auto-hiding controls with tap-to-show functionality
  - Recording indicator with pulsing animation
  - Quality selector dropdown
  - Full-screen toggle and sound controls
  - Play/pause, stop, record, and screenshot buttons

### New Classes and APIs
- `EzvizAudio` - Audio and intercom management
- `EzvizRecording` - Recording and screenshot functionality
- `EzvizWifiConfig` - Wi-Fi configuration management
- `EzvizWifiConfigResult` - Configuration result model
- `EzvizWifiConfigMode` - Configuration mode enumeration
- `PTZControlPanel` - Circular PTZ control widget
- `EnhancedPlayerControls` - Advanced player controls widget

### Enhanced Player Controller
- Added pause/resume functionality for playback
- Audio control methods (openSound/closeSound)
- Recording methods (start/stop/status)
- Screenshot capture capability
- Enhanced error handling and logging

### Platform Enhancements
- **Android**: Additional NDK configuration and library support
- **iOS**: Enhanced Info.plist permissions for audio, location, and photo library
- **Xcode**: Access WiFi Information and Hotspot Configuration capabilities

### Documentation Improvements
- Comprehensive examples for all new features
- Setup guides for audio, recording, and Wi-Fi configuration
- Feature comparison table (HTTP API vs Native SDK)
- Migration guide from v1.0.2
- Troubleshooting section for new features

### Backward Compatibility
- All existing HTTP API functionality preserved
- Legacy `EzvizClient` still available
- Existing models and services unchanged
- Smooth migration path for existing users

## [1.0.2] - 2025-11-15

### Added
- Enhanced device management capabilities
- Improved error handling for API responses
- Additional device information fields

### Fixed
- Authentication token refresh issues
- Device list pagination handling
- PTZ control response parsing

## [1.0.1] - 2025-10-20

### Added
- RAM (Sub-Account) management service
- Cloud storage service integration
- Detector management for A1 series devices

### Fixed
- Authentication flow improvements
- API response model serialization
- Error handling for network timeouts

## [1.0.0] - 2025-09-15

### Added - Initial Release
- Complete HTTP API integration for EZVIZ Open Platform
- Authentication service with automatic token management
- Device management (list, add, remove, configure)
- Live streaming URL generation (HLS, RTMP, FLV)
- PTZ control for supported cameras
- Alarm management and notifications
- Comprehensive error handling with custom exceptions
- Type-safe models with json_serializable
- Example applications for all services
- Integration test suite

### Services Included
- `AuthService` - Authentication and token management
- `DeviceService` - Device operations and configuration
- `LiveService` - Live stream URL generation
- `PtzService` - Pan-tilt-zoom camera control
- `AlarmService` - Alarm and notification management
- `DetectorService` - Motion detector management
- `CloudStorageService` - Cloud storage operations
- `RamAccountService` - Sub-account management

### Models and Types
- Comprehensive data models for all API responses
- Type-safe request/response handling
- Null-safe implementation
- Custom exception types for better error handling
