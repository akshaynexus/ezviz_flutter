import '../ezviz_client.dart';

class LiveService {
  final EzvizClient _client;

  LiveService(this._client);

  /// Get live stream play address for a device.
  ///
  /// [deviceSerial]: The device serial number
  /// [channelNo]: Channel number (default: 1 for most cameras)
  /// [protocol]: Protocol type (0: RTMP, 1: HLS, 2: FLV, 3: WebRTC)
  /// [code]: Device verification code (for encrypted devices)
  /// [password]: Video encryption password (alias for code parameter)
  /// [expireTime]: Token expiration time in seconds
  /// [type]: Stream type (0: main stream, 1: sub stream)
  /// [quality]: Video quality (0: Smooth, 1: HD, 2: Ultra HD)
  /// [startTime]: Start time for playback (format: yyyy-MM-dd HH:mm:ss)
  /// [stopTime]: Stop time for playback (format: yyyy-MM-dd HH:mm:ss)
  Future<Map<String, dynamic>> getPlayAddress(
    String deviceSerial, {
    int? channelNo,
    int? protocol,
    String? code,
    String? password, // Video encryption password (alias for code)
    int? expireTime,
    String? type,
    int? quality,
    String? startTime,
    String? stopTime,
    bool debug = false, // Add debug flag
  }) async {
    final body = <String, dynamic>{'deviceSerial': deviceSerial};
    if (channelNo != null) body['channelNo'] = channelNo;
    if (protocol != null) body['protocol'] = protocol;

    // Use password parameter if provided, otherwise use code
    final deviceCode = password ?? code;
    if (deviceCode != null) {
      body['code'] = deviceCode;
      if (debug) {
        print('🔐 LiveService Debug: Adding code parameter');
        print('   - Original password: $password');
        print('   - Original code: $code');
        print('   - Final deviceCode: $deviceCode');
        print('   - Code length: ${deviceCode.length}');
      }
    } else if (debug) {
      print('⚠️ LiveService Debug: NO CODE/PASSWORD provided');
    }

    if (expireTime != null) body['expireTime'] = expireTime;
    if (type != null) body['type'] = type;
    if (quality != null) body['quality'] = quality;
    if (startTime != null) body['startTime'] = startTime;
    if (stopTime != null) body['stopTime'] = stopTime;

    if (debug) {
      print('📡 LiveService Debug: API Request Body:');
      body.forEach((key, value) => print('   - $key: $value'));
    }

    return _client.post('/api/lapp/live/address/get', body);
  }

  /// Invalidate/disable a live stream address.
  ///
  /// [deviceSerial]: The device serial number
  /// [channelNo]: Channel number (optional)
  /// [urlId]: Specific URL ID to invalidate (optional)
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

  /// Get live stream with automatic encryption handling.
  ///
  /// This method tries to get the stream without password first, and if encryption
  /// error occurs, it will retry with the provided password.
  ///
  /// [deviceSerial]: The device serial number
  /// [password]: Video encryption password
  /// [channelNo]: Channel number (default: 1)
  /// [protocol]: Protocol type (0: RTMP, 1: HLS, 2: FLV, 3: WebRTC)
  /// [quality]: Video quality (0: Smooth, 1: HD, 2: Ultra HD)
  /// [debug]: Enable debug logging
  Future<Map<String, dynamic>> getPlayAddressWithPassword(
    String deviceSerial,
    String password, {
    int channelNo = 1,
    int protocol = 1, // Default to HLS
    int quality = 1, // Default to HD
    bool debug = false,
  }) async {
    if (debug) {
      print('🔄 LiveService: getPlayAddressWithPassword called');
      print('   - deviceSerial: $deviceSerial');
      print('   - password: $password');
      print('   - password length: ${password.length}');
      print('   - channelNo: $channelNo');
      print('   - protocol: $protocol');
      print('   - quality: $quality');
    }

    try {
      // First try without password
      if (debug) print('🔍 Trying without password first...');
      return await getPlayAddress(
        deviceSerial,
        channelNo: channelNo,
        protocol: protocol,
        quality: quality,
        debug: debug,
      );
    } catch (e) {
      if (debug) print('❌ First attempt failed: $e');

      // If encryption error, retry with password
      if (e.toString().contains('60019') ||
          e.toString().contains('encryption') ||
          e.toString().contains('parameter code is empty')) {
        if (debug) print('🔐 Retrying with password...');
        return await getPlayAddress(
          deviceSerial,
          channelNo: channelNo,
          protocol: protocol,
          quality: quality,
          password: password,
          debug: debug,
        );
      } else {
        rethrow;
      }
    }
  }
}
