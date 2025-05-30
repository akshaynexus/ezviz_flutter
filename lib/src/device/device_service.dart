import '../ezviz_client.dart';

class DeviceService {
  final EzvizClient _client;

  DeviceService(this._client);

  Future<Map<String, dynamic>> addDevice(
    String deviceSerial,
    String validateCode,
  ) async {
    return _client.post('/api/lapp/device/add', {
      'deviceSerial': deviceSerial,
      'validateCode': validateCode,
    });
  }

  Future<Map<String, dynamic>> deleteDevice(String deviceSerial) async {
    return _client.post('/api/lapp/device/delete', {
      'deviceSerial': deviceSerial,
    });
  }

  Future<Map<String, dynamic>> editDeviceName(
    String deviceSerial,
    String deviceName,
  ) async {
    return _client.post('/api/lapp/device/name/update', {
      'deviceSerial': deviceSerial,
      'deviceName': deviceName,
    });
  }

  Future<Map<String, dynamic>> capturePicture(
    String deviceSerial, {
    int channelNo = 1,
    int? quality,
  }) async {
    final body = <String, dynamic>{
      'deviceSerial': deviceSerial,
      'channelNo': channelNo,
    };
    if (quality != null) {
      body['quality'] = quality;
    }
    return _client.post('/api/lapp/device/capture', body);
  }

  // Methods from "Device Information Search" section
  Future<Map<String, dynamic>> getDeviceList({
    int pageStart = 0,
    int pageSize = 10,
  }) async {
    return _client.post('/api/lapp/device/list', {
      'pageStart': pageStart,
      'pageSize': pageSize,
    });
  }

  Future<Map<String, dynamic>> getDeviceInfo(String deviceSerial) async {
    return _client.post('/api/lapp/device/info', {
      'deviceSerial': deviceSerial,
    });
  }

  Future<Map<String, dynamic>> getCameraList({
    int pageStart = 0,
    int pageSize = 10,
  }) async {
    return _client.post('/api/lapp/camera/list', {
      'pageStart': pageStart,
      'pageSize': pageSize,
    });
  }

  Future<Map<String, dynamic>> getDeviceStatus(
    String deviceSerial, {
    int channelNo = 1,
  }) async {
    return _client.post('/api/lapp/device/status/get', {
      'deviceSerial': deviceSerial,
      'channel': channelNo,
    });
  }

  Future<Map<String, dynamic>> getDeviceChannelInfo(String deviceSerial) async {
    return _client.post('/api/lapp/device/camera/list', {
      // Note: API doc says /api/lapp/device/camera/list for this one too
      'deviceSerial': deviceSerial,
    });
  }

  // Methods from "Device Function Status Control"
  Future<Map<String, dynamic>> setDefenceMode(
    String deviceSerial,
    int isDefence,
  ) async {
    return _client.post('/api/lapp/device/defence/set', {
      'deviceSerial': deviceSerial,
      'isDefence': isDefence,
    });
  }

  Future<Map<String, dynamic>> disableEncryption(
    String deviceSerial,
    String validateCode,
  ) async {
    return _client.post('/api/lapp/device/encrypt/off', {
      'deviceSerial': deviceSerial,
      'validateCode': validateCode,
    });
  }

  Future<Map<String, dynamic>> enableEncryption(String deviceSerial) async {
    return _client.post('/api/lapp/device/encrypt/on', {
      'deviceSerial': deviceSerial,
    });
  }

  Future<Map<String, dynamic>> getTimezoneList({String? language}) async {
    final body = <String, dynamic>{};
    if (language != null) body['language'] = language;
    // API endpoint from docs: {areaDomain}/api/lapp/timezone/list
    return _client.post('/api/lapp/timezone/list', body);
  }

  Future<Map<String, dynamic>> setDeviceTimezone(
    String deviceSerial,
    String timezone, { // This is tzCode from timezone list
    int? timeFormat, // 0: YYYY-MM-DD, 1: MM-DD-YYYY, 2: DD-MM-YYYY
    bool? daylightSaving, // 0-not open, 1-open
  }) async {
    final body = <String, dynamic>{
      'deviceSerial': deviceSerial,
      'timezone': timezone,
    };
    if (timeFormat != null) body['timeFormat'] = timeFormat;
    if (daylightSaving != null) body['daylightSaving'] = daylightSaving ? 1 : 0;
    return _client.post('/api/lapp/device/timezone/set', body);
  }

  // --- Audio Prompt ---
  Future<Map<String, dynamic>> getAudioPromptStatus(String deviceSerial) async {
    return _client.post('/api/lapp/device/sound/switch/status', {
      'deviceSerial': deviceSerial,
    });
  }

  Future<Map<String, dynamic>> setAudioPromptStatus(
    String deviceSerial,
    bool enable, {
    int? channelNo,
  }) async {
    final body = <String, dynamic>{
      'deviceSerial': deviceSerial,
      'enable': enable ? 1 : 0,
    };
    if (channelNo != null) body['channelNo'] = channelNo;
    return _client.post('/api/lapp/device/sound/switch/set', body);
  }

  // --- Video Tampering ---
  Future<Map<String, dynamic>> getVideoTamperingStatus(
    String deviceSerial,
  ) async {
    return _client.post('/api/lapp/device/scene/switch/status', {
      'deviceSerial': deviceSerial,
    });
  }

  Future<Map<String, dynamic>> setVideoTamperingStatus(
    String deviceSerial,
    bool enable, {
    int? channelNo,
  }) async {
    final body = <String, dynamic>{
      'deviceSerial': deviceSerial,
      'enable': enable ? 1 : 0,
    };
    if (channelNo != null) body['channelNo'] = channelNo;
    return _client.post('/api/lapp/device/scene/switch/set', body);
  }

  // --- Sound Source Positioning ---
  Future<Map<String, dynamic>> getSoundSourcePositioningStatus(
    String deviceSerial,
  ) async {
    // Note: API doc for GET shows /api/lapp/device/scene/switch/status for SSL too, which seems like a doc error.
    // Assuming it should be /api/lapp/device/ssl/switch/status as per the SET endpoint and section name.
    return _client.post('/api/lapp/device/ssl/switch/status', {
      'deviceSerial': deviceSerial,
    });
  }

  Future<Map<String, dynamic>> setSoundSourcePositioningStatus(
    String deviceSerial,
    bool enable, {
    int? channelNo,
  }) async {
    final body = <String, dynamic>{
      'deviceSerial': deviceSerial,
      'enable': enable ? 1 : 0,
    };
    if (channelNo != null) body['channelNo'] = channelNo;
    // Corrected endpoint based on API doc section name (1.9 Set Sound Source Positioning Status)
    return _client.post('/api/lapp/device/ssl/switch/set', body);
  }

  // --- Defence Plan (Arming/Disarming Schedule) ---
  Future<Map<String, dynamic>> getDefencePlan(
    String deviceSerial, {
    int? channelNo,
  }) async {
    final body = <String, dynamic>{'deviceSerial': deviceSerial};
    if (channelNo != null) body['channelNo'] = channelNo;
    return _client.post('/api/lapp/device/defence/plan/get', body);
  }

  Future<Map<String, dynamic>> setDefencePlan(
    String deviceSerial,
    bool enable,
    String startTime, // "HH:MM"
    String stopTime, // "HH:MM" or "nHH:MM" for next day
    String period, { // "0,1,2,3,4,5,6"
    int? channelNo,
  }) async {
    final body = <String, dynamic>{
      'deviceSerial': deviceSerial,
      'enable': enable ? 1 : 0,
      'startTime': startTime,
      'stopTime': stopTime,
      'period': period,
    };
    if (channelNo != null) body['channelNo'] = channelNo;
    return _client.post('/api/lapp/device/defence/plan/set', body);
  }

  // --- Microphone Status ---
  Future<Map<String, dynamic>> getMicrophoneStatus(String deviceSerial) async {
    // Note: API response for this is a list, but typically a single device/channel status is expected.
    // The response `data` field is a List<DeviceSwitchStatus>.
    return _client.post('/api/lapp/camera/video/sound/status', {
      'deviceSerial': deviceSerial,
    });
  }

  Future<Map<String, dynamic>> setMicrophoneStatus(
    String deviceSerial,
    bool enable,
    // channelNo is not listed for set, but often present for camera specific settings.
    // Assuming it might be needed or API applies to device level if channelNo not provided.
  ) async {
    return _client.post('/api/lapp/camera/video/sound/set', {
      'deviceSerial': deviceSerial,
      'enable': enable ? 1 : 0,
    });
  }

  // --- PIR Area Configuration ---
  Future<Map<String, dynamic>> getPirAreaConfiguration(
    String deviceSerial, {
    int? channelNo,
  }) async {
    final body = <String, dynamic>{'deviceSerial': deviceSerial};
    if (channelNo != null) body['channelNo'] = channelNo;
    return _client.post('/api/lapp/device/pir/get', body);
  }

  Future<Map<String, dynamic>> setPirAreaConfiguration(
    String deviceSerial,
    String area, { // Refer to API docs for format, e.g., "1,3,6,7"
    int? channelNo,
  }) async {
    final body = <String, dynamic>{'deviceSerial': deviceSerial, 'area': area};
    if (channelNo != null) body['channelNo'] = channelNo;
    return _client.post('/api/lapp/device/pir/set', body);
  }

  // --- Chime Configuration ---
  Future<Map<String, dynamic>> getChimeType(
    String deviceSerial, {
    int? channelNo,
  }) async {
    final body = <String, dynamic>{'deviceSerial': deviceSerial};
    if (channelNo != null) body['channelNo'] = channelNo;
    // Corrected endpoint based on API doc section name (1.17 Get chime type)
    return _client.post('/api/lapp/device/chime/get', body);
  }

  Future<Map<String, dynamic>> setChimeType(
    String deviceSerial,
    int type, // 1-mechanical, 2-electronic, 3-none
    int duration, {
    int? channelNo,
  }) async {
    final body = <String, dynamic>{
      'deviceSerial': deviceSerial,
      'type': type,
      'duration': duration,
    };
    if (channelNo != null) body['channelNo'] = channelNo;
    return _client.post('/api/lapp/device/chime/set', body);
  }

  // --- Infrared Configuration ---
  Future<Map<String, dynamic>> getInfraredStatus(
    String deviceSerial, {
    int? channelNo,
  }) async {
    final body = <String, dynamic>{'deviceSerial': deviceSerial};
    if (channelNo != null) body['channelNo'] = channelNo;
    return _client.post('/api/lapp/device/infrared/switch/get', body);
  }

  Future<Map<String, dynamic>> setInfraredStatus(
    String deviceSerial,
    bool enable, {
    int? channelNo,
  }) async {
    final body = <String, dynamic>{
      'deviceSerial': deviceSerial,
      'enable': enable ? 1 : 0,
    };
    if (channelNo != null) body['channelNo'] = channelNo;
    return _client.post('/api/lapp/device/infrared/switch/set', body);
  }

  // --- Device Capability ---
  Future<Map<String, dynamic>> getDeviceCapability(
    String deviceSerial, {
    String? channelNo, // API doc shows String, but usually int
  }) async {
    final body = <String, dynamic>{'deviceSerial': deviceSerial};
    if (channelNo != null) body['channelNo'] = channelNo;
    return _client.post('/api/lapp/device/capacity', body);
  }

  // --- Device Language ---
  Future<Map<String, dynamic>> getDeviceLanguage(String deviceSerial) async {
    return _client.post('/api/lapp/device/language/get', {
      'deviceSerial': deviceSerial,
    });
  }

  Future<Map<String, dynamic>> setDeviceLanguage(
    String deviceSerial,
    String language, // e.g., "ENGLISH", "GERMAN"
  ) async {
    return _client.post('/api/lapp/device/language/set', {
      'deviceSerial': deviceSerial,
      'language': language,
    });
  }

  // --- V3 APIs ---

  // -- Fill Light Mode --
  Future<Map<String, dynamic>> getFillLightMode(String deviceSerial) async {
    // V3 API - GET request, params in header for accessToken, deviceSerial
    // Assuming _client.post can handle GET by passing empty body or client needs a get method
    // For now, structuring as a POST to fit existing client, this may need EzvizClient update
    return _client.post('/api/v3/device/fillLight/mode/get', {
      'deviceSerial': deviceSerial,
      // accessToken is handled by the client
    });
  }

  Future<Map<String, dynamic>> setFillLightMode(
    String deviceSerial,
    String mode, // "0"-B&W, "1"-FullColor, "2"-Smart
  ) async {
    // V3 API - POST request, params in header & query
    // Query param `mode`
    // This might require updating EzvizClient to handle query parameters separately
    // or embedding them in the path if http.post supports that.
    return _client.post('/api/v3/device/fillLight/mode/set?mode=$mode', {
      'deviceSerial': deviceSerial,
      // accessToken is handled by the client
      // 'mode': mode, // This should be a query parameter, not in body for typical POST
    });
  }

  // -- Device Switch Status --
  Future<Map<String, dynamic>> getDeviceSwitchStatus(
    String deviceSerial,
    String type, // e.g., "301" for Light flicker switch
  ) async {
    // V3 API - GET request
    // Query param `type`
    return _client.post('/api/v3/device/switchStatus/get?type=$type', {
      'deviceSerial': deviceSerial,
      // 'type': type, // Query parameter
    });
  }

  Future<Map<String, dynamic>> setDeviceSwitchStatus(
    String deviceSerial,
    String type, // e.g., "301"
    bool enable,
  ) async {
    // V3 API - POST request
    // Query params `type`, `enable`
    return _client.post(
      '/api/v3/device/switchStatus/set?type=$type&enable=${enable ? 1 : 0}',
      {'deviceSerial': deviceSerial},
    );
  }

  // -- Device Working Mode Plan --
  Future<Map<String, dynamic>> getDeviceWorkingModePlan(
    String deviceSerial,
  ) async {
    return _client.post('/api/v3/device/timing/plan/get', {
      'deviceSerial': deviceSerial,
    });
  }

  Future<Map<String, dynamic>> setDeviceWorkingModePlan(
    String deviceSerial,
    bool enable,
    String startTime, // "HH:MM"
    String endTime, // "HH:MM"
    String week, { // "0,1,2,3,4,5,6"
    String? eventArg, // "mode:0" (0:Power saving, 1:Performance, ...)
  }) async {
    final body = <String, dynamic>{
      'deviceSerial':
          deviceSerial, // This should be in header as per doc, client handles
      'enable': enable ? '1' : '0',
      'startTime': startTime,
      'endTime': endTime,
      'week': week,
    };
    if (eventArg != null) body['eventArg'] = eventArg;
    // API doc says body for these params, not query
    return _client.post('/api/v3/device/timing/plan/set', body);
  }

  // -- Alarm Sound Enablement --
  Future<Map<String, dynamic>> getAlarmSoundEnabled(String deviceSerial) async {
    return _client.post('/api/v3/device/alarmSound/enabled/get', {
      'deviceSerial': deviceSerial,
    });
  }

  Future<Map<String, dynamic>> setAlarmSoundEnabled(
    String deviceSerial,
    String type, // "0"-Short, "1"-Long, "2"-Mute
  ) async {
    return _client.post('/api/v3/device/alarmSound/enabled/set?type=$type', {
      'deviceSerial': deviceSerial,
    });
  }

  // -- Detection Area --
  Future<Map<String, dynamic>> getDetectionArea(
    String deviceSerial,
    String channelNo, // API doc shows string for channelNo here
  ) async {
    return _client.post('/api/v3/device/motion/detect/get', {
      'deviceSerial': deviceSerial,
      'channelNo': channelNo,
    });
  }

  Future<Map<String, dynamic>> setDetectionArea(
    String deviceSerial,
    String channelNo, // API doc shows string
    String area, // e.g., "8,8,8"
  ) async {
    return _client.post('/api/v3/device/motion/detect/set?area=$area', {
      'deviceSerial': deviceSerial,
      'channelNo': channelNo,
      // 'area': area, // Query param
    });
  }

  // -- Play Ringtone --
  Future<Map<String, dynamic>> playRingtone(
    String deviceSerial,
    String voiceIndex, { // e.g., "200"-Beep, "201"-Alarm, "202"-Mute
    String? volume, // "1"-"100", defaults to "1"
  }) async {
    String path = '/api/v3/device/audition?voiceIndex=$voiceIndex';
    if (volume != null) {
      path += '&volume=$volume';
    }
    return _client.post(path, {'deviceSerial': deviceSerial});
  }

  // -- Device Formatting --
  Future<Map<String, dynamic>> getDeviceFormattingStatus(
    String deviceSerial,
  ) async {
    // V3 API - GET request
    return _client.post('/api/v3/device/format/status', {
      'deviceSerial': deviceSerial,
    });
  }

  Future<Map<String, dynamic>> formatDeviceDisk(
    String deviceSerial,
    String diskIndex,
  ) async {
    // V3 API - PUT request. EzvizClient.post might not work directly.
    // This will likely require EzvizClient to be updated to support PUT requests
    // and potentially different ways of passing parameters (e.g., query vs body for PUT).
    return _client.post('/api/v3/device/format/disk?diskIndex=$diskIndex', {
      'deviceSerial': deviceSerial,
      // 'diskIndex': diskIndex // Query parameter
    });
  }
}
