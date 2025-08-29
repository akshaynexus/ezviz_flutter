import 'package:flutter_test/flutter_test.dart';
import 'package:ezviz_flutter/ezviz_flutter.dart';
import '../../test_utils.dart';

void main() {
  group('EzvizException', () {
    test('creates exception with message only', () {
      const message = 'Test error occurred';
      final exception = EzvizException(message);
      
      exception.message.expectMeaningful(
        equals(message),
        reason: 'Exception should store the provided message',
      );
      
      exception.code.expectMeaningful(
        isNull,
        reason: 'Code should be null when not provided',
      );
    });
    
    test('creates exception with message and code', () {
      const message = 'Authentication failed';
      const code = '10001';
      final exception = EzvizException(message, code: code);
      
      exception.message.expectMeaningful(
        equals(message),
        reason: 'Exception should store the provided message',
      );
      
      exception.code.expectMeaningful(
        equals(code),
        reason: 'Exception should store the provided error code',
      );
    });
    
    test('toString returns formatted error message without code', () {
      const message = 'Network error';
      final exception = EzvizException(message);
      
      exception.toString().expectMeaningful(
        equals('EzvizException: $message (code: null)'),
        reason: 'toString should format message and null code correctly',
      );
    });
    
    test('toString returns formatted error message with code', () {
      const message = 'Token expired';
      const code = '10002';
      final exception = EzvizException(message, code: code);
      
      exception.toString().expectMeaningful(
        equals('EzvizException: $message (code: $code)'),
        reason: 'toString should format message and code correctly',
      );
    });
    
    test('implements Exception interface', () {
      final exception = EzvizException('test');
      
      exception.expectMeaningful(
        isA<Exception>(),
        reason: 'EzvizException should implement Exception interface',
      );
    });
    
    test('can be thrown and caught as Exception', () {
      const message = 'Test exception';
      
      expect(
        () => throw EzvizException(message),
        throwsA(
          allOf([
            isA<Exception>(),
            isA<EzvizException>(),
            predicate<EzvizException>((e) => e.message == message),
          ]),
        ),
      );
    });
    
    test('handles empty and special character messages', () {
      final testMessages = [
        '',
        '   ',
        'Message with "quotes"',
        'Message with \n newlines \r\n',
        'Message with unicode: 测试 🔥',
      ];
      
      for (final message in testMessages) {
        final exception = EzvizException(message);
        
        exception.message.expectMeaningful(
          equals(message),
          reason: 'Exception should preserve exact message: "$message"',
        );
        
        exception.toString().expectMeaningful(
          contains(message),
          reason: 'toString should contain the message: "$message"',
        );
      }
    });
  });
  
  group('EzvizAuthException', () {
    test('extends EzvizException', () {
      final authException = EzvizAuthException('Auth failed');
      
      authException.expectMeaningful(
        isA<EzvizException>(),
        reason: 'EzvizAuthException should extend EzvizException',
      );
      
      authException.expectMeaningful(
        isA<EzvizAuthException>(),
        reason: 'Should maintain its specific type',
      );
    });
    
    test('creates auth exception with message only', () {
      const message = 'Login failed';
      final exception = EzvizAuthException(message);
      
      exception.message.expectMeaningful(
        equals(message),
        reason: 'Auth exception should store the provided message',
      );
      
      exception.code.expectMeaningful(
        isNull,
        reason: 'Code should be null when not provided',
      );
    });
    
    test('creates auth exception with message and code', () {
      const message = 'Invalid credentials';
      const code = 'AUTH_001';
      final exception = EzvizAuthException(message, code: code);
      
      exception.message.expectMeaningful(
        equals(message),
        reason: 'Auth exception should store the provided message',
      );
      
      exception.code.expectMeaningful(
        equals(code),
        reason: 'Auth exception should store the provided error code',
      );
    });
    
    test('can be caught specifically as auth exception', () {
      const message = 'Token invalid';
      
      expect(
        () => throw EzvizAuthException(message),
        throwsA(
          allOf([
            isA<EzvizException>(),
            isA<EzvizAuthException>(),
            predicate<EzvizAuthException>((e) => e.message == message),
          ]),
        ),
      );
    });
    
    test('toString uses base class formatting', () {
      const message = 'Access denied';
      const code = '403';
      final exception = EzvizAuthException(message, code: code);
      
      exception.toString().expectMeaningful(
        equals('EzvizException: $message (code: $code)'),
        reason: 'Auth exception should use base class toString format',
      );
    });
  });
  
  group('EzvizApiException', () {
    test('extends EzvizException', () {
      final apiException = EzvizApiException('API error');
      
      apiException.expectMeaningful(
        isA<EzvizException>(),
        reason: 'EzvizApiException should extend EzvizException',
      );
      
      apiException.expectMeaningful(
        isA<EzvizApiException>(),
        reason: 'Should maintain its specific type',
      );
    });
    
    test('creates API exception with message only', () {
      const message = 'Server error';
      final exception = EzvizApiException(message);
      
      exception.message.expectMeaningful(
        equals(message),
        reason: 'API exception should store the provided message',
      );
      
      exception.code.expectMeaningful(
        isNull,
        reason: 'Code should be null when not provided',
      );
    });
    
    test('creates API exception with message and code', () {
      const message = 'Bad request';
      const code = '400';
      final exception = EzvizApiException(message, code: code);
      
      exception.message.expectMeaningful(
        equals(message),
        reason: 'API exception should store the provided message',
      );
      
      exception.code.expectMeaningful(
        equals(code),
        reason: 'API exception should store the provided error code',
      );
    });
    
    test('can be caught specifically as API exception', () {
      const message = 'Service unavailable';
      
      expect(
        () => throw EzvizApiException(message),
        throwsA(
          allOf([
            isA<EzvizException>(),
            isA<EzvizApiException>(),
            predicate<EzvizApiException>((e) => e.message == message),
          ]),
        ),
      );
    });
    
    test('toString uses base class formatting', () {
      const message = 'Rate limit exceeded';
      const code = '429';
      final exception = EzvizApiException(message, code: code);
      
      exception.toString().expectMeaningful(
        equals('EzvizException: $message (code: $code)'),
        reason: 'API exception should use base class toString format',
      );
    });
  });
  
  group('Exception type differentiation', () {
    test('different exception types can be distinguished', () {
      final baseException = EzvizException('base');
      final authException = EzvizAuthException('auth');
      final apiException = EzvizApiException('api');
      
      baseException.expectMeaningful(
        isNot(isA<EzvizAuthException>()),
        reason: 'Base exception should not be auth exception',
      );
      
      baseException.expectMeaningful(
        isNot(isA<EzvizApiException>()),
        reason: 'Base exception should not be API exception',
      );
      
      authException.expectMeaningful(
        isNot(isA<EzvizApiException>()),
        reason: 'Auth exception should not be API exception',
      );
      
      apiException.expectMeaningful(
        isNot(isA<EzvizAuthException>()),
        reason: 'API exception should not be auth exception',
      );
    });
    
    test('can catch specific exception types in hierarchy', () {
      void throwAuthError() => throw EzvizAuthException('auth error');
      void throwApiError() => throw EzvizApiException('api error');
      void throwBaseError() => throw EzvizException('base error');
      
      // Catch specific auth exception
      expect(() => throwAuthError(), throwsA(isA<EzvizAuthException>()));
      
      // Catch specific API exception
      expect(() => throwApiError(), throwsA(isA<EzvizApiException>()));
      
      // Catch base exception
      expect(() => throwBaseError(), throwsA(isA<EzvizException>()));
      
      // All can be caught as base Exception
      expect(() => throwAuthError(), throwsA(isA<EzvizException>()));
      expect(() => throwApiError(), throwsA(isA<EzvizException>()));
      expect(() => throwBaseError(), throwsA(isA<EzvizException>()));
    });
  });
  
  group('Error code patterns', () {
    test('handles common EZVIZ error codes', () {
      final commonErrorCodes = [
        '10001', // Authentication failed
        '10002', // Token expired
        '20008', // Device offline
        '20020', // Device already added
        '20022', // Verification code required
        '30001', // Network timeout
        '30003', // Server error
      ];
      
      for (final code in commonErrorCodes) {
        final authException = EzvizAuthException('Auth error', code: code);
        final apiException = EzvizApiException('API error', code: code);
        
        authException.code.expectMeaningful(
          equals(code),
          reason: 'Auth exception should preserve error code: $code',
        );
        
        apiException.code.expectMeaningful(
          equals(code),
          reason: 'API exception should preserve error code: $code',
        );
      }
    });
  });
}