import 'package:flutter_test/flutter_test.dart';
import 'package:ezviz_flutter/src/cloud/cloud_storage_service.dart';
import '../../../test/test_utils.dart';

void main() {
  group('CloudStorageService', () {
    late MockEzvizClient mockClient;
    late CloudStorageService service;

    setUp(() {
      mockClient = MockEzvizClient();
      service = CloudStorageService(mockClient);
    });

    test('enableCloudStorage supports optional params', () async {
      await service.enableCloudStorage(
        'DEV1',
        'CARDPWD',
        phone: '+123',
        channelNo: 2,
        isImmediately: 1,
      );
      expect(mockClient.lastEndpoint, '/api/lapp/cloud/storage/open');
      expect(
        mockClient.lastBody,
        {
          'deviceSerial': 'DEV1',
          'cardPassword': 'CARDPWD',
          'phone': '+123',
          'channelNo': 2,
          'isImmediately': 1,
        },
      );
    });

    test('getCloudStorageInfo includes optional params', () async {
      await service.getCloudStorageInfo('DEV1', phone: '+123', channelNo: 3);
      expect(
        mockClient.lastEndpoint,
        '/api/lapp/cloud/storage/device/info',
      );
      expect(
        mockClient.lastBody,
        {'deviceSerial': 'DEV1', 'phone': '+123', 'channelNo': 3},
      );
    });
  });
}

