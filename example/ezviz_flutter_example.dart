import 'package:ezviz_flutter/ezviz_flutter.dart';

void main() {
  // Example of instantiating the EzvizClient
  // Replace with your actual appKey and appSecret
  final client = EzvizClient(
    appKey: 'YOUR_APP_KEY',
    appSecret: 'YOUR_APP_SECRET',
  );
  print('EzvizClient instantiated. App Key: ${client.appKey}');

  // Example usage of a service (optional, uncomment and adapt)
  // final authService = AuthService(client);
  // authService.login().then((_) {
  //   print('Login attempt done (or token fetched if already authenticated).');
  // }).catchError((e) {
  //   print('Login error: $e');
  // });
}
