import 'package:ezviz_flutter/ezviz_flutter.dart';
import 'api_config.dart';

void main() async {
  // API credentials and example serials are now in ApiConfig.dart
  final client = EzvizClient(
    appKey: ApiConfig.appKey,
    appSecret: ApiConfig.appSecret,
  );
  final cloudService = CloudStorageService(client);

  if (ApiConfig.exampleDeviceSerial.isEmpty ||
      ApiConfig.exampleDeviceSerial == 'YOUR_DEVICE_SERIAL') {
    print(
      'Please replace YOUR_DEVICE_SERIAL in ApiConfig.dart with an actual device serial to run this example.',
    );
    return;
  }

  try {
    print(
      'Fetching cloud storage info for device: \${ApiConfig.exampleDeviceSerial}...',
    );
    final cloudInfoResponse = await cloudService.getCloudStorageInfo(
      ApiConfig.exampleDeviceSerial,
    );
    print('Cloud Storage Info Response: \$cloudInfoResponse');

    // Example: Enable cloud storage (Use with caution and a valid, unused card password)
    // if (ApiConfig.exampleCloudCardPassword.isNotEmpty && ApiConfig.exampleCloudCardPassword != 'YOUR_CLOUD_CARD_PASSWORD') {
    //   print('\nAttempting to enable cloud storage for device: \${ApiConfig.exampleDeviceSerial}...');
    //   try {
    //     final enableResponse = await cloudService.enableCloudStorage(
    //       ApiConfig.exampleDeviceSerial,
    //       ApiConfig.exampleCloudCardPassword,
    //       // channelNo: 1, // Optional
    //       // isImmediately: 1, // Optional
    //     );
    //     print('Enable Cloud Storage Response: \$enableResponse');
    //   } catch (e) {
    //     print('Error enabling cloud storage: \$e');
    //   }
    // }
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
