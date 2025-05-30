import 'package:ezviz_flutter/ezviz_flutter.dart';
import 'package:test/test.dart';

void main() {
  group('EzvizClient Tests', () {
    test('EzvizClient can be instantiated', () {
      final client = EzvizClient(
        appKey: 'testAppKey',
        appSecret: 'testAppSecret',
      );
      expect(client, isNotNull);
      expect(client.appKey, 'testAppKey');
    });

    // Add more tests for services and functionality here
    // For example, test if AuthService can be created:
    // test('AuthService can be instantiated', () {
    //   final client = EzvizClient(appKey: 'testAppKey', appSecret: 'testAppSecret');
    //   final authService = AuthService(client);
    //   expect(authService, isNotNull);
    // });
  });
}
