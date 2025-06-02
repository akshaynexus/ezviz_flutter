import 'dart:async';
import 'package:flutter/services.dart';
import 'package:ezviz_flutter/ezviz_methods.dart';
import 'package:ezviz_flutter/ezviz_utils.dart';

/// Audio and Intercom functionality
class EzvizAudio {
  static const MethodChannel _channel = const MethodChannel(
    EzvizChannelMethods.methodChannelName,
  );

  /// Open sound for video playback
  static Future<bool> openSound() async {
    try {
      final bool result = await _channel.invokeMethod('openSound');
      return result;
    } catch (e) {
      ezvizLog('Error opening sound: $e');
      return false;
    }
  }

  /// Close sound for video playback
  static Future<bool> closeSound() async {
    try {
      final bool result = await _channel.invokeMethod('closeSound');
      return result;
    } catch (e) {
      ezvizLog('Error closing sound: $e');
      return false;
    }
  }

  /// Start voice talk/intercom
  ///
  /// - Parameters:
  ///   - deviceSerial: Device serial number
  ///   - verifyCode: Device verification code
  ///   - cameraNo: Camera number (default: 1)
  ///   - isPhone2Dev: 1-phone speaks device listens, 0-phone listens device speaks
  ///   - supportTalk: 1-full duplex, 3-half duplex
  static Future<bool> startVoiceTalk({
    required String deviceSerial,
    String? verifyCode,
    int cameraNo = 1,
    int isPhone2Dev = 1,
    int supportTalk = 1,
  }) async {
    try {
      final bool result = await _channel.invokeMethod('startVoiceTalk', {
        'deviceSerial': deviceSerial,
        'verifyCode': verifyCode,
        'cameraNo': cameraNo,
        'isPhone2Dev': isPhone2Dev,
        'supportTalk': supportTalk,
      });
      return result;
    } catch (e) {
      ezvizLog('Error starting voice talk: $e');
      return false;
    }
  }

  /// Stop voice talk/intercom
  static Future<bool> stopVoiceTalk() async {
    try {
      final bool result = await _channel.invokeMethod('stopVoiceTalk');
      return result;
    } catch (e) {
      ezvizLog('Error stopping voice talk: $e');
      return false;
    }
  }
}
