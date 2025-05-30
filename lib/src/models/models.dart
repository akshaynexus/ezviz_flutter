import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart'; // For json_serializable generator

@JsonSerializable()
class EzvizBaseResponse {
  final String code;
  final String msg;

  EzvizBaseResponse({required this.code, required this.msg});

  factory EzvizBaseResponse.fromJson(Map<String, dynamic> json) =>
      _$EzvizBaseResponseFromJson(json);
  Map<String, dynamic> toJson() => _$EzvizBaseResponseToJson(this);
}

@JsonSerializable(genericArgumentFactories: true)
class EzvizDataResponse<T> extends EzvizBaseResponse {
  final T? data;

  EzvizDataResponse({required super.code, required super.msg, this.data});

  // Need to handle T manually for fromJson if T is not a primitive or a JsonSerializable class
  factory EzvizDataResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return EzvizDataResponse<T>(
      code: json['code'] as String,
      msg: json['msg'] as String,
      data: json['data'] == null ? null : fromJsonT(json['data']),
    );
  }

  // toJson will also need manual handling if T is complex
  @override
  Map<String, dynamic> toJson() => {
    'code': code,
    'msg': msg,
    'data': data, // This might need a toJsonT function if T is complex
  };
}

@JsonSerializable()
class EzvizPageInfo {
  final int total;
  final int page;
  final int size;

  EzvizPageInfo({required this.total, required this.page, required this.size});

  factory EzvizPageInfo.fromJson(Map<String, dynamic> json) =>
      _$EzvizPageInfoFromJson(json);
  Map<String, dynamic> toJson() => _$EzvizPageInfoToJson(this);
}

@JsonSerializable(genericArgumentFactories: true)
class EzvizPagedResponse<T> extends EzvizBaseResponse {
  final List<T>? data;
  final EzvizPageInfo? page;

  EzvizPagedResponse({
    required super.code,
    required super.msg,
    this.data,
    this.page,
  });

  factory EzvizPagedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return EzvizPagedResponse<T>(
      code: json['code'] as String,
      msg: json['msg'] as String,
      data: (json['data'] as List<dynamic>?)?.map((e) => fromJsonT(e)).toList(),
      page: json['page'] == null
          ? null
          : EzvizPageInfo.fromJson(json['page'] as Map<String, dynamic>),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'code': code,
    'msg': msg,
    'data': data, // This might need a toJsonT function if T is complex
    'page': page?.toJson(),
  };
}

@JsonSerializable()
class TokenData {
  final String accessToken;
  final int expireTime;
  final String areaDomain;

  TokenData({
    required this.accessToken,
    required this.expireTime,
    required this.areaDomain,
  });

  factory TokenData.fromJson(Map<String, dynamic> json) =>
      _$TokenDataFromJson(json);
  Map<String, dynamic> toJson() => _$TokenDataToJson(this);
}

@JsonSerializable()
class DeviceInfo {
  final String deviceSerial;
  final String? deviceName;
  final String? deviceType; // Or model, based on different API responses
  final String? model; // Added to consolidate
  final int? status; // 0-Offline, 1-Online
  final int? defence; // 0-Disarm/Sleep, 1-Arm, 8-Home, 16-Away
  final int? isEncrypt; // 0-No, 1-Yes
  final String? deviceVersion;
  final String? updateTime;
  final int? alarmSoundMode;
  final int? offlineNotify;
  final String? wifiSsid;
  final String? timeZone;

  DeviceInfo({
    required this.deviceSerial,
    this.deviceName,
    this.deviceType,
    this.model,
    this.status,
    this.defence,
    this.isEncrypt,
    this.deviceVersion,
    this.updateTime,
    this.alarmSoundMode,
    this.offlineNotify,
    this.wifiSsid,
    this.timeZone,
  });

  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceInfoToJson(this);
}

@JsonSerializable()
class CameraInfo {
  final String deviceSerial;
  final int channelNo;
  final String? channelName;
  final int? status; // 0-Offline, 1-Online
  final String? isShared; // 1-Share by, 0-Unshared, 2-Share to
  final String? picUrl;
  final int? isEncrypt; // 0-No, 1-Yes
  final int? videoLevel; // 0-Fluent, 1-Equalization, 2-HD, 3-Super Definition
  final String? ipcSerial; // For NVR linked cameras
  final bool? relatedIpc;

  CameraInfo({
    required this.deviceSerial,
    required this.channelNo,
    this.channelName,
    this.status,
    this.isShared,
    this.picUrl,
    this.isEncrypt,
    this.videoLevel,
    this.ipcSerial,
    this.relatedIpc,
  });

  factory CameraInfo.fromJson(Map<String, dynamic> json) =>
      _$CameraInfoFromJson(json);
  Map<String, dynamic> toJson() => _$CameraInfoToJson(this);
}

@JsonSerializable()
class PlayAddress {
  final String id;
  final String url;
  final String expireTime;

  PlayAddress({required this.id, required this.url, required this.expireTime});

  factory PlayAddress.fromJson(Map<String, dynamic> json) =>
      _$PlayAddressFromJson(json);
  Map<String, dynamic> toJson() => _$PlayAddressToJson(this);
}

@JsonSerializable()
class CapturedPicture {
  final String picUrl;

  CapturedPicture({required this.picUrl});

  factory CapturedPicture.fromJson(Map<String, dynamic> json) =>
      _$CapturedPictureFromJson(json);
  Map<String, dynamic> toJson() => _$CapturedPictureToJson(this);
}

@JsonSerializable()
class DeviceStatusInfo {
  final int? privacyStatus;
  final int? pirStatus;
  final int? alarmSoundMode;
  final int? battryStatus; //sic
  final int? lockSignal;
  final int? diskNum;
  final String? diskState;
  final int? cloudType;
  final int? cloudStatus;
  final int? nvrDiskNum;
  final String? nvrDiskState;

  DeviceStatusInfo({
    this.privacyStatus,
    this.pirStatus,
    this.alarmSoundMode,
    this.battryStatus,
    this.lockSignal,
    this.diskNum,
    this.diskState,
    this.cloudType,
    this.cloudStatus,
    this.nvrDiskNum,
    this.nvrDiskState,
  });

  factory DeviceStatusInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceStatusInfoFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceStatusInfoToJson(this);
}

@JsonSerializable()
class TimezoneInfo {
  final String tzCode;
  final String tzValue;
  final String disPlayName; // sic - matching API doc

  TimezoneInfo({
    required this.tzCode,
    required this.tzValue,
    required this.disPlayName,
  });

  factory TimezoneInfo.fromJson(Map<String, dynamic> json) =>
      _$TimezoneInfoFromJson(json);
  Map<String, dynamic> toJson() => _$TimezoneInfoToJson(this);
}

@JsonSerializable()
class EzvizAlarmInfo {
  final String alarmId;
  final String? alarmName;
  final int alarmType;
  final int alarmTime; // Timestamp in milliseconds
  final int channelNo;
  final int isEncrypt; // 0-No, 1-Yes
  final int
  isChecked; // 0-Unread, 1-Read (Based on API doc for status: 0-Unread, 1-Read)
  final int? preTime;
  final int? delayTime;
  final String deviceSerial;
  final String? alarmPicUrl;
  // final List<dynamic>? relationAlarms; // Type needs clarification from API or further use case
  final String? customerType;
  final String? customerInfo;

  EzvizAlarmInfo({
    required this.alarmId,
    this.alarmName,
    required this.alarmType,
    required this.alarmTime,
    required this.channelNo,
    required this.isEncrypt,
    required this.isChecked,
    this.preTime,
    this.delayTime,
    required this.deviceSerial,
    this.alarmPicUrl,
    // this.relationAlarms,
    this.customerType,
    this.customerInfo,
  });

  factory EzvizAlarmInfo.fromJson(Map<String, dynamic> json) =>
      _$EzvizAlarmInfoFromJson(json);
  Map<String, dynamic> toJson() => _$EzvizAlarmInfoToJson(this);
}

@JsonSerializable()
class DeviceSwitchStatus {
  final String deviceSerial;
  final int channelNo;
  final int enable; // 0-Disable, 1-Enable

  DeviceSwitchStatus({
    required this.deviceSerial,
    required this.channelNo,
    required this.enable,
  });

  factory DeviceSwitchStatus.fromJson(Map<String, dynamic> json) =>
      _$DeviceSwitchStatusFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceSwitchStatusToJson(this);
}

@JsonSerializable()
class DeviceDefencePlan {
  final String startTime; // e.g., "23:20"
  final String stopTime; // e.g., "23:21", "n00:00" for next day
  final String period; // e.g., "0,1,6" (Mon, Tue, Sun)
  final int enable; // 0-Disable, 1-Enable

  DeviceDefencePlan({
    required this.startTime,
    required this.stopTime,
    required this.period,
    required this.enable,
  });

  factory DeviceDefencePlan.fromJson(Map<String, dynamic> json) =>
      _$DeviceDefencePlanFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceDefencePlanToJson(this);
}

@JsonSerializable()
class PirAreaConfig {
  final String deviceSerial;
  final int channelNo;
  final int rows;
  final int columns;
  final List<int> area; // List of integers representing selected areas

  PirAreaConfig({
    required this.deviceSerial,
    required this.channelNo,
    required this.rows,
    required this.columns,
    required this.area,
  });

  factory PirAreaConfig.fromJson(Map<String, dynamic> json) =>
      _$PirAreaConfigFromJson(json);
  Map<String, dynamic> toJson() => _$PirAreaConfigToJson(this);
}

@JsonSerializable()
class ChimeConfig {
  final String deviceSerial;
  final int channelNo;
  final int type; // 1-mechanical, 2-electronic, 3-none
  final int duration;

  ChimeConfig({
    required this.deviceSerial,
    required this.channelNo,
    required this.type,
    required this.duration,
  });

  factory ChimeConfig.fromJson(Map<String, dynamic> json) =>
      _$ChimeConfigFromJson(json);
  Map<String, dynamic> toJson() => _$ChimeConfigToJson(this);
}

@JsonSerializable()
class DeviceLanguage {
  final String language;

  DeviceLanguage({required this.language});

  factory DeviceLanguage.fromJson(Map<String, dynamic> json) =>
      _$DeviceLanguageFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceLanguageToJson(this);
}

@JsonSerializable()
class DeviceCapability {
  // The 'data' field in the API response is a complex object with many keys.
  // Representing it as Map<String, dynamic> for flexibility.
  // Refer to API documentation (section "Device capability set description") for specific keys.
  final Map<String, dynamic> data;

  DeviceCapability({required this.data});

  factory DeviceCapability.fromJson(Map<String, dynamic> json) =>
      _$DeviceCapabilityFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceCapabilityToJson(this);
}

@JsonSerializable()
class DetectorInfo {
  final String detectorSerial;
  final String? detectorType;
  final int? detectorState; // 0-No, 1-Yes (connects to A1)
  final String? detectorTypeName;
  final String? location; // Custom name / edited name
  final int? zfStatus; // Zone fault: 0-recover, 1-alarm
  final int? uvStatus; // Battery undervoltage: 0-recover, 1-alarm
  final int? iwcStatus; // Wireless Interference: 0-recover, 1-alarm
  final int? olStatus; // Offline: 0-recover, 1-alarm
  final int? atHomeEnable; // Enable stay mode: 0-disable, 1-enable
  final int? outerEnable; // Enable away mode: 0-disable, 1-enable
  final int? sleepEnable; // Enable sleeping mode: 0-disable, 1-enable
  final String? updateTime;

  DetectorInfo({
    required this.detectorSerial,
    this.detectorType,
    this.detectorState,
    this.detectorTypeName,
    this.location,
    this.zfStatus,
    this.uvStatus,
    this.iwcStatus,
    this.olStatus,
    this.atHomeEnable,
    this.outerEnable,
    this.sleepEnable,
    this.updateTime,
  });

  factory DetectorInfo.fromJson(Map<String, dynamic> json) =>
      _$DetectorInfoFromJson(json);
  Map<String, dynamic> toJson() => _$DetectorInfoToJson(this);
}

enum DetectorType {
  @JsonValue("V")
  videoDevice,
  @JsonValue("I")
  alarmInDevice,
  @JsonValue("O")
  alarmOutDevice,
  @JsonValue("PIR")
  pir,
  @JsonValue("FIRE")
  fire,
  @JsonValue("MAGNETOMETER")
  magnetometer,
  @JsonValue("GAS")
  gas,
  @JsonValue("WATERLOGGING")
  waterlogging,
  @JsonValue("CALLHELP")
  callhelp,
  @JsonValue("TELECONTROL")
  telecontrol,
  @JsonValue("ALERTOR")
  alertor,
  @JsonValue("KEYBOARD")
  keyboard,
  @JsonValue("CURTAIN")
  curtain,
  @JsonValue("MOVE_MAGNETOMETER")
  moveMagnetometer,
  unknown, // For any types not listed or future additions
}

// Based on the API documentation, not all codes might be relevant for direct use
// but listing some common ones. Users can also pass integer codes directly.
enum EzvizAlarmType {
  all(-1),
  pirEvent(10000),
  emergencyButtonEvent(10001),
  motionDetection(10002),
  babyCry(10003),
  magneticContact(10004),
  smoke(10005),
  combustibleGas(10006),
  waterLeak(10008),
  emergencyButton(10009),
  pir(10010),
  videoTempering(10011), // sic (tempering vs tampering)
  videoLoss(10012),
  lineCrossing(10013),
  intrusion(10014),
  faceDetectionEvent(10015),
  doorBellRing(10016)
  // Add more as needed or refer to the comprehensive list in API docs
  ;

  const EzvizAlarmType(this.code);
  final int code;
}

@JsonSerializable()
class BindableIpcInfo {
  final String deviceSerial; // IPC serial
  final int channelNo;
  final String? cameraName; // IPC Name

  BindableIpcInfo({
    required this.deviceSerial,
    required this.channelNo,
    this.cameraName,
  });

  factory BindableIpcInfo.fromJson(Map<String, dynamic> json) =>
      _$BindableIpcInfoFromJson(json);
  Map<String, dynamic> toJson() => _$BindableIpcInfoToJson(this);
}

@JsonSerializable()
class LinkedIpcInfo {
  // From API: deviceSerial is for the A1 hub, ipcSerial is the linked IPC.
  // However, the response example shows detectorSerial and ipcSerial.
  // Assuming detectorSerial is the A1 hub's serial for this context.
  final String detectorSerial; // A1 Hub serial
  final String ipcSerial; // Linked IPC serial

  LinkedIpcInfo({required this.detectorSerial, required this.ipcSerial});

  factory LinkedIpcInfo.fromJson(Map<String, dynamic> json) =>
      _$LinkedIpcInfoFromJson(json);
  Map<String, dynamic> toJson() => _$LinkedIpcInfoToJson(this);
}

@JsonSerializable()
class FillLightMode {
  final String deviceSerial;
  final int graphicType; // 0-black and white, 1-full color, 2-smart
  final int? luminance; // Brightness (docs say fixed 100)
  final int? duration; // Automatic light on duration (docs say fixed 5 seconds)

  FillLightMode({
    required this.deviceSerial,
    required this.graphicType,
    this.luminance,
    this.duration,
  });

  factory FillLightMode.fromJson(Map<String, dynamic> json) =>
      _$FillLightModeFromJson(json);
  Map<String, dynamic> toJson() => _$FillLightModeToJson(this);
}

@JsonSerializable()
class DeviceGeneralSwitchStatus {
  final String subSerial; // Or deviceSerial, needs clarification from API use
  final int type; // Switch type, e.g., 301 for Light flicker
  final int enable; // 0-Off, 1-On

  DeviceGeneralSwitchStatus({
    required this.subSerial,
    required this.type,
    required this.enable,
  });

  factory DeviceGeneralSwitchStatus.fromJson(Map<String, dynamic> json) =>
      _$DeviceGeneralSwitchStatusFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceGeneralSwitchStatusToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TimePlanEntry {
  final String beginTime; // "HH:MM"
  final String endTime; // "HH:MM"
  final String
  eventArg; // "mode:0" (0:Power saving, 1:Performance, 2:Normal, 3:Super power saving)

  TimePlanEntry({
    required this.beginTime,
    required this.endTime,
    required this.eventArg,
  });

  factory TimePlanEntry.fromJson(Map<String, dynamic> json) =>
      _$TimePlanEntryFromJson(json);
  Map<String, dynamic> toJson() => _$TimePlanEntryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class WeekPlanEntry {
  final String weekDay; // "0,1" (0:Sun, 1:Mon, ...)
  final List<TimePlanEntry> timePlan;

  WeekPlanEntry({required this.weekDay, required this.timePlan});

  factory WeekPlanEntry.fromJson(Map<String, dynamic> json) =>
      _$WeekPlanEntryFromJson(json);
  Map<String, dynamic> toJson() => _$WeekPlanEntryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DeviceWorkingModePlan {
  final String subSerial;
  final int? subType; // Meaning of subType is not specified in this doc part
  final List<WeekPlanEntry> weekPlans;

  DeviceWorkingModePlan({
    required this.subSerial,
    this.subType,
    required this.weekPlans,
  });

  factory DeviceWorkingModePlan.fromJson(Map<String, dynamic> json) =>
      _$DeviceWorkingModePlanFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceWorkingModePlanToJson(this);
}

@JsonSerializable()
class AlarmSoundMode {
  final String deviceSerial;
  final int alarmSoundMode; // 0-Short call, 1-Long call, 2-Mute

  AlarmSoundMode({required this.deviceSerial, required this.alarmSoundMode});

  factory AlarmSoundMode.fromJson(Map<String, dynamic> json) =>
      _$AlarmSoundModeFromJson(json);
  Map<String, dynamic> toJson() => _$AlarmSoundModeToJson(this);
}

@JsonSerializable()
class DetectionAreaConfig {
  final String deviceSerial;
  final int channelNo;
  final int rows;
  final int columns;
  final List<int> area;

  DetectionAreaConfig({
    required this.deviceSerial,
    required this.channelNo,
    required this.rows,
    required this.columns,
    required this.area,
  });

  factory DetectionAreaConfig.fromJson(Map<String, dynamic> json) =>
      _$DetectionAreaConfigFromJson(json);
  Map<String, dynamic> toJson() => _$DetectionAreaConfigToJson(this);
}

@JsonSerializable()
class StorageMediumStatus {
  final int index;
  final String? name;
  final int status; // 0-normal, 1-incorrect, 2-not formatted, 3-formatting
  final String? formattingRate;
  final int? capacity;

  StorageMediumStatus({
    required this.index,
    this.name,
    required this.status,
    this.formattingRate,
    this.capacity,
  });

  factory StorageMediumStatus.fromJson(Map<String, dynamic> json) =>
      _$StorageMediumStatusFromJson(json);
  Map<String, dynamic> toJson() => _$StorageMediumStatusToJson(this);
}

@JsonSerializable()
class DeviceFormatStatusResponseData {
  final List<StorageMediumStatus>? storageStatus;

  DeviceFormatStatusResponseData({this.storageStatus});

  factory DeviceFormatStatusResponseData.fromJson(Map<String, dynamic> json) =>
      _$DeviceFormatStatusResponseDataFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceFormatStatusResponseDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CloudStorageServiceDetail {
  final String? userName;
  final String? deviceSerial;
  final int? channelNo;
  final int? totalDays;
  final int? status; // 0: Not activated, (other values from main object apply)
  final int? startTime; // Timestamp ms
  final int? expireTime; // Timestamp ms

  CloudStorageServiceDetail({
    this.userName,
    this.deviceSerial,
    this.channelNo,
    this.totalDays,
    this.status,
    this.startTime,
    this.expireTime,
  });

  factory CloudStorageServiceDetail.fromJson(Map<String, dynamic> json) =>
      _$CloudStorageServiceDetailFromJson(json);
  Map<String, dynamic> toJson() => _$CloudStorageServiceDetailToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CloudStorageInfo {
  final String? userName;
  final String? deviceSerial;
  final int? channelNo;
  final int? totalDays;
  final int?
  status; // -2: Not supported, -1: Disabled, 0: Not activated, 1: Activated, 2: Expired
  final int? validDays;
  final int? startTime; // Timestamp ms
  final int? expireTime; // Timestamp ms
  final CloudStorageServiceDetail? serviceDetail;

  CloudStorageInfo({
    this.userName,
    this.deviceSerial,
    this.channelNo,
    this.totalDays,
    this.status,
    this.validDays,
    this.startTime,
    this.expireTime,
    this.serviceDetail,
  });

  factory CloudStorageInfo.fromJson(Map<String, dynamic> json) =>
      _$CloudStorageInfoFromJson(json);
  Map<String, dynamic> toJson() => _$CloudStorageInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RamAccountPolicyStatement {
  @JsonKey(name: 'Permission')
  final String? permission;
  @JsonKey(name: 'Resource')
  final List<String>? resource;

  RamAccountPolicyStatement({this.permission, this.resource});

  factory RamAccountPolicyStatement.fromJson(Map<String, dynamic> json) =>
      _$RamAccountPolicyStatementFromJson(json);
  Map<String, dynamic> toJson() => _$RamAccountPolicyStatementToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RamAccountPolicy {
  @JsonKey(name: 'Statement')
  final List<RamAccountPolicyStatement>? statement;

  RamAccountPolicy({this.statement});

  factory RamAccountPolicy.fromJson(Map<String, dynamic> json) =>
      _$RamAccountPolicyFromJson(json);
  Map<String, dynamic> toJson() => _$RamAccountPolicyToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RamAccountInfo {
  final String accountId;
  final String? accountName;
  final String? appKey;
  final int? accountStatus; // 0 is off, 1 is on
  final RamAccountPolicy? policy;

  RamAccountInfo({
    required this.accountId,
    this.accountName,
    this.appKey,
    this.accountStatus,
    this.policy,
  });

  factory RamAccountInfo.fromJson(Map<String, dynamic> json) =>
      _$RamAccountInfoFromJson(json);
  Map<String, dynamic> toJson() => _$RamAccountInfoToJson(this);
}
