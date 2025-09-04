import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ezviz_flutter/ezviz_methods.dart';
import 'package:ezviz_flutter/widgets/ezviz_simple_player.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel(EzvizChannelMethods.methodChannelName);

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  EzvizPlayerConfig config() => const EzvizPlayerConfig(
        appKey: 'test_key',
        appSecret: 'test_secret',
        accessToken: null,
        showControls: true,
        compactControls: false,
        controlsHideTimeout: Duration(milliseconds: 100),
      );

  // Intentionally exercise error path to avoid creating platform views in test environment

  testWidgets('error then re-mount path stays stable', (tester) async {
    // First: make initSDK error
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async => Future.error(PlatformException(code: 'ERR')));

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: EzvizSimplePlayer(key: const ValueKey('err'), deviceSerial: 'D', channelNo: 1, config: config()),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.byType(EzvizSimplePlayer), findsOneWidget);

    // Now: re-mount again with same error to ensure stability
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: EzvizSimplePlayer(key: const ValueKey('ok'), deviceSerial: 'D', channelNo: 1, config: config()),
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.byType(EzvizSimplePlayer), findsOneWidget);
  });
}
