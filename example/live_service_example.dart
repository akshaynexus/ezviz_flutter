import 'package:ezviz_flutter/ezviz_flutter.dart';
import 'api_config.dart';

void main() async {
  // Initialize the EZVIZ client
  final client = EzvizClient(
    appKey: ApiConfig.appKey,
    appSecret: ApiConfig.appSecret,
  );

  final liveService = LiveService(client);

  try {
    // Example 1: Basic live stream (no encryption)
    print('Getting live stream for basic device...');
    final basicStream = await liveService.getPlayAddress(
      'C24899350',
      channelNo: 1,
      protocol: 1, // HLS
      quality: 1, // HD
    );
    print('Basic stream URL: ${basicStream['data']['url']}');

    // Example 2: Live stream with password/verification code
    print('\nGetting live stream for encrypted device...');
    final encryptedStream = await liveService.getPlayAddress(
      'FG3451360',
      channelNo: 1,
      protocol: 1, // HLS
      quality: 1, // HD
      password: 'ABCDEF', // Your device password/verification code
    );
    print('Encrypted stream URL: ${encryptedStream['data']['url']}');

    // Example 3: Using the automatic password handling method
    print('\nGetting live stream with automatic encryption handling...');
    final autoStream = await liveService.getPlayAddressWithPassword(
      'D07603744',
      'GHIJKL', // Your device password
      channelNo: 1,
      protocol: 1, // HLS
      quality: 1, // HD
    );
    print('Auto-handled stream URL: ${autoStream['data']['url']}');

    // Example 4: Different protocols and qualities
    print('\nGetting RTMP stream...');
    final rtmpStream = await liveService.getPlayAddress(
      'FG3451360',
      password: 'ABCDEF',
      protocol: 0, // RTMP
      quality: 2, // Ultra HD
    );
    print('RTMP stream URL: ${rtmpStream['data']['url']}');

    // Example 5: WebRTC stream for low latency
    print('\nGetting WebRTC stream...');
    final webrtcStream = await liveService.getPlayAddress(
      'FG3451360',
      password: 'ABCDEF',
      protocol: 3, // WebRTC
      quality: 0, // Smooth for lower latency
    );
    print('WebRTC stream URL: ${webrtcStream['data']['url']}');

    // Example 6: Handle multiple devices with different passwords
    final devicePasswords = {
      'FG3451360': 'ABCDEF',
      'D07603744': 'GHIJKL',
      'C24899350': null, // No password needed
    };

    print('\nGetting streams for multiple devices...');
    for (final device in devicePasswords.entries) {
      try {
        final stream = device.value != null
            ? await liveService.getPlayAddressWithPassword(
                device.key,
                device.value!,
              )
            : await liveService.getPlayAddress(device.key);

        print('${device.key}: ${stream['data']['url']}');
      } catch (e) {
        print('${device.key}: Failed - $e');
      }
    }

    // Example 7: Invalidate a stream when done
    print('\nInvalidating stream...');
    await liveService.invalidatePlayAddress('FG3451360');
    print('Stream invalidated successfully');
  } catch (e) {
    print('Error: $e');

    // Handle specific encryption errors
    if (e.toString().contains('60019')) {
      print(
        'Device encryption is enabled. Please provide the correct password.',
      );
      print('You can find the password on:');
      print('1. Device label/sticker (usually 6 letters)');
      print('2. EZVIZ app > Device Settings > Device Information');
      print('3. Original device packaging');
    }
  }
}

/// Helper function to demonstrate error handling
Future<String?> getStreamUrlSafely(
  LiveService liveService,
  String deviceSerial,
  String? password,
) async {
  try {
    final result = password != null
        ? await liveService.getPlayAddressWithPassword(deviceSerial, password)
        : await liveService.getPlayAddress(deviceSerial);

    return result['data']['url'];
  } on EzvizApiException catch (e) {
    switch (e.code) {
      case '60019':
        print('Device $deviceSerial requires encryption password');
        return null;
      case '20002':
        print('Device $deviceSerial does not exist');
        return null;
      case '20007':
        print('Device $deviceSerial is offline');
        return null;
      default:
        print('Unknown error for device $deviceSerial: ${e.message}');
        return null;
    }
  } catch (e) {
    print('Unexpected error for device $deviceSerial: $e');
    return null;
  }
}
