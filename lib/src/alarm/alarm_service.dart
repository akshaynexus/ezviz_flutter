import '../ezviz_client.dart';
// import '../models/models.dart'; // For EzvizAlarmType enum - This was unused

class AlarmService {
  final EzvizClient _client;

  AlarmService(this._client);

  /// Get alarm list for the account or a specific device.
  ///
  /// [deviceSerial]: Optional. If provided, fetches alarms for this specific device.
  /// [startTime]: Optional. Alarm search start time (milliseconds since epoch).
  /// [endTime]: Optional. Alarm search end time (milliseconds since epoch).
  /// [alarmType]: Optional. Specific alarm type to filter by (defaults to all).
  /// [status]: Optional. Alarm status: 0-Unread, 1-Read, 2-All (defaults to Unread).
  /// [pageStart]: Optional. Start page for pagination (defaults to 0).
  /// [pageSize]: Optional. Page size for pagination (defaults to 10, max 50).
  Future<Map<String, dynamic>> getAlarmList({
    String? deviceSerial,
    int? startTime,
    int? endTime,
    int? alarmType, // Can also use EzvizAlarmType.code
    int status = 0, // Default to Unread
    int pageStart = 0,
    int pageSize = 10,
  }) async {
    final body = <String, dynamic>{
      'status': status,
      'pageStart': pageStart,
      'pageSize': pageSize,
    };
    if (deviceSerial != null) body['deviceSerial'] = deviceSerial;
    if (startTime != null) body['startTime'] = startTime;
    if (endTime != null) body['endTime'] = endTime;
    if (alarmType != null) body['alarmType'] = alarmType;

    // API endpoint from docs: /api/lapp/alarm/list (used for both all and device-specific)
    // The API doc indicates that for device specific alarms, deviceSerial is added to the body.
    return _client.post('/api/lapp/alarm/list', body);
  }

  /// Set alarm message status to read.
  ///
  /// [alarmId]: The ID of the alarm to mark as read.
  /// [deviceSerial]: The device serial number associated with the alarm.
  Future<Map<String, dynamic>> setAlarmReadStatus(
    String alarmId,
    String deviceSerial,
  ) async {
    // The API doc for setting alarm status is not explicitly in the read section.
    // Assuming an endpoint structure like /api/lapp/alarm/status/set or similar.
    // This is a placeholder and needs verification from complete API docs.
    // Common practice is to update the status of a specific alarm resource.
    // For now, using a hypothetical endpoint, as the provided docs focus on GET.
    // It might also be that alarm status is updated implicitly or not at all via API.
    // The API for "Set Alarm Information Status" is /api/lapp/alarm/status/set
    return _client.post('/api/lapp/alarm/status/set', {
      'alarmId': alarmId,
      'deviceSerial': deviceSerial,
      // 'status': 1, // Implicitly setting to read. API might require this. Needs confirmation.
    });
  }
}
