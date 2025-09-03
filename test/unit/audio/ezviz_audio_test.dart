import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ezviz_flutter/ezviz_audio.dart';
import 'package:ezviz_flutter/ezviz_methods.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel(
    EzvizChannelMethods.methodChannelName,
  );

  setUp(() {
    // Clear any previous handler
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('openSound/closeSound success + error', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'openSound') return true;
      if (call.method == 'closeSound') return true;
      return null;
    });

    expect(await EzvizAudio.openSound(), isTrue);
    expect(await EzvizAudio.closeSound(), isTrue);

    // Error cases
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async {
      throw PlatformException(code: 'ERR');
    });
    expect(await EzvizAudio.openSound(), isFalse);
    expect(await EzvizAudio.closeSound(), isFalse);
  });

  test('startVoiceTalk/stopVoiceTalk success + error', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'startVoiceTalk') {
        expect(call.arguments, containsPair('deviceSerial', 'DEV1'));
        expect(call.arguments, contains('cameraNo'));
        return true;
      }
      if (call.method == 'stopVoiceTalk') return true;
      return null;
    });

    expect(
      await EzvizAudio.startVoiceTalk(deviceSerial: 'DEV1', cameraNo: 2),
      isTrue,
    );
    expect(await EzvizAudio.stopVoiceTalk(), isTrue);

    // Error path
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async {
      throw PlatformException(code: 'ERR');
    });
    expect(
      await EzvizAudio.startVoiceTalk(deviceSerial: 'DEV1'),
      isFalse,
    );
    expect(await EzvizAudio.stopVoiceTalk(), isFalse);
  });
}

