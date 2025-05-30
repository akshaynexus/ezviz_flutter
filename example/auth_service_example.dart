import 'package:ezviz_flutter/ezviz_flutter.dart';
import 'api_config.dart';

void main() async {
  // API credentials are now in ApiConfig.dart
  final client = EzvizClient(
    appKey: ApiConfig.appKey,
    appSecret: ApiConfig.appSecret,
  );
  final authService = AuthService(client);

  print(
    'Attempting to ensure client is authenticated (triggers token fetch if needed)...',
  );
  try {
    // EzvizClient handles authentication automatically on the first API call.
    // AuthService.login() can be used to explicitly trigger this.
    // Or, you can just call any other service method.
    await authService
        .login(); // This makes a dummy call to '/api/lapp/token/get'
    print('Authentication process completed or token already valid.');
    print(
      'Access Token (will be fetched automatically by client): \${client.getAccessToken()}',
    ); // Added a getter for illustration

    // At this point, the client should have an access token if authentication was successful.
    // You can now proceed to call other EZVIZ API methods.

    // Example: Fetch device list (which also requires authentication)
    // final deviceService = DeviceService(client);
    // print('Fetching device list...');
    // final devices = await deviceService.getDeviceList();
    // print('Device list response: \$devices');
  } catch (e) {
    if (e is EzvizAuthException) {
      print('EZVIZ Authentication Error: \${e.message} (Code: \${e.code})');
    } else if (e is EzvizApiException) {
      print('EZVIZ API Error: \${e.message} (Code: \${e.code})');
    } else {
      print('An unexpected error occurred: \$e');
    }
  }
}
