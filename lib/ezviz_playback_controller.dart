import 'dart:async';
import 'package:flutter/services.dart';
import 'package:ezviz_flutter/ezviz_utils.dart';
import 'package:ezviz_flutter/ezviz_player.dart';

// Method channel for enhanced playback functionality
const MethodChannel _enhancedChannel = MethodChannel('ezviz_flutter/enhanced_playback');

/// Enhanced playback controller with additional functionality
/// 
/// This extends the basic EzvizPlayerController with advanced playback features
extension EzvizPlayerControllerExtensions on EzvizPlayerController {
  
  /// Seek to specific time in playback
  /// 
  /// Parameters:
  /// - timeMs: Target time in milliseconds since epoch
  /// 
  /// Returns true if seek successful
  Future<bool> seekPlayback(int timeMs) async {
    try {
      final bool result = await _enhancedChannel.invokeMethod(
        'seekPlayback',
        {'timeMs': timeMs},
      );
      return result;
    } catch (e) {
      ezvizLog('Error seeking playback: $e');
      return false;
    }
  }

  /// Get current OSD time from video stream
  /// 
  /// Returns current playback time in milliseconds, or 0 if failed
  Future<int> getOSDTime() async {
    try {
      final int result = await _enhancedChannel.invokeMethod('getOSDTime') ?? 0;
      return result;
    } catch (e) {
      ezvizLog('Error getting OSD time: $e');
      return 0;
    }
  }

  /// Set playback speed (for recorded video)
  /// 
  /// Parameters:
  /// - speed: Playback speed multiplier (0.5x, 1.0x, 2.0x, etc.)
  /// 
  /// Returns true if speed set successfully
  Future<bool> setPlaySpeed(double speed) async {
    try {
      final bool result = await _enhancedChannel.invokeMethod(
        'setPlaySpeed',
        {'speed': speed},
      ) ?? false;
      return result;
    } catch (e) {
      ezvizLog('Error setting play speed: $e');
      return false;
    }
  }

  /// Start local recording of video stream
  /// 
  /// Parameters:
  /// - filePath: Local file path to save recording
  /// 
  /// Returns true if recording started successfully
  Future<bool> startLocalRecord(String filePath) async {
    try {
      final bool result = await _enhancedChannel.invokeMethod(
        'startLocalRecord',
        {'filePath': filePath},
      ) ?? false;
      return result;
    } catch (e) {
      ezvizLog('Error starting local record: $e');
      return false;
    }
  }

  /// Stop local recording
  /// 
  /// Returns true if recording stopped successfully
  Future<bool> stopLocalRecord() async {
    try {
      final bool result = await _enhancedChannel.invokeMethod('stopLocalRecord') ?? false;
      return result;
    } catch (e) {
      ezvizLog('Error stopping local record: $e');
      return false;
    }
  }

  /// Check if currently recording locally
  /// 
  /// Returns true if recording is active
  Future<bool> isLocalRecording() async {
    try {
      final bool result = await _enhancedChannel.invokeMethod('isLocalRecording') ?? false;
      return result;
    } catch (e) {
      ezvizLog('Error checking local recording status: $e');
      return false;
    }
  }

  /// Capture image from current video frame
  /// 
  /// Returns path to captured image file, or null if failed
  Future<String?> captureImage() async {
    try {
      final String? result = await _enhancedChannel.invokeMethod('captureImage');
      return result;
    } catch (e) {
      ezvizLog('Error capturing image: $e');
      return null;
    }
  }

  /// Scale playback window
  /// 
  /// Parameters:
  /// - scaleX: X-axis scale factor
  /// - scaleY: Y-axis scale factor
  /// 
  /// Returns true if scaling successful
  Future<bool> scalePlayWindow({
    required double scaleX,
    required double scaleY,
  }) async {
    try {
      final bool result = await _enhancedChannel.invokeMethod(
        'scalePlayWindow',
        {
          'scaleX': scaleX,
          'scaleY': scaleY,
        },
      ) ?? false;
      return result;
    } catch (e) {
      ezvizLog('Error scaling play window: $e');
      return false;
    }
  }
}

/// Playback utilities and helpers
class EzvizPlaybackUtils {
  /// Convert milliseconds to human-readable time format
  /// 
  /// Parameters:
  /// - milliseconds: Time in milliseconds
  /// 
  /// Returns formatted time string (HH:mm:ss)
  static String formatPlaybackTime(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);
    
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
             '${minutes.toString().padLeft(2, '0')}:'
             '${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:'
             '${seconds.toString().padLeft(2, '0')}';
    }
  }

  /// Calculate playback progress percentage
  /// 
  /// Parameters:
  /// - currentTime: Current playback time in milliseconds
  /// - startTime: Recording start time in milliseconds
  /// - endTime: Recording end time in milliseconds
  /// 
  /// Returns progress percentage (0.0 to 1.0)
  static double calculateProgress({
    required int currentTime,
    required int startTime,
    required int endTime,
  }) {
    if (endTime <= startTime) return 0.0;
    
    final totalDuration = endTime - startTime;
    final currentPosition = currentTime - startTime;
    
    if (currentPosition <= 0) return 0.0;
    if (currentPosition >= totalDuration) return 1.0;
    
    return currentPosition / totalDuration;
  }

  /// Convert progress percentage to time
  /// 
  /// Parameters:
  /// - progress: Progress percentage (0.0 to 1.0)
  /// - startTime: Recording start time in milliseconds
  /// - endTime: Recording end time in milliseconds
  /// 
  /// Returns corresponding time in milliseconds
  static int progressToTime({
    required double progress,
    required int startTime,
    required int endTime,
  }) {
    if (progress <= 0.0) return startTime;
    if (progress >= 1.0) return endTime;
    
    final totalDuration = endTime - startTime;
    return startTime + (totalDuration * progress).round();
  }

  /// Get recommended playback speeds
  /// 
  /// Returns list of common playback speed options
  static List<PlaybackSpeed> getPlaybackSpeeds() {
    return [
      PlaybackSpeed(value: 0.25, display: '0.25x'),
      PlaybackSpeed(value: 0.5, display: '0.5x'),
      PlaybackSpeed(value: 1.0, display: '1x'),
      PlaybackSpeed(value: 1.25, display: '1.25x'),
      PlaybackSpeed(value: 1.5, display: '1.5x'),
      PlaybackSpeed(value: 2.0, display: '2x'),
      PlaybackSpeed(value: 4.0, display: '4x'),
    ];
  }
}

/// Playback speed option
class PlaybackSpeed {
  final double value;
  final String display;

  PlaybackSpeed({
    required this.value,
    required this.display,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlaybackSpeed && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => display;
}

/// Recording types for search operations
enum RecordingType {
  all(0, 'All'),
  timing(1, 'Timing'),
  alarm(2, 'Alarm'),
  manual(3, 'Manual');

  const RecordingType(this.value, this.display);
  
  final int value;
  final String display;
  
  @override
  String toString() => display;
}
