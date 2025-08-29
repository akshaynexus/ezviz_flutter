import 'package:flutter_test/flutter_test.dart';
import 'package:ezviz_flutter/src/auth/auth_service.dart';
// Removed unused import
import '../../../test/test_utils.dart';

void main() {
  group('AuthService', () {
    late MockEzvizClient mockClient;
    late AuthService authService;

    setUp(() {
      mockClient = MockEzvizClient();
      authService = AuthService(mockClient);
    });

    test('creates service with client', () {
      expect(authService, isA<AuthService>());
    });

    test('login makes correct API call', () async {
      final expectedResponse = {'code': '200', 'data': {'token': 'test_token'}};
      mockClient.mockResponse = expectedResponse;

      await authService.login();

      expect(mockClient.lastEndpoint, equals('/api/lapp/token/get'));
      expect(mockClient.lastBody, equals({}));
    });

    test('login handles API errors gracefully', () async {
      mockClient.throwError = true;

      expect(
        () => authService.login(),
        throwsA(isA<Exception>()),
      );
    });
  });
}
