import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ezviz_flutter/ezviz_wifi_config.dart';
import 'package:ezviz_flutter/ezviz_methods.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel(
    EzvizChannelMethods.methodChannelName,
  );

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('startWifiConfig/startAPConfig/stopConfig success and error', () async {
    // Success path
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'startConfigWifi' || call.method == 'startConfigAP' || call.method == 'stopConfig') {
        return true;
      }
      return null;
    });

    expect(
      await EzvizWifiConfig.startWifiConfig(deviceSerial: 'D', ssid: 'S', password: 'P'),
      isTrue,
    );
    expect(
      await EzvizWifiConfig.startAPConfig(deviceSerial: 'D', ssid: 'S', password: 'P', verifyCode: 'V'),
      isTrue,
    );
    expect(await EzvizWifiConfig.stopConfig(mode: EzvizWifiConfigMode.wave), isTrue);

    // Error path
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async => Future.error(PlatformException(code: 'ERR')));

    expect(
      await EzvizWifiConfig.startWifiConfig(deviceSerial: 'D', ssid: 'S'),
      isFalse,
    );
    expect(
      await EzvizWifiConfig.startAPConfig(deviceSerial: 'D', ssid: 'S'),
      isFalse,
    );
    expect(await EzvizWifiConfig.stopConfig(mode: EzvizWifiConfigMode.ap), isFalse);
  });

  test('setConfigEventHandler and remove', () async {
    // We cannot easily push events through EventChannel here; just ensure no-throw and cancel logic works
    EzvizWifiConfig.setConfigEventHandler((_) {});
    EzvizWifiConfig.removeConfigEventHandler();
  });
}

