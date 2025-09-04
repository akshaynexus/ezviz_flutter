import 'package:flutter_test/flutter_test.dart';
import 'package:ezviz_flutter/ezviz_errorcode.dart';

void main() {
  test('ezvizErrorCode contains common keys and messages', () {
    expect(ezvizErrorCode[110002], contains('AccessToken'));
    expect(ezvizErrorCode[102003], contains('offline'));
    expect(ezvizErrorCode[160000], contains('PTZ'));
    expect(ezvizErrorCode.containsKey(150000), isTrue);
  });
}

