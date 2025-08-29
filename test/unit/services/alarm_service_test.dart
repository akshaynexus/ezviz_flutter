import 'package:flutter_test/flutter_test.dart';
import 'package:ezviz_flutter/src/alarm/alarm_service.dart';
// Removed unused import
import '../../../test/test_utils.dart';

void main() {
  group('AlarmService', () {
    late MockEzvizClient mockClient;
    late AlarmService alarmService;

    setUp(() {
      mockClient = MockEzvizClient();
      alarmService = AlarmService(mockClient);
    });

    test('creates service with client', () {
      expect(alarmService, isA<AlarmService>());
    });

    group('getAlarmList', () {
      test('with default parameters', () async {
        final expectedResponse = {
          'alarms': [],
          'total': 0,
          'pageStart': 0,
          'pageSize': 10,
        };
        mockClient.mockResponse = expectedResponse;

        final result = await alarmService.getAlarmList();

        result.expectMeaningful(
          equals(expectedResponse),
          reason: 'Should return alarm list response',
        );
        mockClient.lastEndpoint.expectMeaningful(
          equals('/api/lapp/alarm/list'),
          reason: 'Should use correct endpoint for alarm list',
        );
        mockClient.lastBody.expectMeaningful(
          equals({
            'status': 0, // Default: Unread
            'pageStart': 0,
            'pageSize': 10,
          }),
          reason: 'Should use default parameters for alarm list',
        );
      });

      test('with all parameters', () async {
        final expectedResponse = {'alarms': [], 'total': 0};
        mockClient.mockResponse = expectedResponse;

        final result = await alarmService.getAlarmList(
          deviceSerial: 'TEST123',
          startTime: 1640995200000, // 2022-01-01 00:00:00 UTC in milliseconds
          endTime: 1672531199000, // 2022-12-31 23:59:59 UTC in milliseconds
          alarmType: 1,
          status: 2, // All
          pageStart: 5,
          pageSize: 20,
        );

        result.expectMeaningful(
          equals(expectedResponse),
          reason: 'Should return alarm list response',
        );
        mockClient.lastBody.expectMeaningful(
          equals({
            'deviceSerial': 'TEST123',
            'startTime': 1640995200000,
            'endTime': 1672531199000,
            'alarmType': 1,
            'status': 2,
            'pageStart': 5,
            'pageSize': 20,
          }),
          reason: 'Should include all provided parameters',
        );
      });

      test('with device-specific query', () async {
        final expectedResponse = {'alarms': [], 'total': 0};
        mockClient.mockResponse = expectedResponse;

        await alarmService.getAlarmList(
          deviceSerial: 'TEST123',
          status: 1, // Read
        );

        mockClient.lastBody.expectMeaningful(
          equals({
            'deviceSerial': 'TEST123',
            'status': 1,
            'pageStart': 0,
            'pageSize': 10,
          }),
          reason: 'Should include device serial for device-specific queries',
        );
      });

      test('with time range only', () async {
        final expectedResponse = {'alarms': [], 'total': 0};
        mockClient.mockResponse = expectedResponse;

        await alarmService.getAlarmList(
          startTime: 1640995200000,
          endTime: 1672531199000,
        );

        mockClient.lastBody.expectMeaningful(
          equals({
            'startTime': 1640995200000,
            'endTime': 1672531199000,
            'status': 0,
            'pageStart': 0,
            'pageSize': 10,
          }),
          reason: 'Should include time range without device serial',
        );
      });

      test('with alarm type filter', () async {
        final expectedResponse = {'alarms': [], 'total': 0};
        mockClient.mockResponse = expectedResponse;

        await alarmService.getAlarmList(
          alarmType: 5,
          status: 2,
        );

        mockClient.lastBody.expectMeaningful(
          containsPair('alarmType', 5),
          reason: 'Should include alarm type filter',
        );
        mockClient.lastBody.expectMeaningful(
          containsPair('status', 2),
          reason: 'Should include status filter',
        );
      });

      test('with custom pagination', () async {
        final expectedResponse = {'alarms': [], 'total': 0};
        mockClient.mockResponse = expectedResponse;

        await alarmService.getAlarmList(
          pageStart: 10,
          pageSize: 50,
        );

        mockClient.lastBody.expectMeaningful(
          containsPair('pageStart', 10),
          reason: 'Should use custom page start',
        );
        mockClient.lastBody.expectMeaningful(
          containsPair('pageSize', 50),
          reason: 'Should use custom page size',
        );
      });
    });

    group('setAlarmReadStatus', () {
      test('makes correct API call', () async {
        final expectedResponse = {'success': true};
        mockClient.mockResponse = expectedResponse;

        final result = await alarmService.setAlarmReadStatus('ALARM123', 'TEST123');

        result.expectMeaningful(
          equals(expectedResponse),
          reason: 'Should return alarm status update response',
        );
        mockClient.lastEndpoint.expectMeaningful(
          equals('/api/lapp/alarm/status/set'),
          reason: 'Should use correct endpoint for setting alarm status',
        );
        mockClient.lastBody.expectMeaningful(
          equals({
            'alarmId': 'ALARM123',
            'deviceSerial': 'TEST123',
          }),
          reason: 'Should include alarm ID and device serial',
        );
      });

      test('handles different alarm ID formats', () async {
        final expectedResponse = {'success': true};
        mockClient.mockResponse = expectedResponse;

        // Test with numeric alarm ID
        await alarmService.setAlarmReadStatus('12345', 'TEST123');

        mockClient.lastBody.expectMeaningful(
          containsPair('alarmId', '12345'),
          reason: 'Should handle numeric alarm IDs as strings',
        );

        // Test with UUID-style alarm ID
        await alarmService.setAlarmReadStatus(
          'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
          'TEST123',
        );

        mockClient.lastBody.expectMeaningful(
          containsPair('alarmId', 'a1b2c3d4-e5f6-7890-abcd-ef1234567890'),
          reason: 'Should handle UUID-style alarm IDs',
        );
      });

      test('handles different device serial formats', () async {
        final expectedResponse = {'success': true};
        mockClient.mockResponse = expectedResponse;

        // Test with alphanumeric device serial
        await alarmService.setAlarmReadStatus('ALARM123', 'DEV456ABC');

        mockClient.lastBody.expectMeaningful(
          containsPair('deviceSerial', 'DEV456ABC'),
          reason: 'Should handle alphanumeric device serials',
        );
      });
    });

    group('Error Handling', () {
      test('handles API errors gracefully', () async {
        mockClient.throwError = true;

        expect(
          () => alarmService.getAlarmList(),
          throwsA(isA<Exception>()),
        );
      });

      test('handles network errors gracefully', () async {
        mockClient.throwError = true;

        expect(
          () => alarmService.setAlarmReadStatus('ALARM123', 'TEST123'),
          throwsA(isA<Exception>()),
        );
      });

      test('handles invalid alarm ID gracefully', () async {
        mockClient.throwError = true;
        mockClient.errorMessage = 'Invalid alarm ID';

        expect(
          () => alarmService.setAlarmReadStatus('', 'TEST123'),
          throwsA(predicate((e) => e.toString().contains('Invalid alarm ID'))),
        );
      });

      test('handles pagination errors gracefully', () async {
        mockClient.throwError = true;
        mockClient.errorMessage = 'Invalid pagination parameters';

        expect(
          () => alarmService.getAlarmList(pageStart: -1, pageSize: 0),
          throwsA(predicate((e) => e.toString().contains('Invalid pagination'))),
        );
      });
    });

    group('Integration Scenarios', () {
      test('typical alarm monitoring workflow', () async {
        // First, get unread alarms
        mockClient.mockResponse = {
          'alarms': [
            {'id': 'ALARM1', 'type': 1, 'status': 0},
            {'id': 'ALARM2', 'type': 2, 'status': 0},
          ],
          'total': 2,
        };

        final alarmList = await alarmService.getAlarmList(status: 0);

        alarmList.expectMeaningful(
          containsPair('total', 2),
          reason: 'Should return unread alarms',
        );

        // Then mark first alarm as read
        mockClient.mockResponse = {'success': true};
        final statusUpdate = await alarmService.setAlarmReadStatus(
          'ALARM1',
          'TEST123',
        );

        statusUpdate.expectMeaningful(
          containsPair('success', true),
          reason: 'Should successfully mark alarm as read',
        );
      });

      test('device-specific alarm filtering', () async {
        mockClient.mockResponse = {'alarms': [], 'total': 0};

        // Get alarms for specific device with time range
        await alarmService.getAlarmList(
          deviceSerial: 'CAMERA001',
          startTime: 1640995200000,
          endTime: 1672531199000,
          alarmType: 1, // Motion detection
          status: 2, // All alarms
        );

        mockClient.lastBody.expectMeaningful(
          allOf([
            containsPair('deviceSerial', 'CAMERA001'),
            containsPair('alarmType', 1),
            containsPair('status', 2),
          ]),
          reason: 'Should filter alarms by device and type',
        );
      });
    });
  });
}
