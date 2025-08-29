import 'package:flutter_test/flutter_test.dart';
import 'package:ezviz_flutter/src/ptz/ptz_service.dart';
import 'package:ezviz_flutter/src/ezviz_client.dart';
import '../../../test/test_utils.dart';

void main() {
  group('PtzService', () {
    late MockEzvizClient mockClient;
    late PtzService ptzService;

    setUp(() {
      mockClient = MockEzvizClient();
      ptzService = PtzService(mockClient);
    });

    test('creates service with client', () {
      expect(ptzService, isA<PtzService>());
    });

    group('PTZ Enums', () {
      test('PtzCommand enum has correct values', () {
        PtzCommand.up.index.expectMeaningful(
          equals(0),
          reason: 'Up command should have index 0',
        );
        PtzCommand.down.index.expectMeaningful(
          equals(1),
          reason: 'Down command should have index 1',
        );
        PtzCommand.left.index.expectMeaningful(
          equals(2),
          reason: 'Left command should have index 2',
        );
        PtzCommand.right.index.expectMeaningful(
          equals(3),
          reason: 'Right command should have index 3',
        );
        PtzCommand.zoomIn.index.expectMeaningful(
          equals(8),
          reason: 'ZoomIn command should have index 8',
        );
        PtzCommand.zoomOut.index.expectMeaningful(
          equals(9),
          reason: 'ZoomOut command should have index 9',
        );
      });

      test('PtzSpeed enum has correct values', () {
        PtzSpeed.slow.index.expectMeaningful(
          equals(0),
          reason: 'Slow speed should have index 0',
        );
        PtzSpeed.medium.index.expectMeaningful(
          equals(1),
          reason: 'Medium speed should have index 1',
        );
        PtzSpeed.fast.index.expectMeaningful(
          equals(2),
          reason: 'Fast speed should have index 2',
        );
      });

      test('PtzMirrorCommand enum has correct values', () {
        PtzMirrorCommand.upDown.index.expectMeaningful(
          equals(0),
          reason: 'UpDown mirror should have index 0',
        );
        PtzMirrorCommand.leftRight.index.expectMeaningful(
          equals(1),
          reason: 'LeftRight mirror should have index 1',
        );
        PtzMirrorCommand.center.index.expectMeaningful(
          equals(2),
          reason: 'Center mirror should have index 2',
        );
      });
    });

    group('startPtz', () {
      test('makes correct API call with up direction', () async {
        final expectedResponse = {'success': true};
        mockClient.mockResponse = expectedResponse;

        final result = await ptzService.startPtz(
          'TEST123',
          1,
          direction: PtzCommand.up,
          speed: PtzSpeed.medium,
        );

        result.expectMeaningful(
          equals(expectedResponse),
          reason: 'Should return PTZ start response',
        );
        mockClient.lastEndpoint.expectMeaningful(
          equals('/api/lapp/device/ptz/start'),
          reason: 'Should use correct endpoint for PTZ start',
        );
        mockClient.lastBody.expectMeaningful(
          equals({
            'deviceSerial': 'TEST123',
            'channelNo': 1,
            'direction': 0, // PtzCommand.up.index
            'speed': 1, // PtzSpeed.medium.index
          }),
          reason: 'Should include all PTZ start parameters with enum indices',
        );
      });

      test('works with all direction commands', () async {
        final expectedResponse = {'success': true};
        mockClient.mockResponse = expectedResponse;

        // Test diagonal movement
        await ptzService.startPtz(
          'TEST123',
          2,
          direction: PtzCommand.upRight,
          speed: PtzSpeed.fast,
        );

        mockClient.lastBody.expectMeaningful(
          equals({
            'deviceSerial': 'TEST123',
            'channelNo': 2,
            'direction': 6, // PtzCommand.upRight.index
            'speed': 2, // PtzSpeed.fast.index
          }),
          reason: 'Should handle diagonal movements correctly',
        );
      });

      test('works with zoom commands', () async {
        final expectedResponse = {'success': true};
        mockClient.mockResponse = expectedResponse;

        await ptzService.startPtz(
          'TEST123',
          1,
          direction: PtzCommand.zoomIn,
          speed: PtzSpeed.slow,
        );

        mockClient.lastBody.expectMeaningful(
          containsPair('direction', 8), // PtzCommand.zoomIn.index
          reason: 'Should handle zoom commands correctly',
        );
      });
    });

    group('stopPtz', () {
      test('makes correct API call with direction', () async {
        final expectedResponse = {'success': true};
        mockClient.mockResponse = expectedResponse;

        final result = await ptzService.stopPtz(
          'TEST123',
          1,
          direction: PtzCommand.up,
        );

        result.expectMeaningful(
          equals(expectedResponse),
          reason: 'Should return PTZ stop response',
        );
        mockClient.lastEndpoint.expectMeaningful(
          equals('/api/lapp/device/ptz/stop'),
          reason: 'Should use correct endpoint for PTZ stop',
        );
        mockClient.lastBody.expectMeaningful(
          equals({
            'deviceSerial': 'TEST123',
            'channelNo': 1,
            'direction': 0, // PtzCommand.up.index
          }),
          reason: 'Should include device, channel, and direction for stop',
        );
      });

      test('throws error when direction is not provided', () async {
        expect(
          () => ptzService.stopPtz('TEST123', 1),
          throwsA(isA<ArgumentError>()),
        );
      });

      test('error message explains direction requirement', () async {
        try {
          await ptzService.stopPtz('TEST123', 1);
        } catch (e) {
          e.toString().expectMeaningful(
            contains('Direction must be provided'),
            reason: 'Error should explain direction requirement',
          );
        }
      });
    });

    group('mirrorFlip', () {
      test('makes correct API call', () async {
        final expectedResponse = {'success': true};
        mockClient.mockResponse = expectedResponse;

        final result = await ptzService.mirrorFlip(
          'TEST123',
          1,
          command: PtzMirrorCommand.upDown,
        );

        result.expectMeaningful(
          equals(expectedResponse),
          reason: 'Should return mirror flip response',
        );
        mockClient.lastEndpoint.expectMeaningful(
          equals('/api/lapp/device/ptz/mirror'),
          reason: 'Should use correct endpoint for mirror flip',
        );
        mockClient.lastBody.expectMeaningful(
          equals({
            'deviceSerial': 'TEST123',
            'channelNo': 1,
            'command': 0, // PtzMirrorCommand.upDown.index
          }),
          reason: 'Should include correct mirror command parameters',
        );
      });

      test('works with all mirror commands', () async {
        final expectedResponse = {'success': true};
        mockClient.mockResponse = expectedResponse;

        // Test left-right mirror
        await ptzService.mirrorFlip(
          'TEST123',
          1,
          command: PtzMirrorCommand.leftRight,
        );

        mockClient.lastBody.expectMeaningful(
          containsPair('command', 1), // PtzMirrorCommand.leftRight.index
          reason: 'Should handle left-right mirror correctly',
        );

        // Test center command
        await ptzService.mirrorFlip(
          'TEST123',
          1,
          command: PtzMirrorCommand.center,
        );

        mockClient.lastBody.expectMeaningful(
          containsPair('command', 2), // PtzMirrorCommand.center.index
          reason: 'Should handle center command correctly',
        );
      });
    });

    group('Preset Management', () {
      test('addPreset makes correct API call', () async {
        final expectedResponse = {'success': true, 'presetId': 1};
        mockClient.mockResponse = expectedResponse;

        final result = await ptzService.addPreset('TEST123', 1);

        result.expectMeaningful(
          equals(expectedResponse),
          reason: 'Should return add preset response',
        );
        mockClient.lastEndpoint.expectMeaningful(
          equals('/api/lapp/device/preset/add'),
          reason: 'Should use correct endpoint for adding preset',
        );
        mockClient.lastBody.expectMeaningful(
          equals({
            'deviceSerial': 'TEST123',
            'channelNo': 1,
          }),
          reason: 'Should include device and channel for preset addition',
        );
      });

      test('callPreset makes correct API call', () async {
        final expectedResponse = {'success': true};
        mockClient.mockResponse = expectedResponse;

        final result = await ptzService.callPreset(
          'TEST123',
          1,
          presetIndex: 5,
        );

        result.expectMeaningful(
          equals(expectedResponse),
          reason: 'Should return call preset response',
        );
        mockClient.lastEndpoint.expectMeaningful(
          equals('/api/lapp/device/preset/move'),
          reason: 'Should use correct endpoint for calling preset',
        );
        mockClient.lastBody.expectMeaningful(
          equals({
            'deviceSerial': 'TEST123',
            'channelNo': 1,
            'index': 5,
          }),
          reason: 'Should include preset index for calling preset',
        );
      });

      test('clearPreset makes correct API call', () async {
        final expectedResponse = {'success': true};
        mockClient.mockResponse = expectedResponse;

        final result = await ptzService.clearPreset(
          'TEST123',
          1,
          presetIndex: 3,
        );

        result.expectMeaningful(
          equals(expectedResponse),
          reason: 'Should return clear preset response',
        );
        mockClient.lastEndpoint.expectMeaningful(
          equals('/api/lapp/device/preset/clear'),
          reason: 'Should use correct endpoint for clearing preset',
        );
        mockClient.lastBody.expectMeaningful(
          equals({
            'deviceSerial': 'TEST123',
            'channelNo': 1,
            'index': 3,
          }),
          reason: 'Should include preset index for clearing preset',
        );
      });
    });

    group('Error Handling', () {
      test('handles API errors gracefully', () async {
        mockClient.throwError = true;

        expect(
          () => ptzService.startPtz(
            'TEST123',
            1,
            direction: PtzCommand.up,
            speed: PtzSpeed.medium,
          ),
          throwsA(isA<Exception>()),
        );
      });

      test('handles network errors gracefully', () async {
        mockClient.throwError = true;

        expect(
          () => ptzService.addPreset('TEST123', 1),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}