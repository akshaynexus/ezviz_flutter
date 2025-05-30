import '../ezviz_client.dart';

enum PtzCommand {
  up,
  down,
  left,
  right,
  upLeft,
  downLeft,
  upRight,
  downRight,
  zoomIn,
  zoomOut,
  focusNear,
  focusFar,
}

enum PtzMirrorCommand {
  upDown, // 0
  leftRight, // 1
  center, // 2
}

enum PtzSpeed {
  slow, // 0
  medium, // 1
  fast, // 2
}

class PtzService {
  final EzvizClient _client;

  PtzService(this._client);

  Future<Map<String, dynamic>> _ptzControl(
    String endpoint,
    String deviceSerial,
    int channelNo,
    Map<String, dynamic> additionalParams,
  ) async {
    final body = <String, dynamic>{
      'deviceSerial': deviceSerial,
      'channelNo': channelNo,
      ...additionalParams,
    };
    return _client.post(endpoint, body);
  }

  Future<Map<String, dynamic>> startPtz(
    String deviceSerial,
    int channelNo, {
    required PtzCommand direction,
    required PtzSpeed speed,
  }) async {
    return _ptzControl('/api/lapp/device/ptz/start', deviceSerial, channelNo, {
      'direction': direction.index,
      'speed': speed.index,
    });
  }

  Future<Map<String, dynamic>> stopPtz(
    String deviceSerial,
    int channelNo, {
    PtzCommand? direction,
  }) async {
    final params = <String, dynamic>{};
    // The API doc specifies direction as a required parameter for stop.
    // If the API were to allow stopping all movements without specifying direction, this check would be different.
    if (direction != null) {
      params['direction'] = direction.index;
    } else {
      // As per API docs, direction is mandatory for stop. Throwing an error or handling as per library design choice.
      // For now, let's assume the API doc is strict and direction must be provided.
      // Or, if the intent is to stop a specific movement, then direction is indeed necessary.
      // If the API implies a general stop without direction, this part needs adjustment.
      // Based on the provided doc, direction IS required for stop.
      // We will proceed assuming it's always provided by the caller for now.
      // If an empty param call should stop all, the API would need to define that.
      throw ArgumentError(
        'Direction must be provided for stopPtz as per API documentation.',
      );
    }
    return _ptzControl(
      '/api/lapp/device/ptz/stop',
      deviceSerial,
      channelNo,
      params,
    );
  }

  Future<Map<String, dynamic>> mirrorFlip(
    String deviceSerial,
    int channelNo, {
    required PtzMirrorCommand command,
  }) async {
    return _ptzControl('/api/lapp/device/ptz/mirror', deviceSerial, channelNo, {
      'command': command.index,
    });
  }

  Future<Map<String, dynamic>> addPreset(
    String deviceSerial,
    int channelNo,
  ) async {
    return _ptzControl(
      '/api/lapp/device/preset/add',
      deviceSerial,
      channelNo,
      {},
    );
  }

  Future<Map<String, dynamic>> callPreset(
    String deviceSerial,
    int channelNo, {
    required int presetIndex,
  }) async {
    return _ptzControl(
      '/api/lapp/device/preset/move',
      deviceSerial,
      channelNo,
      {'index': presetIndex},
    );
  }

  Future<Map<String, dynamic>> clearPreset(
    String deviceSerial,
    int channelNo, {
    required int presetIndex,
  }) async {
    // Assuming endpoint based on API structure for other preset commands
    // Actual endpoint from docs: /api/lapp/device/preset/clear
    return _ptzControl(
      '/api/lapp/device/preset/clear',
      deviceSerial,
      channelNo,
      {'index': presetIndex},
    );
  }
}
