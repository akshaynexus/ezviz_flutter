import 'package:ezviz_flutter/ezviz_flutter.dart';
import 'api_config.dart';

void main() async {
  // API credentials and example serials are now in ApiConfig.dart
  final client = EzvizClient(
    appKey: ApiConfig.appKey,
    appSecret: ApiConfig.appSecret,
  );
  final liveService = LiveService(client);

  if (ApiConfig.exampleDeviceSerial.isEmpty ||
      ApiConfig.exampleDeviceSerial == 'YOUR_DEVICE_SERIAL') {
    print(
      'Please replace YOUR_DEVICE_SERIAL in ApiConfig.dart with an actual device serial to run this example.',
    );
    return;
  }

  try {
    print(
      'Getting live play address for device: \${ApiConfig.exampleDeviceSerial}...',
    );
    // You might need to adjust parameters like protocol, quality, etc., based on device capabilities and needs.
    final playAddressResponse = await liveService.getPlayAddress(
      ApiConfig.exampleDeviceSerial,
      channelNo: 1,
      protocol: 1, // 1 for HLS, 2 for RTMP, 3 for FLV
      quality: 2, // Example: HD
    );
    print('Play Address Response: \$playAddressResponse');

    // Extract the URL if successful
    if (playAddressResponse['code'] == '200' &&
        playAddressResponse['data'] != null) {
      final playUrl = playAddressResponse['data']['url'];
      final playId = playAddressResponse['data']['id'];
      print('Successfully fetched play URL: \$playUrl (ID: \$playId)');

      // Normally, you would pass this URL to a video player.

      // Example of how you might invalidate a play address (if needed)
      // This API is not explicitly in the docs but is a common counterpart to getting a limited-time URL.
      // The EZVIZ API might handle this via URL expiry or a different mechanism.
      // print('\nInvalidating play address (example - actual API may differ)...');
      // try {
      //   final invalidateResponse = await liveService.invalidatePlayAddress(ApiConfig.exampleDeviceSerial, playId: playId!);
      //   print('Invalidate Response: \$invalidateResponse');
      // } catch (e) {
      //   print('Error invalidating play address: \$e');
      // }
    }
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
