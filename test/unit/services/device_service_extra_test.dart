import 'package:flutter_test/flutter_test.dart';
import 'package:ezviz_flutter/src/device/device_service.dart';
import '../../test_utils.dart';

void main() {
  group('DeviceService extra endpoints', () {
    late MockEzvizClient mockClient;
    late DeviceService service;

    setUp(() {
      mockClient = MockEzvizClient();
      service = DeviceService(mockClient);
    });

    test('getTimezoneList with language', () async {
      mockClient.mockResponse = {'timezones': []};
      await service.getTimezoneList(language: 'en_US');
      expect(mockClient.lastBody, containsPair('language', 'en_US'));
    });

    test('setDeviceLanguage', () async {
      mockClient.mockResponse = {'success': true};
      await service.setDeviceLanguage('D1', 'ENGLISH');
      expect(mockClient.lastEndpoint, '/api/lapp/device/language/set');
      expect(mockClient.lastBody, containsPair('language', 'ENGLISH'));
    });

    test('setInfraredStatus and getInfraredStatus', () async {
      mockClient.mockResponse = {'success': true};
      await service.setInfraredStatus('D1', true, channelNo: 1);
      expect(mockClient.lastEndpoint, '/api/lapp/device/infrared/switch/set');
      expect(mockClient.lastBody, containsPair('enable', 1));

      await service.getInfraredStatus('D1', channelNo: 2);
      expect(mockClient.lastEndpoint, '/api/lapp/device/infrared/switch/get');
      expect(mockClient.lastBody, containsPair('channelNo', 2));
    });

    test('getChimeType and setChimeType', () async {
      mockClient.mockResponse = {'success': true};
      await service.getChimeType('D1', channelNo: 1);
      expect(mockClient.lastEndpoint, '/api/lapp/device/chime/get');

      await service.setChimeType('D1', 2, 5, channelNo: 1);
      expect(mockClient.lastEndpoint, '/api/lapp/device/chime/set');
      expect(mockClient.lastBody, containsPair('type', 2));
      expect(mockClient.lastBody, containsPair('duration', 5));
    });

    test('getDeviceCapability optional channelNo', () async {
      mockClient.mockResponse = {'data': {}};
      await service.getDeviceCapability('D1', channelNo: '1');
      expect(mockClient.lastEndpoint, '/api/lapp/device/capacity');
      expect(mockClient.lastBody, containsPair('channelNo', '1'));
    });
  });
}

