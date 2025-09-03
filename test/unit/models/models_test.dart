import 'package:flutter_test/flutter_test.dart';
import 'package:ezviz_flutter/src/models/models.dart';

void main() {
  group('Models JSON roundtrip', () {
    test('EzvizBaseResponse + EzvizDataResponse + EzvizPagedResponse', () {
      final base = EzvizBaseResponse(code: '200', msg: 'ok');
      expect(base.toJson(), {'code': '200', 'msg': 'ok'});

      final token = TokenData(accessToken: 't', expireTime: 1, areaDomain: 'a');
      final dataResp = EzvizDataResponse<TokenData>(code: '200', msg: 'ok', data: token);
      final dataJson = dataResp.toJson();
      expect(dataJson['code'], '200');
      expect(dataJson['msg'], 'ok');

      final parsedData = EzvizDataResponse<TokenData>.fromJson(
        {
          'code': '200',
          'msg': 'ok',
          'data': {'accessToken': 't', 'expireTime': 1, 'areaDomain': 'a'}
        },
        (json) => TokenData.fromJson(json as Map<String, dynamic>),
      );
      expect(parsedData.data!.accessToken, 't');

      final paged = EzvizPagedResponse<DeviceInfo>.fromJson(
        {
          'code': '200',
          'msg': 'ok',
          'data': [
            {'deviceSerial': 'd1', 'deviceName': 'n1'}
          ],
          'page': {'total': 1, 'page': 0, 'size': 10}
        },
        (json) => DeviceInfo.fromJson(json as Map<String, dynamic>),
      );
      expect(paged.data!.first.deviceSerial, 'd1');
      expect(paged.page!.total, 1);
      expect(paged.toJson()['page'], isNotNull);
    });

    test('DeviceInfo/CameraInfo/CapturedPicture/PlayAddress', () {
      final device = DeviceInfo.fromJson({
        'deviceSerial': 'D',
        'deviceName': 'N',
        'status': 1,
        'isEncrypt': 0,
      });
      expect(device.toJson()['deviceSerial'], 'D');

      final camera = CameraInfo.fromJson({
        'deviceSerial': 'D',
        'channelNo': 1,
        'status': 1,
        'videoLevel': 2,
      });
      expect(camera.toJson()['channelNo'], 1);

      final shot = CapturedPicture.fromJson({'picUrl': 'u'});
      expect(shot.toJson()['picUrl'], 'u');

      final play = PlayAddress.fromJson({'id': '1', 'url': 'u', 'expireTime': 't'});
      expect(play.toJson()['url'], 'u');
    });

    test('DeviceStatusInfo/TimezoneInfo/EzvizAlarmInfo/DeviceSwitchStatus', () {
      final status = DeviceStatusInfo.fromJson({'privacyStatus': 1, 'pirStatus': 0});
      expect(status.toJson()['privacyStatus'], 1);

      final tz = TimezoneInfo.fromJson({'tzCode': 'IN', 'tzValue': '+5:30', 'disPlayName': 'IST'});
      expect(tz.toJson()['tzCode'], 'IN');

      final alarm = EzvizAlarmInfo.fromJson({
        'alarmId': 'A',
        'alarmType': 10002,
        'alarmTime': 1,
        'channelNo': 1,
        'isEncrypt': 0,
        'isChecked': 1,
        'deviceSerial': 'D'
      });
      expect(alarm.toJson()['alarmId'], 'A');

      final sw = DeviceSwitchStatus.fromJson({'deviceSerial': 'D', 'channelNo': 1, 'enable': 1});
      expect(sw.toJson()['enable'], 1);
    });

    test('Defence/PIR/Chime/Language/Capability', () {
      final def = DeviceDefencePlan.fromJson({
        'startTime': '00:00',
        'stopTime': '01:00',
        'period': '0,1,2',
        'enable': 1,
      });
      expect(def.toJson()['enable'], 1);

      final pir = PirAreaConfig.fromJson({
        'deviceSerial': 'D',
        'channelNo': 1,
        'rows': 3,
        'columns': 3,
        'area': [1, 2, 3]
      });
      expect(pir.toJson()['rows'], 3);

      final chime = ChimeConfig.fromJson({'deviceSerial': 'D', 'channelNo': 1, 'type': 2, 'duration': 5});
      expect(chime.toJson()['type'], 2);

      final lang = DeviceLanguage.fromJson({'language': 'ENGLISH'});
      expect(lang.toJson()['language'], 'ENGLISH');

      final cap = DeviceCapability.fromJson({'data': {'foo': 'bar'}});
      expect(cap.toJson()['data']['foo'], 'bar');
    });

    test('Detector/Bindable/Linked IPC', () {
      final det = DetectorInfo.fromJson({'detectorSerial': 'S', 'detectorState': 1});
      expect(det.toJson()['detectorSerial'], 'S');
    });

    test('FillLight/DeviceGeneralSwitch/Plans', () {
      final fill = FillLightMode.fromJson(
          {'deviceSerial': 'D', 'graphicType': 1, 'luminance': 100, 'duration': 5});
      expect(fill.toJson()['graphicType'], 1);

      final sw = DeviceGeneralSwitchStatus.fromJson({'subSerial': 'D', 'type': 301, 'enable': 1});
      expect(sw.toJson()['enable'], 1);

      final time = TimePlanEntry.fromJson(
          {'beginTime': '00:00', 'endTime': '01:00', 'eventArg': 'mode:0'});
      expect(time.toJson()['eventArg'], 'mode:0');

      final week = WeekPlanEntry.fromJson({
        'weekDay': '0,1',
        'timePlan': [
          {'beginTime': '00:00', 'endTime': '01:00', 'eventArg': 'mode:0'}
        ]
      });
      expect(week.toJson()['weekDay'], '0,1');

      final plan = DeviceWorkingModePlan.fromJson({
        'subSerial': 'S',
        'weekPlans': [
          {
            'weekDay': '0,1',
            'timePlan': [
              {'beginTime': '00:00', 'endTime': '01:00', 'eventArg': 'mode:0'}
            ]
          }
        ]
      });
      expect(plan.toJson()['subSerial'], 'S');
    });

    test('AlarmSound/DetectionArea/Storage/Format', () {
      final alarm = AlarmSoundMode.fromJson({'deviceSerial': 'D', 'alarmSoundMode': 2});
      expect(alarm.toJson()['alarmSoundMode'], 2);

      final da = DetectionAreaConfig.fromJson(
        {'deviceSerial': 'D', 'channelNo': 1, 'rows': 3, 'columns': 3, 'area': [1, 2, 3]},
      );
      expect(da.toJson()['columns'], 3);

      final storage = StorageMediumStatus.fromJson({'index': 0, 'status': 1});
      expect(storage.toJson()['status'], 1);

      final format = DeviceFormatStatusResponseData.fromJson({
        'storageStatus': [
          {'index': 0, 'status': 0}
        ]
      });
      expect((format.toJson()['storageStatus'] as List).length, 1);
    });

    test('CloudStorageInfo/Detail/RAM Policy and Info', () {
      final detail = CloudStorageServiceDetail.fromJson({'userName': 'u', 'status': 0});
      expect(detail.toJson()['status'], 0);

      final info = CloudStorageInfo.fromJson({
        'userName': 'u',
        'status': 1,
        'serviceDetail': {'userName': 'u', 'status': 0}
      });
      expect(info.toJson()['status'], 1);

      final stmt = RamAccountPolicyStatement.fromJson({'Permission': 'read', 'Resource': ['*']});
      expect(stmt.toJson()['Permission'], 'read');

      final pol = RamAccountPolicy.fromJson({
        'Statement': [
          {'Permission': 'read'}
        ]
      });
      expect((pol.toJson()['Statement'] as List).length, 1);

      final ram = RamAccountInfo.fromJson({'accountId': 'id', 'accountStatus': 1});
      expect(ram.toJson()['accountId'], 'id');
    });
  });
}
