import 'package:flutter_test/flutter_test.dart';
import 'package:ezviz_flutter/ezviz.dart';

void main() {
  group('EzvizManager parameter validation', () {
    test('setVideoLevel rejects invalid level', () async {
      final mgr = EzvizManager.shared();
      // 99 is not a valid level
      final result = await mgr.setVideoLevel('DEV1', 1, 99);
      expect(result, isFalse);
    });

    test('controlPTZ rejects invalid command/action/speed', () async {
      final mgr = EzvizManager.shared();

      expect(
        await mgr.controlPTZ('DEV1', 1, 'BAD', 'EZPTZAction_START', 1),
        isFalse,
      );
      expect(
        await mgr.controlPTZ('DEV1', 1, 'EZPTZCommand_Left', 'BAD', 1),
        isFalse,
      );
      expect(
        await mgr.controlPTZ('DEV1', 1, 'EZPTZCommand_Left', 'EZPTZAction_START', 99),
        isFalse,
      );
    });

    test('netControlPTZ rejects invalid command/action', () async {
      final mgr = EzvizManager.shared();

      expect(await mgr.netControlPTZ(1, 1, 'BAD', 'EZPTZAction_START'), isFalse);
      expect(await mgr.netControlPTZ(1, 1, 'EZPTZCommand_Left', 'BAD'), isFalse);
    });
  });
}

