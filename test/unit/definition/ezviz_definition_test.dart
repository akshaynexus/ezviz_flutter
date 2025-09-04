import 'package:flutter_test/flutter_test.dart';
import 'package:ezviz_flutter/ezviz_definition.dart';

void main() {
  test('EzvizNetDeviceInfo.fromJson maps values', () {
    final info = EzvizNetDeviceInfo.fromJson({
      'userId': 'U1',
      'dChannelCount': 2,
      'dStartChannelNo': 1,
      'channelCount': 4,
      'startChannelNo': 0,
      'byDVRType': 3,
    });
    expect(info.userId, 'U1');
    expect(info.dChannelCount, 2);
    expect(info.byDVRType, 3);
  });

  test('EzvizEvent.init and EzvizPlayerStatus to/from JSON', () {
    final e = EzvizEvent.init({'eventType': 'playerStatusChange', 'msg': 'ok'});
    expect(e, isNotNull);
    expect(e!.eventType, 'playerStatusChange');

    final status = EzvizPlayerStatus.fromJson({'status': 2, 'message': 'PLAYING'});
    final json = status.toJson();
    expect(json['status'], 2);
    expect(json['message'], 'PLAYING');
  });
}

