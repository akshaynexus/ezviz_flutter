import 'package:ezviz_flutter/ezviz_flutter.dart';
import 'api_config.dart';

void main() async {
  // Create EzvizClient with flexible authentication
  // Priority: Use accessToken if available, otherwise use appKey+appSecret
  final client = _createEzvizClient();
  final alarmService = AlarmService(client);

  try {
    print('Fetching alarm list (all devices, unread, first page)...');
    final alarmListResponse = await alarmService.getAlarmList(
      pageSize: 5,
      status: 0, // 0-Unread, 1-Read, 2-All
    );
    print('Alarm List Response: $alarmListResponse');

    // Example: Fetch alarms for a specific device
    if (ApiConfig.exampleDeviceSerial.isNotEmpty &&
        ApiConfig.exampleDeviceSerial != 'YOUR_DEVICE_SERIAL') {
      print(
        '\nFetching alarm list for device: ${ApiConfig.exampleDeviceSerial}...',
      );
      final deviceAlarms = await alarmService.getAlarmList(
        deviceSerial: ApiConfig.exampleDeviceSerial,
        pageSize: 3,
        // You can also filter by alarmType, startTime, endTime
        // alarmType: EzvizAlarmType.motionDetection.code,
      );
      print('Device (${ApiConfig.exampleDeviceSerial}) Alarms: $deviceAlarms');

      // Example: Mark an alarm as read (if you have an alarmId and deviceSerial from the list)
      // This requires a valid alarmId from the fetched list.
      // if (deviceAlarms['code'] == '200' && deviceAlarms['data'] != null && (deviceAlarms['data'] as List).isNotEmpty) {
      //   final firstAlarm = (deviceAlarms['data'] as List).first;
      //   final String alarmIdToRead = firstAlarm['alarmId'];
      //   final String alarmDeviceSerial = firstAlarm['deviceSerial'];
      //   print('\nMarking alarm $alarmIdToRead as read for device $alarmDeviceSerial...');
      //   try {
      //     final setReadResponse = await alarmService.setAlarmReadStatus(alarmIdToRead, alarmDeviceSerial);
      //     print('Set Alarm Read Status Response: $setReadResponse');
      //   } catch (e) {
      //     print('Error marking alarm as read: $e');
      //   }
      // }
    }
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

/// Creates EzvizClient with flexible authentication options.
///
/// Demonstrates two authentication methods:
/// 1. Direct access token authentication (recommended)
/// 2. App key + secret authentication (fallback)
EzvizClient _createEzvizClient() {
  // Method 1: Use access token directly (recommended if you have it)
  if (ApiConfig.accessToken.isNotEmpty &&
      ApiConfig.accessToken != 'YOUR_ACCESS_TOKEN') {
    print('Using direct access token authentication...');
    return EzvizClient(
      accessToken: ApiConfig.accessToken,
      areaDomain:
          ApiConfig.areaDomain.isNotEmpty &&
              ApiConfig.areaDomain != 'YOUR_AREA_DOMAIN'
          ? ApiConfig.areaDomain
          : null,
    );
  }

  // Method 2: Use appKey + appSecret (will obtain access token via API)
  if (ApiConfig.appKey.isNotEmpty &&
      ApiConfig.appKey != 'YOUR_APP_KEY' &&
      ApiConfig.appSecret.isNotEmpty &&
      ApiConfig.appSecret != 'YOUR_APP_SECRET') {
    print('Using app key + secret authentication...');
    return EzvizClient(
      appKey: ApiConfig.appKey,
      appSecret: ApiConfig.appSecret,
    );
  }

  throw Exception(
    'Please configure either:\n'
    '1. AccessToken (+ optional AreaDomain) in ApiConfig, or\n'
    '2. AppKey + AppSecret in ApiConfig',
  );
}
