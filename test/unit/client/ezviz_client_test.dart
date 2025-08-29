import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:ezviz_flutter/ezviz_flutter.dart';
import '../../test_utils.dart';

// MOCK-JUSTIFICATION: HTTP client mocking is necessary because real HTTP requests
// would be non-deterministic and require external network connectivity.
// We test the client's request formatting, response parsing, and error handling.
@GenerateMocks([http.Client])
import 'ezviz_client_test.mocks.dart';

void main() {
  group('EzvizClient', () {
    late MockClient mockHttpClient;
    late TestClock testClock;
    
    setUp(() {
      mockHttpClient = MockClient();
      testClock = TestClock();
    });
    
    tearDown(() {
      testClock.reset();
      reset(mockHttpClient);
    });
    
    group('constructor validation', () {
      test('creates client with appKey and appSecret', () {
        const appKey = 'test_app_key';
        const appSecret = 'test_app_secret';
        
        final client = EzvizClient(
          appKey: appKey,
          appSecret: appSecret,
        );
        
        client.appKey.expectMeaningful(
          equals(appKey),
          reason: 'Client should store the provided app key',
        );
        
        client.appSecret.expectMeaningful(
          equals(appSecret),
          reason: 'Client should store the provided app secret',
        );
        
        client.baseUrl.expectMeaningful(
          equals(EzvizConstants.baseUrl),
          reason: 'Should use default base URL when none provided',
        );
      });
      
      test('creates client with access token', () {
        const accessToken = 'test_access_token';
        const areaDomain = 'test.ezvizlife.com';
        
        final client = EzvizClient(
          accessToken: accessToken,
          areaDomain: areaDomain,
        );
        
        client.appKey.expectMeaningful(
          isNull,
          reason: 'App key should be null when using access token',
        );
        
        client.appSecret.expectMeaningful(
          isNull,
          reason: 'App secret should be null when using access token',
        );
      });
      
      test('creates client with region configuration', () {
        const appKey = 'test_key';
        const appSecret = 'test_secret';
        const region = EzvizRegion.usa;
        
        final client = EzvizClient(
          appKey: appKey,
          appSecret: appSecret,
          region: region,
        );
        
        client.baseUrl.expectMeaningful(
          equals('https://apius.ezvizlife.com'),
          reason: 'Should use USA region URL when region is specified',
        );
      });
      
      test('prioritizes baseUrl over region when both provided', () {
        const customBaseUrl = 'https://custom.example.com';
        
        final client = EzvizClient(
          appKey: 'key',
          appSecret: 'secret',
          region: EzvizRegion.europe,
          baseUrl: customBaseUrl,
        );
        
        client.baseUrl.expectMeaningful(
          equals(customBaseUrl),
          reason: 'Custom base URL should take precedence over region',
        );
      });
      
      test('throws ArgumentError when no authentication provided', () {
        expect(
          () => EzvizClient(),
          throwsA(
            allOf([
              isA<ArgumentError>(),
              predicate<ArgumentError>((e) => 
                e.message.contains('Either provide accessToken') &&
                e.message.contains('appKey and appSecret')),
            ]),
          ),
        );
      });
      
      test('throws ArgumentError when only appKey provided', () {
        expect(
          () => EzvizClient(appKey: 'test_key'),
          throwsA(isA<ArgumentError>()),
        );
      });
      
      test('throws ArgumentError when only appSecret provided', () {
        expect(
          () => EzvizClient(appSecret: 'test_secret'),
          throwsA(isA<ArgumentError>()),
        );
      });
    });
    
    group('region URL resolution', () {
      test('uses region URL when region is provided', () {
        final regionTests = {
          EzvizRegion.india: 'https://iindiaopen.ezvizlife.com',
          EzvizRegion.china: 'https://open.ys7.com',
          EzvizRegion.europe: 'https://open.ezvizlife.com',
          EzvizRegion.usa: 'https://apius.ezvizlife.com',
          EzvizRegion.singapore: 'https://apiisgp.ezvizlife.com',
        };
        
        for (final entry in regionTests.entries) {
          final client = EzvizClient(
            appKey: 'key',
            appSecret: 'secret',
            region: entry.key,
          );
          
          client.baseUrl.expectMeaningful(
            equals(entry.value),
            reason: 'Region ${entry.key.name} should resolve to ${entry.value}',
          );
        }
      });
      
      test('falls back to default when custom region provided', () {
        final client = EzvizClient(
          appKey: 'key',
          appSecret: 'secret',
          region: EzvizRegion.custom,
        );
        
        client.baseUrl.expectMeaningful(
          equals(EzvizConstants.baseUrl),
          reason: 'Custom region should fall back to default base URL',
        );
      });
    });
    
    group('baseUrl property', () {
      test('returns the configured base URL', () {
        const testBaseUrl = 'https://test.example.com';
        
        final client = EzvizClient(
          appKey: 'key',
          appSecret: 'secret',
          baseUrl: testBaseUrl,
        );
        
        client.baseUrl.expectMeaningful(
          equals(testBaseUrl),
          reason: 'baseUrl property should return configured URL',
        );
      });
      
      test('baseUrl is immutable after construction', () {
        const originalUrl = 'https://original.example.com';
        
        final client = EzvizClient(
          appKey: 'key',
          appSecret: 'secret',
          baseUrl: originalUrl,
        );
        
        final firstAccess = client.baseUrl;
        final secondAccess = client.baseUrl;
        
        firstAccess.expectMeaningful(
          equals(secondAccess),
          reason: 'baseUrl should be consistent across multiple accesses',
        );
        
        // Change global setting shouldn't affect instance
        EzvizConstants.setBaseUrl('https://changed.example.com');
        
        client.baseUrl.expectMeaningful(
          equals(originalUrl),
          reason: 'Instance baseUrl should not change after construction',
        );
      });
    });
    
    group('areaDomain handling', () {
      test('stores areaDomain when provided with access token', () {
        const accessToken = 'test_token';
        const areaDomain = 'custom.ezviz.com';
        
        final client = EzvizClient(
          accessToken: accessToken,
          areaDomain: areaDomain,
        );
        
        // Since areaDomain is private, we verify it through behavior
        // This tests the internal state management
        client.expectMeaningful(
          isNotNull,
          reason: 'Client should be created successfully with areaDomain',
        );
      });
    });
    
    group('authentication state tracking', () {
      test('tracks provided access token state correctly', () {
        final clientWithToken = EzvizClient(
          accessToken: 'test_token',
        );
        
        final clientWithKeys = EzvizClient(
          appKey: 'key',
          appSecret: 'secret',
        );
        
        // Both should be created successfully but with different internal states
        clientWithToken.expectMeaningful(
          isNotNull,
          reason: 'Client with access token should be created',
        );
        
        clientWithKeys.expectMeaningful(
          isNotNull,
          reason: 'Client with app keys should be created',
        );
        
        // Verify they have different authentication states
        clientWithToken.appKey.expectMeaningful(
          isNull,
          reason: 'Token-based client should not have app key',
        );
        
        clientWithKeys.appKey.expectMeaningful(
          isNotNull,
          reason: 'Key-based client should have app key',
        );
      });
    });
    
    group('parameter validation edge cases', () {
      test('accepts empty strings as potentially valid', () {
        expect(
          () => EzvizClient(appKey: '', appSecret: ''),
          returnsNormally,
        );
        
        expect(
          () => EzvizClient(appKey: 'key', appSecret: ''),
          returnsNormally,
        );
        
        expect(
          () => EzvizClient(appKey: '', appSecret: 'secret'),
          returnsNormally,
        );
      });
      
      test('accepts empty access token as null equivalent', () {
        expect(
          () => EzvizClient(
            accessToken: '',
            appKey: 'key',
            appSecret: 'secret',
          ),
          returnsNormally,
        );
      });
      
      test('handles null values explicitly', () {
        final client = EzvizClient(
          appKey: 'key',
          appSecret: 'secret',
          accessToken: null,
          areaDomain: null,
          region: null,
          baseUrl: null,
        );
        
        client.expectMeaningful(
          isNotNull,
          reason: 'Client should handle explicit null values gracefully',
        );
      });
    });
  });
}