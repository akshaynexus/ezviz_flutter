import 'package:flutter_test/flutter_test.dart';
import 'package:ezviz_flutter/src/detector/detector_service.dart';
import '../../../test/test_utils.dart';

void main() {
  group('DetectorService', () {
    late MockEzvizClient mockClient;
    late DetectorService service;

    setUp(() {
      mockClient = MockEzvizClient();
      service = DetectorService(mockClient);
    });

    test('getDetectorList calls correct endpoint', () async {
      await service.getDetectorList('HUB1');
      expect(mockClient.lastEndpoint, '/api/lapp/detector/list');
      expect(mockClient.lastBody, {'deviceSerial': 'HUB1'});
    });

    test('setDetectorStatus builds correct body', () async {
      await service.setDetectorStatus('HUB1', 'DET1', DetectorSafeMode.away, true);
      expect(mockClient.lastEndpoint, '/api/lapp/detector/status/set');
      expect(
        mockClient.lastBody,
        {
          'deviceSerial': 'HUB1',
          'detectorSerial': 'DET1',
          'safeMode': DetectorSafeMode.away.index,
          'enable': 1,
        },
      );
    });

    test('deleteDetector calls correct endpoint', () async {
      await service.deleteDetector('HUB1', 'DET1');
      expect(mockClient.lastEndpoint, '/api/lapp/detector/delete');
      expect(mockClient.lastBody, {'deviceSerial': 'HUB1', 'detectorSerial': 'DET1'});
    });

    test('getBindableIpcList calls correct endpoint', () async {
      await service.getBindableIpcList('HUB1');
      expect(mockClient.lastEndpoint, '/api/lapp/detector/ipc/list/bindable');
      expect(mockClient.lastBody, {'deviceSerial': 'HUB1'});
    });

    test('getLinkedIpcList calls correct endpoint', () async {
      await service.getLinkedIpcList('HUB1', 'DET1');
      expect(mockClient.lastEndpoint, '/api/lapp/detector/ipc/list/bind');
      expect(mockClient.lastBody, {'deviceSerial': 'HUB1', 'detectorSerial': 'DET1'});
    });

    test('setIpcLinkage bind/unbind toggles operation', () async {
      await service.setIpcLinkage('HUB1', 'DET1', 'IPC1', true);
      expect(mockClient.lastEndpoint, '/api/lapp/detector/ipc/relation/set');
      expect(
        mockClient.lastBody,
        {
          'deviceSerial': 'HUB1',
          'detectorSerial': 'DET1',
          'ipcSerial': 'IPC1',
          'operation': 1,
        },
      );

      await service.setIpcLinkage('HUB1', 'DET1', 'IPC1', false);
      expect(mockClient.lastBody, isNotNull);
      expect(mockClient.lastBody!['operation'], 0);
    });

    test('editDetectorName calls correct endpoint', () async {
      await service.editDetectorName('HUB1', 'DET1', 'Front PIR');
      expect(mockClient.lastEndpoint, '/api/lapp/detector/name/change');
      expect(
        mockClient.lastBody,
        {'deviceSerial': 'HUB1', 'detectorSerial': 'DET1', 'newName': 'Front PIR'},
      );
    });

    test('clearDeviceAlarms calls correct endpoint', () async {
      await service.clearDeviceAlarms('HUB1');
      expect(mockClient.lastEndpoint, '/api/lapp/detector/cancelAlarm');
      expect(mockClient.lastBody, {'deviceSerial': 'HUB1'});
    });

    test('addDetector calls correct endpoint/body', () async {
      await service.addDetector('HUB1', 'DET2', 'PIR', 'ABCDEF');
      expect(mockClient.lastEndpoint, '/api/lapp/detector/add');
      expect(
        mockClient.lastBody,
        {
          'deviceSerial': 'HUB1',
          'detectorSerial': 'DET2',
          'detectorType': 'PIR',
          'detectorCode': 'ABCDEF',
        },
      );
    });
  });
}
