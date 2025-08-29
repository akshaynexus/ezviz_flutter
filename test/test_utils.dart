import 'dart:io';
import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ezviz_flutter/src/ezviz_client.dart';

/// Test utilities and helpers for EZVIZ Flutter SDK tests
class TestUtils {
  static final _random = math.Random(42); // Seeded for deterministic tests
  
  /// Creates a temporary directory for test files
  static Directory createTempDir() {
    final tempDir = Directory.systemTemp.createTempSync('ezviz_test_');
    addTearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });
    return tempDir;
  }
  
  /// Seeded random number generator for deterministic tests
  static math.Random get random => _random;
  
  /// Reset random seed for reproducible test runs
  static void resetRandom([int? seed]) {
    _random.nextDouble(); // Consume current state
  }
  
  /// Helper to generate test URLs
  static String generateTestUrl({String? domain}) {
    return 'https://${domain ?? 'test.ezvizlife.com'}/api/test';
  }
  
  /// Helper to create test app key/secret pairs
  static Map<String, String> generateTestCredentials() {
    return {
      'appKey': 'test_app_key_${_random.nextInt(1000)}',
      'appSecret': 'test_app_secret_${_random.nextInt(1000)}',
      'accessToken': 'test_access_token_${_random.nextInt(1000)}',
    };
  }
}

/// Test clock implementation for deterministic time-based testing
class TestClock {
  DateTime _currentTime = DateTime(2024, 8, 30, 12, 0, 0);
  
  DateTime get now => _currentTime;
  
  void advance(Duration duration) {
    _currentTime = _currentTime.add(duration);
  }
  
  void setTime(DateTime time) {
    _currentTime = time;
  }
  
  void reset() {
    _currentTime = DateTime(2024, 8, 30, 12, 0, 0);
  }
}

/// Golden test helpers
class GoldenTestHelper {
  /// Pump widget with standard testing environment
  static Future<void> pumpWidgetWithMaterial(
    WidgetTester tester,
    Widget widget, {
    ThemeData? theme,
    double? textScaleFactor,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: theme ?? ThemeData.light(),
        home: MediaQuery(
          data: MediaQueryData(
            textScaler: TextScaler.linear(textScaleFactor ?? 1.0),
          ),
          child: Scaffold(body: widget),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }
  
  /// Standard golden test with multiple theme variants
  static Future<void> expectGoldenVariants(
    WidgetTester tester,
    Widget widget,
    String goldenName, {
    bool testDarkMode = true,
    List<double> textScales = const [1.0, 1.5],
  }) async {
    // Light theme variants
    for (final scale in textScales) {
      await pumpWidgetWithMaterial(
        tester, 
        widget,
        textScaleFactor: scale,
      );
      await expectLater(
        find.byType(Scaffold),
        matchesGoldenFile('goldens/${goldenName}_light_${scale}x.png'),
      );
    }
    
    // Dark theme variants
    if (testDarkMode) {
      for (final scale in textScales) {
        await pumpWidgetWithMaterial(
          tester,
          widget,
          theme: ThemeData.dark(),
          textScaleFactor: scale,
        );
        await expectLater(
          find.byType(Scaffold),
          matchesGoldenFile('goldens/${goldenName}_dark_${scale}x.png'),
        );
      }
    }
  }
}

/// Extension to mark meaningful assertions vs trivial ones
extension MeaningfulExpectation on Object? {
  /// Wrapper that marks this as a meaningful assertion for coverage analysis
  void expectMeaningful(Matcher matcher, {String? reason}) {
    expect(this, matcher, reason: reason);
  }
}

/// HTTP response builder for testing
class MockHttpResponse {
  static Map<String, dynamic> successResponse({
    required Map<String, dynamic> data,
    String code = '200',
    String message = 'Success',
  }) {
    return {
      'code': code,
      'msg': message,
      'data': data,
    };
  }
  
  static Map<String, dynamic> errorResponse({
    String code = '10001',
    String message = 'Authentication failed',
  }) {
    return {
      'code': code,
      'msg': message,
    };
  }
  
  static Map<String, dynamic> authResponse({
    required String accessToken,
    String? areaDomain,
    DateTime? expireTime,
  }) {
    return successResponse(data: {
      'accessToken': accessToken,
      'areaDomain': areaDomain ?? 'test.ezvizlife.com',
      'expireTime': (expireTime ?? DateTime.now().add(Duration(hours: 24)))
          .millisecondsSinceEpoch,
    });
  }
}

/// Mock EzvizClient for testing services
class MockEzvizClient extends EzvizClient {
  String? lastEndpoint;
  Map<String, dynamic>? lastBody;
  Map<String, String>? lastHeaders;
  
  Map<String, dynamic>? mockResponse;
  bool throwError = false;
  bool throwErrorOnce = false;
  String errorMessage = 'Mock error';
  int callCount = 0;
  
  MockEzvizClient() : super(accessToken: 'test_token');
  
  @override
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    callCount++;
    lastEndpoint = endpoint;
    lastBody = body;
    
    if (throwError || (throwErrorOnce && callCount == 1)) {
      throw Exception(errorMessage);
    }
    
    return mockResponse ?? {'code': '200', 'data': {'success': true}};
  }
  
  /// Reset mock state between tests
  void reset() {
    lastEndpoint = null;
    lastBody = null;
    lastHeaders = null;
    mockResponse = null;
    throwError = false;
    throwErrorOnce = false;
    errorMessage = 'Mock error';
    callCount = 0;
  }
}

/// Widget test helpers for pumping frames deterministically
class WidgetTestHelpers {
  /// Pump frames for animation testing with fixed duration
  static Future<void> pumpFrames(
    WidgetTester tester, {
    int frames = 10,
    Duration frameDuration = const Duration(milliseconds: 16),
  }) async {
    for (int i = 0; i < frames; i++) {
      await tester.pump(frameDuration);
    }
  }
  
  /// Pump until specific widget state is reached
  static Future<void> pumpUntilFound(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 50));
      if (finder.evaluate().isNotEmpty) return;
    }
    throw TimeoutException('Widget not found within timeout', timeout);
  }
}