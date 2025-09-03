import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ezviz_flutter/ezviz_auth_manager.dart';
import 'package:ezviz_flutter/ezviz_methods.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel(
    EzvizChannelMethods.methodChannelName,
  );

  Future<T> withMockHandler<T>(
    Future<T> Function() body, {
    dynamic Function(MethodCall call)? onCall,
  }) async {
    final messenger = TestDefaultBinaryMessengerBinding
        .instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(channel, (methodCall) async {
      if (onCall != null) {
        return onCall(methodCall);
      }
      return null;
    });
    try {
      return await body();
    } finally {
      messenger.setMockMethodCallHandler(channel, null);
    }
  }

  group('EzvizAuthManager channel methods', () {
    test('openLoginPage success and with areaId', () async {
      final result = await withMockHandler<bool>(
        () => EzvizAuthManager.openLoginPage(areaId: 'EU'),
        onCall: (call) {
          expect(call.method, EzvizChannelMethods.openLoginPage);
          expect(call.arguments, {'areaId': 'EU'});
          return true;
        },
      );
      expect(result, isTrue);
    });

    test('openLoginPage handles channel error', () async {
      final result = await withMockHandler<bool>(
        () => EzvizAuthManager.openLoginPage(),
        onCall: (_) => Future<bool>.error(PlatformException(code: 'ERR')),
      );
      expect(result, isFalse);
    });

    test('logout success', () async {
      final result = await withMockHandler<bool>(
        () => EzvizAuthManager.logout(),
        onCall: (call) {
          expect(call.method, EzvizChannelMethods.logout);
          return true;
        },
      );
      expect(result, isTrue);
    });

    test('logout handles error', () async {
      final result = await withMockHandler<bool>(
        () => EzvizAuthManager.logout(),
        onCall: (_) => Future<bool>.error(PlatformException(code: 'ERR')),
      );
      expect(result, isFalse);
    });

    test('getAccessToken success mapping', () async {
      final token = await withMockHandler<EzvizAccessToken?>(
        () => EzvizAuthManager.getAccessToken(),
        onCall: (call) {
          expect(call.method, EzvizChannelMethods.getAccessToken);
          return {
            'accessToken': 'abc',
            'expireTime': DateTime.now().millisecondsSinceEpoch + 60000,
          };
        },
      );
      expect(token, isNotNull);
      expect(token!.accessToken, 'abc');
      expect(token.isExpired, isFalse);
      expect(token.remainingMinutes, greaterThanOrEqualTo(1));
    });

    test('getAccessToken handles null and error', () async {
      final nullResult = await withMockHandler<EzvizAccessToken?>(
        () => EzvizAuthManager.getAccessToken(),
        onCall: (_) => null,
      );
      expect(nullResult, isNull);

      final errorResult = await withMockHandler<EzvizAccessToken?>(
        () => EzvizAuthManager.getAccessToken(),
        onCall: (_) => Future<EzvizAccessToken>.error(PlatformException(code: 'ERR')),
      );
      expect(errorResult, isNull);
    });

    test('getAreaList success mapping and error path', () async {
      final areas = await withMockHandler<List<EzvizAreaInfo>>(
        () => EzvizAuthManager.getAreaList(),
        onCall: (call) {
          expect(call.method, EzvizChannelMethods.getAreaList);
          return [
            {'areaId': 'US', 'areaName': 'United States'},
            {'areaId': 'EU', 'areaName': 'Europe'},
          ];
        },
      );
      expect(areas.map((e) => e.areaId).toList(), ['US', 'EU']);

      final empty = await withMockHandler<List<EzvizAreaInfo>>(
        () => EzvizAuthManager.getAreaList(),
        onCall: (_) => Future<List<dynamic>>.error(PlatformException(code: 'ERR')),
      );
      expect(empty, isEmpty);
    });

    test('setServerUrl success and error', () async {
      final ok = await withMockHandler<bool>(
        () => EzvizAuthManager.setServerUrl(apiUrl: 'https://api', authUrl: 'https://auth'),
        onCall: (call) {
          expect(call.method, EzvizChannelMethods.setServerUrl);
          expect(call.arguments, {'apiUrl': 'https://api', 'authUrl': 'https://auth'});
          return true;
        },
      );
      expect(ok, isTrue);

      final fail = await withMockHandler<bool>(
        () => EzvizAuthManager.setServerUrl(apiUrl: 'a', authUrl: 'b'),
        onCall: (_) => Future<bool>.error(PlatformException(code: 'ERR')),
      );
      expect(fail, isFalse);
    });
  });

  group('EzvizAccessToken value semantics', () {
    test('isExpired and remainingMinutes compute correctly', () {
      final now = DateTime.now().millisecondsSinceEpoch;
      final expired = EzvizAccessToken(accessToken: 'x', expireTime: now - 1);
      final fresh = EzvizAccessToken(accessToken: 'y', expireTime: now + 5 * 60 * 1000);

      expect(expired.isExpired, isTrue);
      expect(expired.remainingMinutes, 0);
      expect(fresh.isExpired, isFalse);
      expect(fresh.remainingMinutes, inInclusiveRange(5 - 1, 5 + 1));
    });
  });
}

