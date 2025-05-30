import 'package:ezviz_flutter/ezviz_flutter.dart';
import 'api_config.dart';

void main() async {
  // API credentials and example serials are now in ApiConfig.dart
  final client = EzvizClient(
    appKey: ApiConfig.appKey,
    appSecret: ApiConfig.appSecret,
  );
  final alarmService = AlarmService(client);

  try {
    print('Fetching alarm list (all devices, unread, first page)...');
    final alarmListResponse = await alarmService.getAlarmList(
      pageSize: 5,
      status: 0, // 0-Unread, 1-Read, 2-All
    );
    print('Alarm List Response: \$alarmListResponse');

    // Example: Fetch alarms for a specific device
    if (ApiConfig.exampleDeviceSerial.isNotEmpty &&
        ApiConfig.exampleDeviceSerial != 'YOUR_DEVICE_SERIAL') {
      print(
        '\nFetching alarm list for device: \${ApiConfig.exampleDeviceSerial}...',
      );
      final deviceAlarms = await alarmService.getAlarmList(
        deviceSerial: ApiConfig.exampleDeviceSerial,
        pageSize: 3,
        // You can also filter by alarmType, startTime, endTime
        // alarmType: EzvizAlarmType.motionDetection.code,
      );
      print(
        'Device (\${ApiConfig.exampleDeviceSerial}) Alarms: \$deviceAlarms',
      );

      // Example: Mark an alarm as read (if you have an alarmId and deviceSerial from the list)
      // This requires a valid alarmId from the fetched list.
      // if (deviceAlarms['code'] == '200' && deviceAlarms['data'] != null && (deviceAlarms['data'] as List).isNotEmpty) {
      //   final firstAlarm = (deviceAlarms['data'] as List).first;
      //   final String alarmIdToRead = firstAlarm['alarmId'];
      //   final String alarmDeviceSerial = firstAlarm['deviceSerial'];
      //   print('\nMarking alarm \$alarmIdToRead as read for device \$alarmDeviceSerial...');
      //   try {
      //     final setReadResponse = await alarmService.setAlarmReadStatus(alarmIdToRead, alarmDeviceSerial);
      //     print('Set Alarm Read Status Response: \$setReadResponse');
      //   } catch (e) {
      //     print('Error marking alarm as read: \$e');
      //   }
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
