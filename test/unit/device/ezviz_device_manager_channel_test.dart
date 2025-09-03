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

  test('boolean-return calls and list/map paths', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      switch (call.method) {
        case EzvizChannelMethods.addDevice:
        case EzvizChannelMethods.deleteDevice:
        case 'startConfigWifi':
        case 'stopConfigWifi':
          return true;
        case EzvizChannelMethods.searchRecordFile:
          return [
            {'fileName': 'c1', 'startTime': 1, 'endTime': 2, 'fileSize': 3, 'recType': 0}
          ];
        case EzvizChannelMethods.searchDeviceRecordFile:
          return [
            {'fileName': 'd1', 'startTime': 4, 'endTime': 5, 'fileSize': 6}
          ];
        case EzvizChannelMethods.probeDeviceInfo:
          return {
            'deviceSerial': 'D',
            'deviceName': 'N',
            'deviceType': 'T',
            'status': 1,
            'supportWifi': true,
            'netType': 'wifi',
          };
      }
      return null;
    });

    expect(await EzvizDeviceManager.addDevice(deviceSerial: 'D', verifyCode: ''), isTrue);
    expect(await EzvizDeviceManager.deleteDevice('D'), isTrue);
    expect(await EzvizDeviceManager.startConfigWifi(deviceSerial: 'D', ssid: 'S', password: 'P'), isTrue);
    expect(await EzvizDeviceManager.stopConfigWifi(), isTrue);

    final cloud = await EzvizDeviceManager.searchCloudRecordFiles(deviceSerial: 'D', startTime: 1, endTime: 2);
    expect(cloud.first.fileName, 'c1');
    final dev = await EzvizDeviceManager.searchDeviceRecordFiles(deviceSerial: 'D', startTime: 1, endTime: 2);
    expect(dev.first.fileName, 'd1');
    final probe = await EzvizDeviceManager.probeDeviceInfo('D');
    expect(probe?.deviceSerial, 'D');
  });
}

