import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ezviz_flutter/ezviz_device_manager.dart';
import 'package:ezviz_flutter/ezviz_methods.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel = MethodChannel(EzvizChannelMethods.methodChannelName);

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getDeviceList and getDeviceDetailInfo return typed structures', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      if (call.method == EzvizChannelMethods.getDeviceList) {
        return List<Map<String, dynamic>>.from([
          {
            'deviceSerial': 'D1',
            'deviceName': 'N1',
            'isSupportPTZ': false,
            'cameraNum': 1,
          }
        ]);
      }
      if (call.method == EzvizChannelMethods.getDeviceDetailInfo) {
        return <String, dynamic>{'deviceSerial': 'D1', 'deviceName': 'N1'};
      }
      return null;
    });

    final list = await EzvizDeviceManager.getDeviceList(pageStart: 0, pageSize: 10);
    expect(list, isNotEmpty);
    expect(list.first.deviceSerial, 'D1');

    final info = await EzvizDeviceManager.getDeviceDetailInfo('D1');
    expect(info, isA<Map<String, dynamic>?>());
    expect(info!['deviceSerial'], 'D1');
  });
}

