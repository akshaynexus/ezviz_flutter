import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ezviz_flutter/ezviz_player.dart';
import 'package:ezviz_flutter/ezviz_playback_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel enhanced = MethodChannel('ezviz_flutter/enhanced_playback');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(enhanced, null);
  });

  test('enhanced playback controller success and error paths', () async {
    // Controller requires an id; we won't contact native player channel in these calls
    final controller = EzvizPlayerController(1);

    // Success path
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(enhanced, (call) async {
      switch (call.method) {
        case 'seekPlayback':
          expect(call.arguments, contains('timeMs'));
          return true;
        case 'getOSDTime':
          return 123456;
        case 'setPlaySpeed':
          return true;
        case 'startLocalRecord':
          return true;
        case 'stopLocalRecord':
          return true;
        case 'isLocalRecording':
          return true;
        case 'captureImage':
          return '/tmp/test.png';
        case 'scalePlayWindow':
          return true;
      }
      return null;
    });

    expect(await controller.seekPlayback(1000), isTrue);
    expect(await controller.getOSDTime(), 123456);
    expect(await controller.setPlaySpeed(2.0), isTrue);
    expect(await controller.startLocalRecord('/tmp/file.mp4'), isTrue);
    expect(await controller.stopLocalRecord(), isTrue);
    expect(await controller.isLocalRecording(), isTrue);
    expect(await controller.captureImage(), '/tmp/test.png');
    expect(await controller.scalePlayWindow(1.2, 0.8), isTrue);

    // Error path
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(enhanced, (_) async => Future.error(PlatformException(code: 'ERR')));

    expect(await controller.seekPlayback(1000), isFalse);
    expect(await controller.getOSDTime(), 0);
    expect(await controller.setPlaySpeed(2.0), isFalse);
    expect(await controller.startLocalRecord('/tmp/file.mp4'), isFalse);
    expect(await controller.stopLocalRecord(), isFalse);
    expect(await controller.isLocalRecording(), isFalse);
    expect(await controller.captureImage(), isNull);
    expect(await controller.scalePlayWindow(1.0, 1.0), isFalse);
  });

  group('Playback utils', () {
    test('formatPlaybackTime formats correctly', () {
      expect(EzvizPlaybackUtils.formatPlaybackTime(59000), '00:59');
      expect(EzvizPlaybackUtils.formatPlaybackTime(61 * 1000), '01:01');
      expect(EzvizPlaybackUtils.formatPlaybackTime(3661 * 1000), '01:01:01');
    });

    test('calculateProgress and progressToTime', () {
      final progress0 = EzvizPlaybackUtils.calculateProgress(currentTime: 1000, startTime: 2000, endTime: 3000);
      expect(progress0, 0.0);
      final progress1 = EzvizPlaybackUtils.calculateProgress(currentTime: 3000, startTime: 2000, endTime: 3000);
      expect(progress1, 1.0);
      final progress = EzvizPlaybackUtils.calculateProgress(currentTime: 2500, startTime: 2000, endTime: 3000);
      expect(progress, closeTo(0.5, 1e-9));

      final t0 = EzvizPlaybackUtils.progressToTime(progress: 0.0, startTime: 2000, endTime: 3000);
      expect(t0, 2000);
      final t1 = EzvizPlaybackUtils.progressToTime(progress: 1.0, startTime: 2000, endTime: 3000);
      expect(t1, 3000);
      final tm = EzvizPlaybackUtils.progressToTime(progress: 0.5, startTime: 2000, endTime: 3000);
      expect(tm, 2500);
    });

    test('getPlaybackSpeeds returns expected options', () {
      final speeds = EzvizPlaybackUtils.getPlaybackSpeeds();
      expect(speeds.length, greaterThan(3));
      expect(speeds.first.value, 0.25);
      expect(speeds.last.value, 4.0);
      expect(speeds.first != speeds.last, isTrue);
      expect(speeds.first.hashCode, speeds.first.value.hashCode);
      expect(speeds.first.toString(), contains('x'));
    });
  });
}

