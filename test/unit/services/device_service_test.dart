import 'package:flutter_test/flutter_test.dart';
import 'package:ezviz_flutter/src/device/device_service.dart';
import 'package:ezviz_flutter/src/ezviz_client.dart';
import '../../../test/test_utils.dart';

void main() {
  group('DeviceService', () {
    late MockEzvizClient mockClient;
    late DeviceService deviceService;

    setUp(() {
      mockClient = MockEzvizClient();
      deviceService = DeviceService(mockClient);
    });

    group('Device Management', () {
      test('addDevice makes correct API call', () async {
        final expectedResponse = {'success': true, 'deviceId': '12345'};
        mockClient.mockResponse = expectedResponse;

        final result = await deviceService.addDevice('TEST123', 'ABC123');

        result.expectMeaningful(
          equals(expectedResponse),
          reason: 'Should return success response for device addition',
        );
        mockClient.lastEndpoint.expectMeaningful(
          equals('/api/lapp/device/add'),
          reason: 'Should use correct endpoint for adding device',
        );
        mockClient.lastBody.expectMeaningful(
          equals({
            'deviceSerial': 'TEST123',
            'validateCode': 'ABC123',
          }),
          reason: 'Should pass correct parameters for device addition',
        );
      });

      test('deleteDevice makes correct API call', () async {
        final expectedResponse = {'success': true};
        mockClient.mockResponse = expectedResponse;

        final result = await deviceService.deleteDevice('TEST123');

        result.expectMeaningful(
          equals(expectedResponse),
          reason: 'Should return success response for device deletion',
        );
        mockClient.lastEndpoint.expectMeaningful(
          equals('/api/lapp/device/delete'),
          reason: 'Should use correct endpoint for deleting device',
        );
        mockClient.lastBody.expectMeaningful(
          equals({'deviceSerial': 'TEST123'}),
          reason: 'Should pass device serial for deletion',
        );
      });

      test('editDeviceName makes correct API call', () async {
        final expectedResponse = {'success': true};
        mockClient.mockResponse = expectedResponse;

        final result = await deviceService.editDeviceName('TEST123', 'New Name');

        result.expectMeaningful(
          equals(expectedResponse),
          reason: 'Should return success response for name edit',
        );
        mockClient.lastEndpoint.expectMeaningful(
          equals('/api/lapp/device/name/update'),
          reason: 'Should use correct endpoint for editing device name',
        );
        mockClient.lastBody.expectMeaningful(
          equals({
            'deviceSerial': 'TEST123',
            'deviceName': 'New Name',
          }),
          reason: 'Should pass correct parameters for name edit',
        );
      });
    });

    group('Device Information', () {
      test('getDeviceList with default parameters', () async {
        final expectedResponse = {'devices': [], 'total': 0};
        mockClient.mockResponse = expectedResponse;

        final result = await deviceService.getDeviceList();

        result.expectMeaningful(
          equals(expectedResponse),
          reason: 'Should return device list response',
        );
        mockClient.lastBody.expectMeaningful(
          equals({
            'pageStart': 0,
            'pageSize': 10,
          }),
          reason: 'Should use default pagination parameters',
        );
      });

      test('getDeviceList with custom parameters', () async {
        final expectedResponse = {'devices': [], 'total': 0};
        mockClient.mockResponse = expectedResponse;

        final result = await deviceService.getDeviceList(
          pageStart: 5,
          pageSize: 20,
        );

        result.expectMeaningful(
          equals(expectedResponse),
          reason: 'Should return device list response',
        );
        mockClient.lastBody.expectMeaningful(
          equals({
            'pageStart': 5,
            'pageSize': 20,
          }),
          reason: 'Should use custom pagination parameters',
        );
      });

      test('getDeviceInfo makes correct API call', () async {
        final expectedResponse = {'device': {'serial': 'TEST123'}};
        mockClient.mockResponse = expectedResponse;

        final result = await deviceService.getDeviceInfo('TEST123');

        result.expectMeaningful(
          equals(expectedResponse),
          reason: 'Should return device info response',
        );
        mockClient.lastEndpoint.expectMeaningful(
          equals('/api/lapp/device/info'),
          reason: 'Should use correct endpoint for device info',
        );
      });
    });

    group('Device Control', () {
      test('capturePicture with default parameters', () async {
        final expectedResponse = {'success': true, 'imageUrl': 'test.jpg'};
        mockClient.mockResponse = expectedResponse;

        final result = await deviceService.capturePicture('TEST123');

        result.expectMeaningful(
          equals(expectedResponse),
          reason: 'Should return capture response',
        );
        mockClient.lastBody.expectMeaningful(
          equals({
            'deviceSerial': 'TEST123',
            'channelNo': 1,
          }),
          reason: 'Should use default channel number',
        );
      });

      test('capturePicture with custom parameters', () async {
        final expectedResponse = {'success': true, 'imageUrl': 'test.jpg'};
        mockClient.mockResponse = expectedResponse;

        final result = await deviceService.capturePicture(
          'TEST123',
          channelNo: 2,
          quality: 1,
        );

        result.expectMeaningful(
          equals(expectedResponse),
          reason: 'Should return capture response',
        );
        mockClient.lastBody.expectMeaningful(
          equals({
            'deviceSerial': 'TEST123',
            'channelNo': 2,
            'quality': 1,
          }),
          reason: 'Should include all custom parameters',
        );
      });

      test('setDefenceMode makes correct API call', () async {
        final expectedResponse = {'success': true};
        mockClient.mockResponse = expectedResponse;

        final result = await deviceService.setDefenceMode('TEST123', 1);

        result.expectMeaningful(
          equals(expectedResponse),
          reason: 'Should return defence mode response',
        );
        mockClient.lastEndpoint.expectMeaningful(
          equals('/api/lapp/device/defence/set'),
          reason: 'Should use correct endpoint for defence mode',
        );
        mockClient.lastBody.expectMeaningful(
          equals({
            'deviceSerial': 'TEST123',
            'isDefence': 1,
          }),
          reason: 'Should pass correct defence parameters',
        );
      });
    });

    group('Device Features', () {
      test('setAudioPromptStatus with enable true', () async {
        final expectedResponse = {'success': true};
        mockClient.mockResponse = expectedResponse;

        final result = await deviceService.setAudioPromptStatus('TEST123', true);

        result.expectMeaningful(
          equals(expectedResponse),
          reason: 'Should return audio prompt response',
        );
        mockClient.lastBody.expectMeaningful(
          equals({
            'deviceSerial': 'TEST123',
            'enable': 1,
          }),
          reason: 'Should convert bool to int for enable parameter',
        );
      });

      test('setAudioPromptStatus with enable false and channel', () async {
        final expectedResponse = {'success': true};
        mockClient.mockResponse = expectedResponse;

        final result = await deviceService.setAudioPromptStatus(
          'TEST123',
          false,
          channelNo: 2,
        );

        mockClient.lastBody.expectMeaningful(
          equals({
            'deviceSerial': 'TEST123',
            'enable': 0,
            'channelNo': 2,
          }),
          reason: 'Should include channel number when provided',
        );
      });

      test('setDeviceTimezone with all parameters', () async {
        final expectedResponse = {'success': true};
        mockClient.mockResponse = expectedResponse;

        final result = await deviceService.setDeviceTimezone(
          'TEST123',
          'America/New_York',
          timeFormat: 1,
          daylightSaving: true,
        );

        mockClient.lastBody.expectMeaningful(
          equals({
            'deviceSerial': 'TEST123',
            'timezone': 'America/New_York',
            'timeFormat': 1,
            'daylightSaving': 1,
          }),
          reason: 'Should include all timezone parameters with correct conversion',
        );
      });
    });

    group('V3 API Methods', () {
      test('setFillLightMode makes correct API call', () async {
        final expectedResponse = {'success': true};
        mockClient.mockResponse = expectedResponse;

        final result = await deviceService.setFillLightMode('TEST123', '1');

        result.expectMeaningful(
          equals(expectedResponse),
          reason: 'Should return fill light mode response',
        );
        mockClient.lastEndpoint.expectMeaningful(
          equals('/api/v3/device/fillLight/mode/set?mode=1'),
          reason: 'Should include mode as query parameter in URL',
        );
      });

      test('playRingtone with default volume', () async {
        final expectedResponse = {'success': true};
        mockClient.mockResponse = expectedResponse;

        final result = await deviceService.playRingtone('TEST123', '200');

        mockClient.lastEndpoint.expectMeaningful(
          equals('/api/v3/device/audition?voiceIndex=200'),
          reason: 'Should include voiceIndex in URL without volume',
        );
      });

      test('playRingtone with custom volume', () async {
        final expectedResponse = {'success': true};
        mockClient.mockResponse = expectedResponse;

        final result = await deviceService.playRingtone(
          'TEST123',
          '201',
          volume: '50',
        );

        mockClient.lastEndpoint.expectMeaningful(
          equals('/api/v3/device/audition?voiceIndex=201&volume=50'),
          reason: 'Should include both voiceIndex and volume in URL',
        );
      });
    });

    group('Error Handling', () {
      test('handles API errors gracefully', () async {
        mockClient.throwError = true;

        expect(
          () => deviceService.getDeviceList(),
          throwsA(isA<Exception>()),
        );
      });

      test('handles network errors gracefully', () async {
        mockClient.throwError = true;

        expect(
          () => deviceService.addDevice('TEST123', 'ABC123'),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}