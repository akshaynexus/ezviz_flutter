import 'package:flutter_test/flutter_test.dart';
import 'package:ezviz_flutter/src/live/live_service.dart';
import 'package:ezviz_flutter/src/ezviz_client.dart';
import '../../../test/test_utils.dart';

void main() {
  group('LiveService', () {
    late MockEzvizClient mockClient;
    late LiveService liveService;

    setUp(() {
      mockClient = MockEzvizClient();
      liveService = LiveService(mockClient);
    });

    test('creates service with client', () {
      expect(liveService, isA<LiveService>());
    });

    group('getPlayAddress', () {
      test('with minimal parameters', () async {
        final expectedResponse = {'url': 'rtmp://test.com/live'};
        mockClient.mockResponse = expectedResponse;

        final result = await liveService.getPlayAddress('TEST123');

        result.expectMeaningful(
          equals(expectedResponse),
          reason: 'Should return play address response',
        );
        mockClient.lastEndpoint.expectMeaningful(
          equals('/api/lapp/live/address/get'),
          reason: 'Should use correct endpoint for live address',
        );
        mockClient.lastBody.expectMeaningful(
          equals({'deviceSerial': 'TEST123'}),
          reason: 'Should only include device serial for minimal call',
        );
      });

      test('with all parameters', () async {
        final expectedResponse = {'url': 'rtmp://test.com/live'};
        mockClient.mockResponse = expectedResponse;

        final result = await liveService.getPlayAddress(
          'TEST123',
          channelNo: 1,
          protocol: 0,
          code: 'ABC123',
          expireTime: 3600,
          type: '0',
          quality: 1,
          startTime: '2023-01-01 00:00:00',
          stopTime: '2023-01-01 23:59:59',
          debug: false,
        );

        result.expectMeaningful(
          equals(expectedResponse),
          reason: 'Should return play address response',
        );
        mockClient.lastBody.expectMeaningful(
          equals({
            'deviceSerial': 'TEST123',
            'channelNo': 1,
            'protocol': 0,
            'code': 'ABC123',
            'expireTime': 3600,
            'type': '0',
            'quality': 1,
            'startTime': '2023-01-01 00:00:00',
            'stopTime': '2023-01-01 23:59:59',
          }),
          reason: 'Should include all provided parameters',
        );
      });

      test('with password parameter (takes precedence over code)', () async {
        final expectedResponse = {'url': 'rtmp://test.com/live'};
        mockClient.mockResponse = expectedResponse;

        final result = await liveService.getPlayAddress(
          'TEST123',
          code: 'CODE123',
          password: 'PASS456',
        );

        mockClient.lastBody.expectMeaningful(
          equals({
            'deviceSerial': 'TEST123',
            'code': 'PASS456',
          }),
          reason: 'Password should take precedence over code parameter',
        );
      });

      test('with debug enabled', () async {
        final expectedResponse = {'url': 'rtmp://test.com/live'};
        mockClient.mockResponse = expectedResponse;

        // Debug output is printed but doesn't affect the response
        final result = await liveService.getPlayAddress(
          'TEST123',
          code: 'ABC123',
          debug: true,
        );

        result.expectMeaningful(
          equals(expectedResponse),
          reason: 'Debug mode should not affect response',
        );
        mockClient.lastBody.expectMeaningful(
          contains('deviceSerial'),
          reason: 'Should still include device serial with debug enabled',
        );
      });
    });

    group('invalidatePlayAddress', () {
      test('with minimal parameters', () async {
        final expectedResponse = {'success': true};
        mockClient.mockResponse = expectedResponse;

        final result = await liveService.invalidatePlayAddress('TEST123');

        result.expectMeaningful(
          equals(expectedResponse),
          reason: 'Should return invalidate response',
        );
        mockClient.lastEndpoint.expectMeaningful(
          equals('/api/lapp/live/address/disable'),
          reason: 'Should use correct endpoint for invalidating address',
        );
        mockClient.lastBody.expectMeaningful(
          equals({'deviceSerial': 'TEST123'}),
          reason: 'Should only include device serial for minimal call',
        );
      });

      test('with all parameters', () async {
        final expectedResponse = {'success': true};
        mockClient.mockResponse = expectedResponse;

        final result = await liveService.invalidatePlayAddress(
          'TEST123',
          channelNo: 2,
          urlId: 'url123',
        );

        mockClient.lastBody.expectMeaningful(
          equals({
            'deviceSerial': 'TEST123',
            'channelNo': 2,
            'urlId': 'url123',
          }),
          reason: 'Should include all provided parameters',
        );
      });
    });

    group('getPlayAddressWithPassword', () {
      test('succeeds without password first', () async {
        final expectedResponse = {'url': 'rtmp://test.com/live'};
        mockClient.mockResponse = expectedResponse;

        final result = await liveService.getPlayAddressWithPassword(
          'TEST123',
          'password123',
        );

        result.expectMeaningful(
          equals(expectedResponse),
          reason: 'Should return response from first attempt',
        );
        // First call should be without password
        mockClient.lastBody.expectMeaningful(
          equals({
            'deviceSerial': 'TEST123',
            'channelNo': 1,
            'protocol': 1,
            'quality': 1,
          }),
          reason: 'First attempt should not include password',
        );
      });

      test('retries with password on encryption error', () async {
        // Set up mock to throw encryption error first, then succeed
        mockClient.callCount = 0;
        mockClient.throwErrorOnce = true;
        mockClient.errorMessage = 'Error 60019: parameter code is empty';
        
        final expectedResponse = {'url': 'rtmp://test.com/live'};
        mockClient.mockResponse = expectedResponse;

        final result = await liveService.getPlayAddressWithPassword(
          'TEST123',
          'password123',
        );

        result.expectMeaningful(
          equals(expectedResponse),
          reason: 'Should return response from retry with password',
        );
        mockClient.callCount.expectMeaningful(
          equals(2),
          reason: 'Should make two API calls (without and with password)',
        );
      });

      test('rethrows non-encryption errors', () async {
        mockClient.throwError = true;
        mockClient.errorMessage = 'Network error';

        expect(
          () => liveService.getPlayAddressWithPassword('TEST123', 'password123'),
          throwsA(predicate((e) => e.toString().contains('Network error'))),
        );
      });

      test('uses custom parameters', () async {
        final expectedResponse = {'url': 'rtmp://test.com/live'};
        mockClient.mockResponse = expectedResponse;

        final result = await liveService.getPlayAddressWithPassword(
          'TEST123',
          'password123',
          channelNo: 2,
          protocol: 2,
          quality: 0,
          debug: false,
        );

        mockClient.lastBody.expectMeaningful(
          containsPair('channelNo', 2),
          reason: 'Should use custom channel number',
        );
        mockClient.lastBody.expectMeaningful(
          containsPair('protocol', 2),
          reason: 'Should use custom protocol',
        );
        mockClient.lastBody.expectMeaningful(
          containsPair('quality', 0),
          reason: 'Should use custom quality',
        );
      });
    });

    group('Error Handling', () {
      test('handles API errors gracefully', () async {
        mockClient.throwError = true;

        expect(
          () => liveService.getPlayAddress('TEST123'),
          throwsA(isA<Exception>()),
        );
      });

      test('handles network errors gracefully', () async {
        mockClient.throwError = true;

        expect(
          () => liveService.invalidatePlayAddress('TEST123'),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}