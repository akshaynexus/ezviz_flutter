// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EzvizBaseResponse _$EzvizBaseResponseFromJson(Map<String, dynamic> json) =>
    EzvizBaseResponse(code: json['code'] as String, msg: json['msg'] as String);

Map<String, dynamic> _$EzvizBaseResponseToJson(EzvizBaseResponse instance) =>
    <String, dynamic>{'code': instance.code, 'msg': instance.msg};

EzvizDataResponse<T> _$EzvizDataResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => EzvizDataResponse<T>(
  code: json['code'] as String,
  msg: json['msg'] as String,
  data: _$nullableGenericFromJson(json['data'], fromJsonT),
);

Map<String, dynamic> _$EzvizDataResponseToJson<T>(
  EzvizDataResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'code': instance.code,
  'msg': instance.msg,
  'data': _$nullableGenericToJson(instance.data, toJsonT),
};

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) => input == null ? null : toJson(input);

EzvizPageInfo _$EzvizPageInfoFromJson(Map<String, dynamic> json) =>
    EzvizPageInfo(
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      size: (json['size'] as num).toInt(),
    );

Map<String, dynamic> _$EzvizPageInfoToJson(EzvizPageInfo instance) =>
    <String, dynamic>{
      'total': instance.total,
      'page': instance.page,
      'size': instance.size,
    };

EzvizPagedResponse<T> _$EzvizPagedResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => EzvizPagedResponse<T>(
  code: json['code'] as String,
  msg: json['msg'] as String,
  data: (json['data'] as List<dynamic>?)?.map(fromJsonT).toList(),
  page: json['page'] == null
      ? null
      : EzvizPageInfo.fromJson(json['page'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EzvizPagedResponseToJson<T>(
  EzvizPagedResponse<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'code': instance.code,
  'msg': instance.msg,
  'data': instance.data?.map(toJsonT).toList(),
  'page': instance.page,
};

TokenData _$TokenDataFromJson(Map<String, dynamic> json) => TokenData(
  accessToken: json['accessToken'] as String,
  expireTime: (json['expireTime'] as num).toInt(),
  areaDomain: json['areaDomain'] as String,
);

Map<String, dynamic> _$TokenDataToJson(TokenData instance) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'expireTime': instance.expireTime,
  'areaDomain': instance.areaDomain,
};

DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) => DeviceInfo(
  deviceSerial: json['deviceSerial'] as String,
  deviceName: json['deviceName'] as String?,
  deviceType: json['deviceType'] as String?,
  model: json['model'] as String?,
  status: (json['status'] as num?)?.toInt(),
  defence: (json['defence'] as num?)?.toInt(),
  isEncrypt: (json['isEncrypt'] as num?)?.toInt(),
  deviceVersion: json['deviceVersion'] as String?,
  updateTime: json['updateTime'] as String?,
  alarmSoundMode: (json['alarmSoundMode'] as num?)?.toInt(),
  offlineNotify: (json['offlineNotify'] as num?)?.toInt(),
  wifiSsid: json['wifiSsid'] as String?,
  timeZone: json['timeZone'] as String?,
);

Map<String, dynamic> _$DeviceInfoToJson(DeviceInfo instance) =>
    <String, dynamic>{
      'deviceSerial': instance.deviceSerial,
      'deviceName': instance.deviceName,
      'deviceType': instance.deviceType,
      'model': instance.model,
      'status': instance.status,
      'defence': instance.defence,
      'isEncrypt': instance.isEncrypt,
      'deviceVersion': instance.deviceVersion,
      'updateTime': instance.updateTime,
      'alarmSoundMode': instance.alarmSoundMode,
      'offlineNotify': instance.offlineNotify,
      'wifiSsid': instance.wifiSsid,
      'timeZone': instance.timeZone,
    };

CameraInfo _$CameraInfoFromJson(Map<String, dynamic> json) => CameraInfo(
  deviceSerial: json['deviceSerial'] as String,
  channelNo: (json['channelNo'] as num).toInt(),
  channelName: json['channelName'] as String?,
  status: (json['status'] as num?)?.toInt(),
  isShared: json['isShared'] as String?,
  picUrl: json['picUrl'] as String?,
  isEncrypt: (json['isEncrypt'] as num?)?.toInt(),
  videoLevel: (json['videoLevel'] as num?)?.toInt(),
  ipcSerial: json['ipcSerial'] as String?,
  relatedIpc: json['relatedIpc'] as bool?,
);

Map<String, dynamic> _$CameraInfoToJson(CameraInfo instance) =>
    <String, dynamic>{
      'deviceSerial': instance.deviceSerial,
      'channelNo': instance.channelNo,
      'channelName': instance.channelName,
      'status': instance.status,
      'isShared': instance.isShared,
      'picUrl': instance.picUrl,
      'isEncrypt': instance.isEncrypt,
      'videoLevel': instance.videoLevel,
      'ipcSerial': instance.ipcSerial,
      'relatedIpc': instance.relatedIpc,
    };

PlayAddress _$PlayAddressFromJson(Map<String, dynamic> json) => PlayAddress(
  id: json['id'] as String,
  url: json['url'] as String,
  expireTime: json['expireTime'] as String,
);

Map<String, dynamic> _$PlayAddressToJson(PlayAddress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'expireTime': instance.expireTime,
    };

CapturedPicture _$CapturedPictureFromJson(Map<String, dynamic> json) =>
    CapturedPicture(picUrl: json['picUrl'] as String);

Map<String, dynamic> _$CapturedPictureToJson(CapturedPicture instance) =>
    <String, dynamic>{'picUrl': instance.picUrl};

DeviceStatusInfo _$DeviceStatusInfoFromJson(Map<String, dynamic> json) =>
    DeviceStatusInfo(
      privacyStatus: (json['privacyStatus'] as num?)?.toInt(),
      pirStatus: (json['pirStatus'] as num?)?.toInt(),
      alarmSoundMode: (json['alarmSoundMode'] as num?)?.toInt(),
      battryStatus: (json['battryStatus'] as num?)?.toInt(),
      lockSignal: (json['lockSignal'] as num?)?.toInt(),
      diskNum: (json['diskNum'] as num?)?.toInt(),
      diskState: json['diskState'] as String?,
      cloudType: (json['cloudType'] as num?)?.toInt(),
      cloudStatus: (json['cloudStatus'] as num?)?.toInt(),
      nvrDiskNum: (json['nvrDiskNum'] as num?)?.toInt(),
      nvrDiskState: json['nvrDiskState'] as String?,
    );

Map<String, dynamic> _$DeviceStatusInfoToJson(DeviceStatusInfo instance) =>
    <String, dynamic>{
      'privacyStatus': instance.privacyStatus,
      'pirStatus': instance.pirStatus,
      'alarmSoundMode': instance.alarmSoundMode,
      'battryStatus': instance.battryStatus,
      'lockSignal': instance.lockSignal,
      'diskNum': instance.diskNum,
      'diskState': instance.diskState,
      'cloudType': instance.cloudType,
      'cloudStatus': instance.cloudStatus,
      'nvrDiskNum': instance.nvrDiskNum,
      'nvrDiskState': instance.nvrDiskState,
    };

TimezoneInfo _$TimezoneInfoFromJson(Map<String, dynamic> json) => TimezoneInfo(
  tzCode: json['tzCode'] as String,
  tzValue: json['tzValue'] as String,
  disPlayName: json['disPlayName'] as String,
);

Map<String, dynamic> _$TimezoneInfoToJson(TimezoneInfo instance) =>
    <String, dynamic>{
      'tzCode': instance.tzCode,
      'tzValue': instance.tzValue,
      'disPlayName': instance.disPlayName,
    };

EzvizAlarmInfo _$EzvizAlarmInfoFromJson(Map<String, dynamic> json) =>
    EzvizAlarmInfo(
      alarmId: json['alarmId'] as String,
      alarmName: json['alarmName'] as String?,
      alarmType: (json['alarmType'] as num).toInt(),
      alarmTime: (json['alarmTime'] as num).toInt(),
      channelNo: (json['channelNo'] as num).toInt(),
      isEncrypt: (json['isEncrypt'] as num).toInt(),
      isChecked: (json['isChecked'] as num).toInt(),
      preTime: (json['preTime'] as num?)?.toInt(),
      delayTime: (json['delayTime'] as num?)?.toInt(),
      deviceSerial: json['deviceSerial'] as String,
      alarmPicUrl: json['alarmPicUrl'] as String?,
      customerType: json['customerType'] as String?,
      customerInfo: json['customerInfo'] as String?,
    );

Map<String, dynamic> _$EzvizAlarmInfoToJson(EzvizAlarmInfo instance) =>
    <String, dynamic>{
      'alarmId': instance.alarmId,
      'alarmName': instance.alarmName,
      'alarmType': instance.alarmType,
      'alarmTime': instance.alarmTime,
      'channelNo': instance.channelNo,
      'isEncrypt': instance.isEncrypt,
      'isChecked': instance.isChecked,
      'preTime': instance.preTime,
      'delayTime': instance.delayTime,
      'deviceSerial': instance.deviceSerial,
      'alarmPicUrl': instance.alarmPicUrl,
      'customerType': instance.customerType,
      'customerInfo': instance.customerInfo,
    };

DeviceSwitchStatus _$DeviceSwitchStatusFromJson(Map<String, dynamic> json) =>
    DeviceSwitchStatus(
      deviceSerial: json['deviceSerial'] as String,
      channelNo: (json['channelNo'] as num).toInt(),
      enable: (json['enable'] as num).toInt(),
    );

Map<String, dynamic> _$DeviceSwitchStatusToJson(DeviceSwitchStatus instance) =>
    <String, dynamic>{
      'deviceSerial': instance.deviceSerial,
      'channelNo': instance.channelNo,
      'enable': instance.enable,
    };

DeviceDefencePlan _$DeviceDefencePlanFromJson(Map<String, dynamic> json) =>
    DeviceDefencePlan(
      startTime: json['startTime'] as String,
      stopTime: json['stopTime'] as String,
      period: json['period'] as String,
      enable: (json['enable'] as num).toInt(),
    );

Map<String, dynamic> _$DeviceDefencePlanToJson(DeviceDefencePlan instance) =>
    <String, dynamic>{
      'startTime': instance.startTime,
      'stopTime': instance.stopTime,
      'period': instance.period,
      'enable': instance.enable,
    };

PirAreaConfig _$PirAreaConfigFromJson(Map<String, dynamic> json) =>
    PirAreaConfig(
      deviceSerial: json['deviceSerial'] as String,
      channelNo: (json['channelNo'] as num).toInt(),
      rows: (json['rows'] as num).toInt(),
      columns: (json['columns'] as num).toInt(),
      area: (json['area'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$PirAreaConfigToJson(PirAreaConfig instance) =>
    <String, dynamic>{
      'deviceSerial': instance.deviceSerial,
      'channelNo': instance.channelNo,
      'rows': instance.rows,
      'columns': instance.columns,
      'area': instance.area,
    };

ChimeConfig _$ChimeConfigFromJson(Map<String, dynamic> json) => ChimeConfig(
  deviceSerial: json['deviceSerial'] as String,
  channelNo: (json['channelNo'] as num).toInt(),
  type: (json['type'] as num).toInt(),
  duration: (json['duration'] as num).toInt(),
);

Map<String, dynamic> _$ChimeConfigToJson(ChimeConfig instance) =>
    <String, dynamic>{
      'deviceSerial': instance.deviceSerial,
      'channelNo': instance.channelNo,
      'type': instance.type,
      'duration': instance.duration,
    };

DeviceLanguage _$DeviceLanguageFromJson(Map<String, dynamic> json) =>
    DeviceLanguage(language: json['language'] as String);

Map<String, dynamic> _$DeviceLanguageToJson(DeviceLanguage instance) =>
    <String, dynamic>{'language': instance.language};

DeviceCapability _$DeviceCapabilityFromJson(Map<String, dynamic> json) =>
    DeviceCapability(data: json['data'] as Map<String, dynamic>);

Map<String, dynamic> _$DeviceCapabilityToJson(DeviceCapability instance) =>
    <String, dynamic>{'data': instance.data};

DetectorInfo _$DetectorInfoFromJson(Map<String, dynamic> json) => DetectorInfo(
  detectorSerial: json['detectorSerial'] as String,
  detectorType: json['detectorType'] as String?,
  detectorState: (json['detectorState'] as num?)?.toInt(),
  detectorTypeName: json['detectorTypeName'] as String?,
  location: json['location'] as String?,
  zfStatus: (json['zfStatus'] as num?)?.toInt(),
  uvStatus: (json['uvStatus'] as num?)?.toInt(),
  iwcStatus: (json['iwcStatus'] as num?)?.toInt(),
  olStatus: (json['olStatus'] as num?)?.toInt(),
  atHomeEnable: (json['atHomeEnable'] as num?)?.toInt(),
  outerEnable: (json['outerEnable'] as num?)?.toInt(),
  sleepEnable: (json['sleepEnable'] as num?)?.toInt(),
  updateTime: json['updateTime'] as String?,
);

Map<String, dynamic> _$DetectorInfoToJson(DetectorInfo instance) =>
    <String, dynamic>{
      'detectorSerial': instance.detectorSerial,
      'detectorType': instance.detectorType,
      'detectorState': instance.detectorState,
      'detectorTypeName': instance.detectorTypeName,
      'location': instance.location,
      'zfStatus': instance.zfStatus,
      'uvStatus': instance.uvStatus,
      'iwcStatus': instance.iwcStatus,
      'olStatus': instance.olStatus,
      'atHomeEnable': instance.atHomeEnable,
      'outerEnable': instance.outerEnable,
      'sleepEnable': instance.sleepEnable,
      'updateTime': instance.updateTime,
    };

BindableIpcInfo _$BindableIpcInfoFromJson(Map<String, dynamic> json) =>
    BindableIpcInfo(
      deviceSerial: json['deviceSerial'] as String,
      channelNo: (json['channelNo'] as num).toInt(),
      cameraName: json['cameraName'] as String?,
    );

Map<String, dynamic> _$BindableIpcInfoToJson(BindableIpcInfo instance) =>
    <String, dynamic>{
      'deviceSerial': instance.deviceSerial,
      'channelNo': instance.channelNo,
      'cameraName': instance.cameraName,
    };

LinkedIpcInfo _$LinkedIpcInfoFromJson(Map<String, dynamic> json) =>
    LinkedIpcInfo(
      detectorSerial: json['detectorSerial'] as String,
      ipcSerial: json['ipcSerial'] as String,
    );

Map<String, dynamic> _$LinkedIpcInfoToJson(LinkedIpcInfo instance) =>
    <String, dynamic>{
      'detectorSerial': instance.detectorSerial,
      'ipcSerial': instance.ipcSerial,
    };

FillLightMode _$FillLightModeFromJson(Map<String, dynamic> json) =>
    FillLightMode(
      deviceSerial: json['deviceSerial'] as String,
      graphicType: (json['graphicType'] as num).toInt(),
      luminance: (json['luminance'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FillLightModeToJson(FillLightMode instance) =>
    <String, dynamic>{
      'deviceSerial': instance.deviceSerial,
      'graphicType': instance.graphicType,
      'luminance': instance.luminance,
      'duration': instance.duration,
    };

DeviceGeneralSwitchStatus _$DeviceGeneralSwitchStatusFromJson(
  Map<String, dynamic> json,
) => DeviceGeneralSwitchStatus(
  subSerial: json['subSerial'] as String,
  type: (json['type'] as num).toInt(),
  enable: (json['enable'] as num).toInt(),
);

Map<String, dynamic> _$DeviceGeneralSwitchStatusToJson(
  DeviceGeneralSwitchStatus instance,
) => <String, dynamic>{
  'subSerial': instance.subSerial,
  'type': instance.type,
  'enable': instance.enable,
};

TimePlanEntry _$TimePlanEntryFromJson(Map<String, dynamic> json) =>
    TimePlanEntry(
      beginTime: json['beginTime'] as String,
      endTime: json['endTime'] as String,
      eventArg: json['eventArg'] as String,
    );

Map<String, dynamic> _$TimePlanEntryToJson(TimePlanEntry instance) =>
    <String, dynamic>{
      'beginTime': instance.beginTime,
      'endTime': instance.endTime,
      'eventArg': instance.eventArg,
    };

WeekPlanEntry _$WeekPlanEntryFromJson(Map<String, dynamic> json) =>
    WeekPlanEntry(
      weekDay: json['weekDay'] as String,
      timePlan: (json['timePlan'] as List<dynamic>)
          .map((e) => TimePlanEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WeekPlanEntryToJson(WeekPlanEntry instance) =>
    <String, dynamic>{
      'weekDay': instance.weekDay,
      'timePlan': instance.timePlan.map((e) => e.toJson()).toList(),
    };

DeviceWorkingModePlan _$DeviceWorkingModePlanFromJson(
  Map<String, dynamic> json,
) => DeviceWorkingModePlan(
  subSerial: json['subSerial'] as String,
  subType: (json['subType'] as num?)?.toInt(),
  weekPlans: (json['weekPlans'] as List<dynamic>)
      .map((e) => WeekPlanEntry.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DeviceWorkingModePlanToJson(
  DeviceWorkingModePlan instance,
) => <String, dynamic>{
  'subSerial': instance.subSerial,
  'subType': instance.subType,
  'weekPlans': instance.weekPlans.map((e) => e.toJson()).toList(),
};

AlarmSoundMode _$AlarmSoundModeFromJson(Map<String, dynamic> json) =>
    AlarmSoundMode(
      deviceSerial: json['deviceSerial'] as String,
      alarmSoundMode: (json['alarmSoundMode'] as num).toInt(),
    );

Map<String, dynamic> _$AlarmSoundModeToJson(AlarmSoundMode instance) =>
    <String, dynamic>{
      'deviceSerial': instance.deviceSerial,
      'alarmSoundMode': instance.alarmSoundMode,
    };

DetectionAreaConfig _$DetectionAreaConfigFromJson(Map<String, dynamic> json) =>
    DetectionAreaConfig(
      deviceSerial: json['deviceSerial'] as String,
      channelNo: (json['channelNo'] as num).toInt(),
      rows: (json['rows'] as num).toInt(),
      columns: (json['columns'] as num).toInt(),
      area: (json['area'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$DetectionAreaConfigToJson(
  DetectionAreaConfig instance,
) => <String, dynamic>{
  'deviceSerial': instance.deviceSerial,
  'channelNo': instance.channelNo,
  'rows': instance.rows,
  'columns': instance.columns,
  'area': instance.area,
};

StorageMediumStatus _$StorageMediumStatusFromJson(Map<String, dynamic> json) =>
    StorageMediumStatus(
      index: (json['index'] as num).toInt(),
      name: json['name'] as String?,
      status: (json['status'] as num).toInt(),
      formattingRate: json['formattingRate'] as String?,
      capacity: (json['capacity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StorageMediumStatusToJson(
  StorageMediumStatus instance,
) => <String, dynamic>{
  'index': instance.index,
  'name': instance.name,
  'status': instance.status,
  'formattingRate': instance.formattingRate,
  'capacity': instance.capacity,
};

DeviceFormatStatusResponseData _$DeviceFormatStatusResponseDataFromJson(
  Map<String, dynamic> json,
) => DeviceFormatStatusResponseData(
  storageStatus: (json['storageStatus'] as List<dynamic>?)
      ?.map((e) => StorageMediumStatus.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DeviceFormatStatusResponseDataToJson(
  DeviceFormatStatusResponseData instance,
) => <String, dynamic>{'storageStatus': instance.storageStatus};

CloudStorageServiceDetail _$CloudStorageServiceDetailFromJson(
  Map<String, dynamic> json,
) => CloudStorageServiceDetail(
  userName: json['userName'] as String?,
  deviceSerial: json['deviceSerial'] as String?,
  channelNo: (json['channelNo'] as num?)?.toInt(),
  totalDays: (json['totalDays'] as num?)?.toInt(),
  status: (json['status'] as num?)?.toInt(),
  startTime: (json['startTime'] as num?)?.toInt(),
  expireTime: (json['expireTime'] as num?)?.toInt(),
);

Map<String, dynamic> _$CloudStorageServiceDetailToJson(
  CloudStorageServiceDetail instance,
) => <String, dynamic>{
  'userName': instance.userName,
  'deviceSerial': instance.deviceSerial,
  'channelNo': instance.channelNo,
  'totalDays': instance.totalDays,
  'status': instance.status,
  'startTime': instance.startTime,
  'expireTime': instance.expireTime,
};

CloudStorageInfo _$CloudStorageInfoFromJson(Map<String, dynamic> json) =>
    CloudStorageInfo(
      userName: json['userName'] as String?,
      deviceSerial: json['deviceSerial'] as String?,
      channelNo: (json['channelNo'] as num?)?.toInt(),
      totalDays: (json['totalDays'] as num?)?.toInt(),
      status: (json['status'] as num?)?.toInt(),
      validDays: (json['validDays'] as num?)?.toInt(),
      startTime: (json['startTime'] as num?)?.toInt(),
      expireTime: (json['expireTime'] as num?)?.toInt(),
      serviceDetail: json['serviceDetail'] == null
          ? null
          : CloudStorageServiceDetail.fromJson(
              json['serviceDetail'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$CloudStorageInfoToJson(CloudStorageInfo instance) =>
    <String, dynamic>{
      'userName': instance.userName,
      'deviceSerial': instance.deviceSerial,
      'channelNo': instance.channelNo,
      'totalDays': instance.totalDays,
      'status': instance.status,
      'validDays': instance.validDays,
      'startTime': instance.startTime,
      'expireTime': instance.expireTime,
      'serviceDetail': instance.serviceDetail?.toJson(),
    };

RamAccountPolicyStatement _$RamAccountPolicyStatementFromJson(
  Map<String, dynamic> json,
) => RamAccountPolicyStatement(
  permission: json['Permission'] as String?,
  resource: (json['Resource'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$RamAccountPolicyStatementToJson(
  RamAccountPolicyStatement instance,
) => <String, dynamic>{
  'Permission': instance.permission,
  'Resource': instance.resource,
};

RamAccountPolicy _$RamAccountPolicyFromJson(Map<String, dynamic> json) =>
    RamAccountPolicy(
      statement: (json['Statement'] as List<dynamic>?)
          ?.map(
            (e) =>
                RamAccountPolicyStatement.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$RamAccountPolicyToJson(RamAccountPolicy instance) =>
    <String, dynamic>{
      'Statement': instance.statement?.map((e) => e.toJson()).toList(),
    };

RamAccountInfo _$RamAccountInfoFromJson(Map<String, dynamic> json) =>
    RamAccountInfo(
      accountId: json['accountId'] as String,
      accountName: json['accountName'] as String?,
      appKey: json['appKey'] as String?,
      accountStatus: (json['accountStatus'] as num?)?.toInt(),
      policy: json['policy'] == null
          ? null
          : RamAccountPolicy.fromJson(json['policy'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RamAccountInfoToJson(RamAccountInfo instance) =>
    <String, dynamic>{
      'accountId': instance.accountId,
      'accountName': instance.accountName,
      'appKey': instance.appKey,
      'accountStatus': instance.accountStatus,
      'policy': instance.policy?.toJson(),
    };
