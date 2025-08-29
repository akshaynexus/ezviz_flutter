import 'package:ezviz_flutter/ezviz_flutter.dart';
import 'api_config.dart';

void main() async {
  // API credentials and example serials are now in ApiConfig.dart
  final client = EzvizClient(
    appKey: ApiConfig.appKey,
    appSecret: ApiConfig.appSecret,
  );
  final detectorService = DetectorService(client);

  if (ApiConfig.exampleA1HubSerial.isEmpty ||
      ApiConfig.exampleA1HubSerial == 'YOUR_A1_HUB_DEVICE_SERIAL') {
    print(
      'Please replace YOUR_A1_HUB_DEVICE_SERIAL in ApiConfig.dart with an actual A1 Hub serial to run this example.',
    );
    return;
  }

  try {
    print(
      'Fetching detector list for A1 Hub: ${ApiConfig.exampleA1HubSerial}...',
    );
    final detectorListResponse = await detectorService.getDetectorList(
      ApiConfig.exampleA1HubSerial,
    );
    print('Detector List Response: $detectorListResponse');

    if (ApiConfig.exampleLinkedDetectorSerial.isNotEmpty &&
        ApiConfig.exampleLinkedDetectorSerial !=
            'YOUR_LINKED_DETECTOR_SERIAL') {
      print(
        '\nSetting detector (${ApiConfig.exampleLinkedDetectorSerial}) status to Away & Enabled...',
      );
      final setStatusResponse = await detectorService.setDetectorStatus(
        ApiConfig.exampleA1HubSerial,
        ApiConfig.exampleLinkedDetectorSerial,
        DetectorSafeMode.away,
        true,
      );
      print('Set Detector Status Response: $setStatusResponse');

      // Example: Edit detector name
      // print('\nEditing name for detector \${ApiConfig.exampleLinkedDetectorSerial}...');
      // final editNameResponse = await detectorService.editDetectorName(ApiConfig.exampleA1HubSerial, ApiConfig.exampleLinkedDetectorSerial, 'MyFavoriteSensor');
      // print('Edit Detector Name Response: \$editNameResponse');

      // Example: Get list of IPCs that can be bound to this A1 hub
      // print('\nFetching bindable IPC list for A1 Hub: \${ApiConfig.exampleA1HubSerial}...');
      // final bindableIpcs = await detectorService.getBindableIpcList(ApiConfig.exampleA1HubSerial);
      // print('Bindable IPCs: \$bindableIpcs');
    }

    // Example: Clear all alarms for the A1 Hub (if supported)
    // print('\nClearing alarms for A1 Hub: \${ApiConfig.exampleA1HubSerial}...');
    // final clearAlarmsResponse = await detectorService.clearDeviceAlarms(ApiConfig.exampleA1HubSerial);
    // print('Clear Alarms Response: \$clearAlarmsResponse');
  } catch (e) {
    if (e is EzvizAuthException) {
      print('EZVIZ Authentication Error: ${e.message} (Code: ${e.code})');
    } else if (e is EzvizApiException) {
      print('EZVIZ API Error: ${e.message} (Code: ${e.code})');
    } else {
      print('An unexpected error occurred: $e');
    }
  }
}
