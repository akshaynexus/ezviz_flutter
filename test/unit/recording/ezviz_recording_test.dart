import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ezviz_flutter/ezviz_recording.dart';
import 'package:ezviz_flutter/ezviz_methods.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel = MethodChannel(EzvizChannelMethods.methodChannelName);

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('recording calls success and error', () async {
    // Success mocks
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      switch (call.method) {
        case 'capturePicture':
          return '/tmp/snap.jpg';
        case 'startRecording':
        case 'stopRecording':
        case 'isRecording':
          return true;
      }
      return null;
    });

    expect(await EzvizRecording.capturePicture(), '/tmp/snap.jpg');
    expect(await EzvizRecording.startRecording(), isTrue);
    expect(await EzvizRecording.stopRecording(), isTrue);
    expect(await EzvizRecording.isRecording(), isTrue);

    // Error mocks
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async => Future.error(PlatformException(code: 'ERR')));

    expect(await EzvizRecording.capturePicture(), isNull);
    expect(await EzvizRecording.startRecording(), isFalse);
    expect(await EzvizRecording.stopRecording(), isFalse);
    expect(await EzvizRecording.isRecording(), isFalse);
  });
}

