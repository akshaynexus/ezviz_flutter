import '../ezviz_client.dart';
// import '../models/models.dart'; // Will be needed for response parsing

enum DetectorSafeMode {
  stay, // 0
  away, // 1
  sleeping, // 2
}

class DetectorService {
  final EzvizClient _client;

  DetectorService(this._client);

  Future<Map<String, dynamic>> getDetectorList(String deviceSerial) async {
    return _client.post('/api/lapp/detector/list', {
      'deviceSerial': deviceSerial,
    });
  }

  Future<Map<String, dynamic>> setDetectorStatus(
    String deviceSerial, // A1 Hub serial
    String detectorSerial, // Actual detector serial
    DetectorSafeMode safeMode,
    bool enable,
  ) async {
    return _client.post('/api/lapp/detector/status/set', {
      'deviceSerial': deviceSerial,
      'detectorSerial': detectorSerial,
      'safeMode': safeMode.index,
      'enable': enable ? 1 : 0,
    });
  }

  Future<Map<String, dynamic>> deleteDetector(
    String deviceSerial, // A1 Hub serial
    String detectorSerial, // Actual detector serial
  ) async {
    return _client.post('/api/lapp/detector/delete', {
      'deviceSerial': deviceSerial,
      'detectorSerial': detectorSerial,
    });
  }

  Future<Map<String, dynamic>> getBindableIpcList(String deviceSerial) async {
    // deviceSerial here is the A1 Hub serial
    // Response structure not fully detailed yet, likely a list of IPCs.
    return _client.post('/api/lapp/detector/ipc/list/bindable', {
      'deviceSerial': deviceSerial,
    });
  }

  Future<Map<String, dynamic>> getLinkedIpcList(
    String deviceSerial, // A1 Hub serial
    String detectorSerial, // Actual detector serial
  ) async {
    return _client.post('/api/lapp/detector/ipc/list/bind', {
      'deviceSerial': deviceSerial,
      'detectorSerial': detectorSerial,
    });
  }

  Future<Map<String, dynamic>> setIpcLinkage(
    String deviceSerial, // A1 Hub serial
    String detectorSerial,
    String ipcSerial,
    bool bind, // true to bind (operation=1), false to delete (operation=0)
  ) async {
    return _client.post('/api/lapp/detector/ipc/relation/set', {
      'deviceSerial': deviceSerial,
      'detectorSerial': detectorSerial,
      'ipcSerial': ipcSerial,
      'operation': bind ? 1 : 0,
    });
  }

  Future<Map<String, dynamic>> editDetectorName(
    String deviceSerial, // A1 Hub serial
    String detectorSerial,
    String newName,
  ) async {
    return _client.post('/api/lapp/detector/name/change', {
      'deviceSerial': deviceSerial,
      'detectorSerial': detectorSerial,
      'newName': newName,
    });
  }

  Future<Map<String, dynamic>> clearDeviceAlarms(String deviceSerial) async {
    // A1 Hub serial
    return _client.post('/api/lapp/detector/cancelAlarm', {
      'deviceSerial': deviceSerial,
    });
  }

  Future<Map<String, dynamic>> addDetector(
    String deviceSerial, // A1 Hub serial
    String detectorToAddSerial, // Serial of detector to add
    String
    detectorType, // e.g., "PIR", "FIRE" - see DetectorType enum or API docs
    String detectorCode, // Verification code, API says "must enter ABCDEF"
  ) async {
    return _client.post('/api/lapp/detector/add', {
      'deviceSerial': deviceSerial,
      'detectorSerial': detectorToAddSerial,
      'detectorType': detectorType,
      'detectorCode': detectorCode,
    });
  }

  // Other methods like getLinkedIpcList, etc. will be added here.
}
