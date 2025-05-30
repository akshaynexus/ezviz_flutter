import 'package:ezviz_flutter/ezviz_flutter.dart';
import 'api_config.dart';

void main() async {
  // API credentials and example serials are now in ApiConfig.dart
  final client = EzvizClient(
    appKey: ApiConfig.appKey,
    appSecret: ApiConfig.appSecret,
  );
  final deviceService = DeviceService(client);

  try {
    print('Fetching device list...');
    final deviceListResponse = await deviceService.getDeviceList(pageSize: 5);
    print('Device List: \$deviceListResponse');

    if (ApiConfig.exampleDeviceSerial.isNotEmpty &&
        ApiConfig.exampleDeviceSerial != 'YOUR_DEVICE_SERIAL') {
      print('\nFetching info for device: \${ApiConfig.exampleDeviceSerial}...');
      final deviceInfoResponse = await deviceService.getDeviceInfo(
        ApiConfig.exampleDeviceSerial,
      );
      print(
        'Device Info (\${ApiConfig.exampleDeviceSerial}): \$deviceInfoResponse',
      );

      print(
        '\nCapturing picture from device: \${ApiConfig.exampleDeviceSerial}...',
      );
      final captureResponse = await deviceService.capturePicture(
        ApiConfig.exampleDeviceSerial,
        channelNo: 1,
      );
      print('Capture Picture Response: \$captureResponse');

      print(
        '\nGetting audio prompt status for device: \${ApiConfig.exampleDeviceSerial}...',
      );
      final audioPromptStatus = await deviceService.getAudioPromptStatus(
        ApiConfig.exampleDeviceSerial,
      );
      print('Audio Prompt Status: \$audioPromptStatus');

      // Example: Set defence mode (Arming)
      // print('\nSetting defence mode (Arm) for device: \${ApiConfig.exampleDeviceSerial}...');
      // final setDefenceResponse = await deviceService.setDefenceMode(ApiConfig.exampleDeviceSerial, 1); // 1 for Arm, 0 for Disarm
      // print('Set Defence Mode Response: \$setDefenceResponse');

      // Example: Get Fill Light Mode (V3 API)
      // print('\nGetting fill light mode for device: \${ApiConfig.exampleDeviceSerial}...');
      // final fillLightMode = await deviceService.getFillLightMode(ApiConfig.exampleDeviceSerial);
      // print('Fill Light Mode: \$fillLightMode');

      // Example: Get Device Capability
      // print('\nGetting device capability for \${ApiConfig.exampleDeviceSerial}');
      // final capability = await deviceService.getDeviceCapability(ApiConfig.exampleDeviceSerial);
      // print('Device Capability: \$capability');
    }

    print('\nFetching timezone list...');
    final timezoneList = await deviceService.getTimezoneList();
    print('Timezone List: \$timezoneList');
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
