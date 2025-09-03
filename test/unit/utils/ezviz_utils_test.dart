import 'package:flutter_test/flutter_test.dart';
import 'package:ezviz_flutter/ezviz_utils.dart';

void main() {
  group('ezviz_utils', () {
    test('ezvizLog runs without throwing', () {
      // We just verify it does not throw and formats the string
      expect(() => ezvizLog('hello'), returnsNormally);
    });

    group('dateToStr', () {
      test('formats non-null DateTime to expected slug', () {
        final dt = DateTime(2024, 8, 30, 9, 5, 7);
        expect(dateToStr(dt), '20240830090507');
      });

      test('returns null for null input', () {
        expect(dateToStr(null), isNull);
      });
    });

    group('EzvizVideoLevels', () {
      test('accepts valid levels and rejects invalid', () {
        expect(EzvizVideoLevels.isVideolLevel(EzvizVideoLevels.Low), isTrue);
        expect(EzvizVideoLevels.isVideolLevel(EzvizVideoLevels.Middle), isTrue);
        expect(EzvizVideoLevels.isVideolLevel(EzvizVideoLevels.High), isTrue);
        expect(EzvizVideoLevels.isVideolLevel(EzvizVideoLevels.SuperHigh), isTrue);
        expect(EzvizVideoLevels.isVideolLevel(-1), isFalse);
        expect(EzvizVideoLevels.isVideolLevel(999), isFalse);
      });
    });

    group('PTZ helpers', () {
      test('commands validator works', () {
        expect(EzvizPtzCommands.isPtzCommand(EzvizPtzCommands.Left), isTrue);
        expect(EzvizPtzCommands.isPtzCommand('BAD'), isFalse);
      });

      test('actions validator works', () {
        expect(EzvizPtzActions.isPtzAction(EzvizPtzActions.Start), isTrue);
        expect(EzvizPtzActions.isPtzAction('NOPE'), isFalse);
      });

      test('speeds validator works', () {
        expect(EzvizPtzSpeeds.isPtzSpeed(EzvizPtzSpeeds.Slow), isTrue);
        expect(EzvizPtzSpeeds.isPtzSpeed(12345), isFalse);
      });
    });

    group('Stream types', () {
      test('validator works', () {
        expect(EzvizStreamTypes.isStreamType(EzvizStreamTypes.Main), isTrue);
        expect(EzvizStreamTypes.isStreamType(42), isFalse);
      });
    });
  });
}

