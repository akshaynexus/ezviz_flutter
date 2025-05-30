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
