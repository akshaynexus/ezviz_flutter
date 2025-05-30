## 1.0.3

### 🔐 Enhanced Live Streaming with Password Support
- **New Password Parameter**: Added `password` parameter to `LiveService.getPlayAddress()` method for encrypted devices
- **Automatic Encryption Handling**: New `getPlayAddressWithPassword()` method that automatically handles encryption errors
- **Intuitive API**: `password` parameter serves as an alias for the `code` parameter, making it more developer-friendly
- **Multiple Protocol Support**: Enhanced documentation for RTMP, HLS, FLV, and WebRTC protocols

### 🚀 New Features
- **`LiveService.getPlayAddressWithPassword()`**: Automatically tries without password first, then retries with password on encryption errors
- **Enhanced Error Handling**: Better handling of error code 60019 (encryption enabled, parameter code is empty)
- **Flexible Authentication**: Support for both `code` and `password` parameters (password takes precedence)
- **Protocol & Quality Options**: Clear documentation for all supported streaming protocols and quality levels

### 📚 Documentation & Examples
- **Comprehensive Examples**: Updated `live_service_example.dart` with multiple scenarios:
  - Basic live streaming (no encryption)
  - Encrypted device streaming with passwords
  - Automatic encryption handling
  - Multiple devices with different passwords
  - Different protocols (RTMP, HLS, FLV, WebRTC) and quality settings
- **Error Handling Guide**: Helper functions demonstrating proper error handling for common scenarios
- **Parameter Documentation**: Detailed explanations for all LiveService parameters

### 🔧 Developer Experience Improvements
- **Intuitive Parameter Names**: `password` parameter for better code readability
- **Smart Fallback Logic**: Automatic retry mechanism for encrypted devices
- **Error Code Mapping**: Clear error handling for device encryption, offline devices, and invalid serials
- **Multi-Device Support**: Examples showing how to handle multiple devices with different encryption settings

### 📺 Streaming Protocol Support
- **Protocol 0**: RTMP streaming
- **Protocol 1**: HLS streaming (recommended for web/mobile)
- **Protocol 2**: FLV streaming  
- **Protocol 3**: WebRTC streaming (lowest latency)

### 🎯 Quality Level Support
- **Quality 0**: Smooth (optimized for bandwidth)
- **Quality 1**: HD (720p)
- **Quality 2**: Ultra HD (1080p)

### 🛠️ Technical Details
- Enhanced `LiveService` class with backward compatibility
- Improved error detection for encryption-related issues (error 60019)
- Better parameter validation and fallback handling
- Comprehensive example coverage for real-world usage scenarios

## 1.0.2

### 🐛 Bug Fixes
- **Fixed Type Casting Error**: Resolved `type 'int' is not a subtype of type 'String' in type cast` error in HTTP requests
- **HTTP Form Data**: All parameter values are now properly converted to strings for `application/x-www-form-urlencoded` requests
- **DeviceService**: Fixed `getDeviceList()` method and all other methods with integer parameters (`pageStart`, `pageSize`, `channelNo`, etc.)
- **Universal Fix**: Fixed type casting issues across all service classes that pass integer, boolean, or other non-string parameters

### 🔧 Technical Details
- Modified `EzvizClient.post()` method to automatically convert all body parameters to strings before HTTP requests
- Ensures compatibility with form-encoded HTTP POST requests which require string values
- Affects all service methods including device management, alarm handling, live streaming, PTZ control, and more

## 1.0.1

### 🚀 New Features
- **Flexible Authentication**: Added support for direct access token authentication alongside existing app key/secret authentication
- **Enhanced EzvizClient Constructor**: Now accepts either `accessToken` + optional `areaDomain` OR `appKey` + `appSecret`
- **Improved Error Handling**: Better error messages for authentication failures and token validation
- **Automatic Token Management**: Smart handling of provided vs API-obtained tokens

### 📚 Documentation
- Updated README with comprehensive authentication examples
- Added new `authentication_examples.dart` demonstrating both auth methods
- Updated API configuration examples for flexible authentication
- Improved code documentation and examples

### 🔧 Improvements
- Better validation of authentication parameters at construction time
- Enhanced authentication flow with automatic retry for expired tokens
- More intuitive authentication priority (access token preferred over app credentials)

## 1.0.0

- Initial version.
