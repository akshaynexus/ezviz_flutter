import 'dart:async';
import 'package:flutter/services.dart';
import 'package:ezviz_flutter/ezviz_methods.dart';
import 'package:ezviz_flutter/ezviz_utils.dart';

/// Recording and Screenshot functionality
class EzvizRecording {
  static const MethodChannel _channel = const MethodChannel(
    EzvizChannelMethods.methodChannelName,
  );

  /// Capture screenshot during video playback
  static Future<String?> capturePicture() async {
    try {
      final result = await _channel.invokeMethod('capturePicture');
      return result as String?;
    } catch (e) {
      ezvizLog('Error capturing picture: $e');
      return null;
    }
  }

  /// Start video recording
  static Future<bool> startRecording() async {
    try {
      final bool result = await _channel.invokeMethod('startRecording');
      return result;
    } catch (e) {
      ezvizLog('Error starting recording: $e');
      return false;
    }
  }

  /// Stop video recording
  static Future<bool> stopRecording() async {
    try {
      final bool result = await _channel.invokeMethod('stopRecording');
      return result;
    } catch (e) {
      ezvizLog('Error stopping recording: $e');
      return false;
    }
  }

  /// Get recording status
  static Future<bool> isRecording() async {
    try {
      final bool result = await _channel.invokeMethod('isRecording');
      return result;
    } catch (e) {
      ezvizLog('Error getting recording status: $e');
      return false;
    }
  }
}
