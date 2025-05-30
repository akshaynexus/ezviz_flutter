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
