import 'package:ezviz_flutter/ezviz_flutter.dart';
import 'dart:io'; // For sleep
import 'api_config.dart';

void main() async {
  // API credentials and example serials are now in ApiConfig.dart
  const int channelNo = 1;

  final client = EzvizClient(
    appKey: ApiConfig.appKey,
    appSecret: ApiConfig.appSecret,
  );
  final ptzService = PtzService(client);

  if (ApiConfig.examplePtzDeviceSerial.isEmpty ||
      ApiConfig.examplePtzDeviceSerial == 'YOUR_PTZ_DEVICE_SERIAL') {
    print(
      'Please replace YOUR_PTZ_DEVICE_SERIAL in ApiConfig.dart with an actual PTZ-capable device serial to run this example.',
    );
    return;
  }

  try {
    print(
      'Starting PTZ control (UP) for device: \${ApiConfig.examplePtzDeviceSerial}, channel: \$channelNo',
    );
    final startPtzResponse = await ptzService.startPtz(
      ApiConfig.examplePtzDeviceSerial,
      channelNo,
      direction: PtzCommand.up,
      speed: PtzSpeed.medium,
    );
    print('Start PTZ Response: \$startPtzResponse');

    // Let the PTZ move for a short duration
    print('Waiting for 2 seconds while PTZ moves...');
    sleep(const Duration(seconds: 2));

    print(
      '\nStopping PTZ control for device: \${ApiConfig.examplePtzDeviceSerial}, channel: \$channelNo',
    );
    final stopPtzResponse = await ptzService.stopPtz(
      ApiConfig.examplePtzDeviceSerial,
      channelNo,
      direction: PtzCommand
          .up, // Direction might be optional or required by API for stop
    );
    print('Stop PTZ Response: \$stopPtzResponse');

    // Example: Add a preset (assuming presetIndex 1 is available)
    // print('\nAdding preset 1 for device: \${ApiConfig.examplePtzDeviceSerial}, channel: \$channelNo');
    // final addPresetResponse = await ptzService.addPreset(ApiConfig.examplePtzDeviceSerial, channelNo, presetIndex: 1);
    // print('Add Preset Response: \$addPresetResponse');

    // Example: Move to preset 1
    // print('\nMoving to preset 1 for device: \${ApiConfig.examplePtzDeviceSerial}, channel: \$channelNo');
    // final moveToPresetResponse = await ptzService.moveToPreset(ApiConfig.examplePtzDeviceSerial, channelNo, presetIndex: 1);
    // print('Move to Preset Response: \$moveToPresetResponse');

    // Example: Clear preset 1
    // print('\nClearing preset 1 for device: \${ApiConfig.examplePtzDeviceSerial}, channel: \$channelNo');
    // final clearPresetResponse = await ptzService.clearPreset(ApiConfig.examplePtzDeviceSerial, channelNo, presetIndex: 1);
    // print('Clear Preset Response: \$clearPresetResponse');

    // Example: Mirror PTZ (Center)
    // print('\nSetting PTZ mirror to Center for device: \${ApiConfig.examplePtzDeviceSerial}, channel: \$channelNo');
    // final mirrorPtzResponse = await ptzService.mirrorPtz(ApiConfig.examplePtzDeviceSerial, channelNo, PtzMirrorCommand.center);
    // print('Mirror PTZ Response: \$mirrorPtzResponse');
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
