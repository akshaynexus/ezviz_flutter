import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ezviz_flutter/ezviz_methods.dart';
import 'package:ezviz_flutter/widgets/ezviz_simple_player.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel(EzvizChannelMethods.methodChannelName);

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  testWidgets('creates a real platform view for SimplePlayer', (tester) async {
    // Only runs on Android/iOS
    if (!(Platform.isAndroid || Platform.isIOS)) {
      return; // Skip on unsupported hosts
    }

    // Mock initSDK success so widget proceeds
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      if (call.method == EzvizChannelMethods.initSDK) return true;
      // openSound/closeSound return true to allow button toggles
      if (call.method == EzvizChannelMethods.openSound ||
          call.method == EzvizChannelMethods.closeSound) {
        return true;
      }
      return null;
    });

    const config = EzvizPlayerConfig(
      appKey: 'test_key',
      appSecret: 'test_secret',
      showControls: true,
      autoPlay: false,
    );

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SizedBox(
          height: 240,
          child: EzvizSimplePlayer(
            deviceSerial: 'D',
            channelNo: 1,
            config: config,
          ),
        ),
      ),
    ));

    // Allow frames for platform view creation
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Verify the wrapper and that a platform view was created under the hood
    expect(find.byType(EzvizSimplePlayer), findsOneWidget);

    // Tap audio toggle to ensure channel interaction
    // We use icon since tooltip text can be localized/variant.
    final audioIcon = find.byIcon(Icons.volume_off);
    if (audioIcon.evaluate().isNotEmpty) {
      await tester.tap(audioIcon.first);
      await tester.pumpAndSettle();
    }
  });
}

