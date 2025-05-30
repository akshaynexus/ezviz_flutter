import '../ezviz_client.dart';

class LiveService {
  final EzvizClient _client;

  LiveService(this._client);

  Future<Map<String, dynamic>> getPlayAddress(
    String deviceSerial, {
    int? channelNo,
    int? protocol,
    String? code,
    int? expireTime,
    String? type,
    int? quality,
    String? startTime,
    String? stopTime,
  }) async {
    final body = <String, dynamic>{'deviceSerial': deviceSerial};
    if (channelNo != null) body['channelNo'] = channelNo;
    if (protocol != null) body['protocol'] = protocol;
    if (code != null) body['code'] = code;
    if (expireTime != null) body['expireTime'] = expireTime;
    if (type != null) body['type'] = type;
    if (quality != null) body['quality'] = quality;
    if (startTime != null) body['startTime'] = startTime;
    if (stopTime != null) body['stopTime'] = stopTime;

    return _client.post('/api/lapp/live/address/get', body);
  }

  Future<Map<String, dynamic>> invalidatePlayAddress(
    String deviceSerial, {
    int? channelNo,
    String? urlId,
  }) async {
    final body = <String, dynamic>{'deviceSerial': deviceSerial};
    if (channelNo != null) body['channelNo'] = channelNo;
    if (urlId != null) body['urlId'] = urlId;

    return _client.post('/api/lapp/live/address/disable', body);
  }
}
