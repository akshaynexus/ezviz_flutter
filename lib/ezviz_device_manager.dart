import 'dart:async';
import 'package:flutter/services.dart';
import 'package:ezviz_flutter/ezviz_methods.dart';
import 'package:ezviz_flutter/ezviz_utils.dart';
import 'package:ezviz_flutter/ezviz_definition.dart';

/// Device Management functionality for EZVIZ SDK
class EzvizDeviceManager {
  static const MethodChannel _channel = const MethodChannel(
    EzvizChannelMethods.methodChannelName,
  );

  /// Get device list from account
  /// 
  /// Parameters:
  /// - pageStart: Start page index (default: 0)
  /// - pageSize: Page size (default: 10, max: 50)
  /// 
  /// Returns list of EzvizDeviceInfo objects
  static Future<List<EzvizDeviceInfo>> getDeviceList({
    int pageStart = 0,
    int pageSize = 10,
  }) async {
    try {
      final List<dynamic> result = await _channel.invokeMethod(
        EzvizChannelMethods.getDeviceList,
        {
          'pageStart': pageStart,
          'pageSize': pageSize,
        },
      );

      return result.map<EzvizDeviceInfo>((deviceData) {
        return EzvizDeviceInfo.fromJson(deviceData as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      ezvizLog('Error getting device list: $e');
      return [];
    }
  }

  /// Add a device to current account
  /// 
  /// Parameters:
  /// - deviceSerial: Device serial number
  /// - verifyCode: Device verification code (if required)
  /// 
  /// Returns true if device added successfully
  static Future<bool> addDevice({
    required String deviceSerial,
    String verifyCode = '',
  }) async {
    try {
      final bool result = await _channel.invokeMethod(
        EzvizChannelMethods.addDevice,
        {
          'deviceSerial': deviceSerial,
          'verifyCode': verifyCode,
        },
      );
      return result;
    } catch (e) {
      ezvizLog('Error adding device: $e');
      return false;
    }
  }

  /// Delete device from current account
  /// 
  /// Parameters:
  /// - deviceSerial: Device serial number
  /// 
  /// Returns true if device deleted successfully
  static Future<bool> deleteDevice(String deviceSerial) async {
    try {
      final bool result = await _channel.invokeMethod(
        EzvizChannelMethods.deleteDevice,
        {
          'deviceSerial': deviceSerial,
        },
      );
      return result;
    } catch (e) {
      ezvizLog('Error deleting device: $e');
      return false;
    }
  }

  /// Probe device information before adding
  /// 
  /// This method checks device status and availability before adding
  /// 
  /// Parameters:
  /// - deviceSerial: Device serial number
  /// 
  /// Returns EzvizProbeDeviceInfo object or null if failed
  static Future<EzvizProbeDeviceInfo?> probeDeviceInfo(String deviceSerial) async {
    try {
      final Map<String, dynamic>? result = await _channel.invokeMethod(
        EzvizChannelMethods.probeDeviceInfo,
        {
          'deviceSerial': deviceSerial,
        },
      );

      if (result != null) {
        return EzvizProbeDeviceInfo.fromJson(result);
      }
      return null;
    } catch (e) {
      ezvizLog('Error probing device info: $e');
      return null;
    }
  }

  /// Get detailed device information
  /// 
  /// Parameters:
  /// - deviceSerial: Device serial number
  /// 
  /// Returns detailed device information
  static Future<Map<String, dynamic>?> getDeviceDetailInfo(String deviceSerial) async {
    try {
      final Map<String, dynamic>? result = await _channel.invokeMethod(
        EzvizChannelMethods.getDeviceDetailInfo,
        {
          'deviceSerial': deviceSerial,
        },
      );
      return result;
    } catch (e) {
      ezvizLog('Error getting device detail info: $e');
      return null;
    }
  }

  /// Search record files from cloud storage
  /// 
  /// Parameters:
  /// - deviceSerial: Device serial number
  /// - cameraNo: Camera number (default: 1)
  /// - startTime: Search start time in milliseconds
  /// - endTime: Search end time in milliseconds
  /// - recType: Recording type (0: all, 1: timing, 2: alarm, 3: manual)
  /// 
  /// Returns list of cloud record files
  static Future<List<EzvizCloudRecordFile>> searchCloudRecordFiles({
    required String deviceSerial,
    int cameraNo = 1,
    required int startTime,
    required int endTime,
    int recType = 0,
  }) async {
    try {
      final List<dynamic> result = await _channel.invokeMethod(
        EzvizChannelMethods.searchRecordFile,
        {
          'deviceSerial': deviceSerial,
          'cameraNo': cameraNo,
          'startTime': startTime,
          'endTime': endTime,
          'recType': recType,
        },
      );

      return result.map((recordData) {
        return EzvizCloudRecordFile.fromJson(recordData as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      ezvizLog('Error searching cloud record files: $e');
      return [];
    }
  }

  /// Search record files from device storage
  /// 
  /// Parameters:
  /// - deviceSerial: Device serial number
  /// - cameraNo: Camera number (default: 1)
  /// - startTime: Search start time in milliseconds
  /// - endTime: Search end time in milliseconds
  /// 
  /// Returns list of device record files
  static Future<List<EzvizDeviceRecordFile>> searchDeviceRecordFiles({
    required String deviceSerial,
    int cameraNo = 1,
    required int startTime,
    required int endTime,
  }) async {
    try {
      final List<dynamic> result = await _channel.invokeMethod(
        EzvizChannelMethods.searchDeviceRecordFile,
        {
          'deviceSerial': deviceSerial,
          'cameraNo': cameraNo,
          'startTime': startTime,
          'endTime': endTime,
        },
      );

      return result.map((recordData) {
        return EzvizDeviceRecordFile.fromJson(recordData as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      ezvizLog('Error searching device record files: $e');
      return [];
    }
  }
}

/// WiFi Configuration Manager
class EzvizWifiManager {
  static const MethodChannel _channel = const MethodChannel(
    EzvizChannelMethods.methodChannelName,
  );

  /// Start WiFi configuration for device
  /// 
  /// Parameters:
  /// - deviceSerial: Device serial number
  /// - ssid: WiFi network name
  /// - password: WiFi password
  /// - mode: Configuration mode (default: 0)
  /// 
  /// Returns true if configuration started successfully
  static Future<bool> startConfigWifi({
    required String deviceSerial,
    required String ssid,
    required String password,
    int mode = 0,
  }) async {
    try {
      final bool result = await _channel.invokeMethod(
        'startConfigWifi',
        {
          'deviceSerial': deviceSerial,
          'ssid': ssid,
          'password': password,
          'mode': mode,
        },
      );
      return result;
    } catch (e) {
      ezvizLog('Error starting WiFi config: $e');
      return false;
    }
  }

  /// Stop WiFi configuration
  /// 
  /// Returns true if stopped successfully
  static Future<bool> stopConfigWifi() async {
    try {
      final bool result = await _channel.invokeMethod('stopConfigWifi');
      return result;
    } catch (e) {
      ezvizLog('Error stopping WiFi config: $e');
      return false;
    }
  }
}

/// Additional data models for the new functionality
class EzvizProbeDeviceInfo {
  final String deviceSerial;
  final String deviceName;
  final String deviceType;
  final int status;
  final bool supportWifi;
  final String netType;

  EzvizProbeDeviceInfo({
    required this.deviceSerial,
    required this.deviceName,
    required this.deviceType,
    required this.status,
    required this.supportWifi,
    required this.netType,
  });

  factory EzvizProbeDeviceInfo.fromJson(Map<String, dynamic> json) {
    return EzvizProbeDeviceInfo(
      deviceSerial: json['deviceSerial'] ?? '',
      deviceName: json['deviceName'] ?? '',
      deviceType: json['deviceType'] ?? '',
      status: json['status'] ?? 0,
      supportWifi: json['supportWifi'] ?? false,
      netType: json['netType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deviceSerial': deviceSerial,
      'deviceName': deviceName,
      'deviceType': deviceType,
      'status': status,
      'supportWifi': supportWifi,
      'netType': netType,
    };
  }
}

class EzvizCloudRecordFile {
  final String fileName;
  final int startTime;
  final int endTime;
  final int fileSize;
  final int recType;

  EzvizCloudRecordFile({
    required this.fileName,
    required this.startTime,
    required this.endTime,
    required this.fileSize,
    required this.recType,
  });

  factory EzvizCloudRecordFile.fromJson(Map<String, dynamic> json) {
    return EzvizCloudRecordFile(
      fileName: json['fileName'] ?? '',
      startTime: json['startTime'] ?? 0,
      endTime: json['endTime'] ?? 0,
      fileSize: json['fileSize'] ?? 0,
      recType: json['recType'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'startTime': startTime,
      'endTime': endTime,
      'fileSize': fileSize,
      'recType': recType,
    };
  }
}

class EzvizDeviceRecordFile {
  final String fileName;
  final int startTime;
  final int endTime;
  final int fileSize;

  EzvizDeviceRecordFile({
    required this.fileName,
    required this.startTime,
    required this.endTime,
    required this.fileSize,
  });

  factory EzvizDeviceRecordFile.fromJson(Map<String, dynamic> json) {
    return EzvizDeviceRecordFile(
      fileName: json['fileName'] ?? '',
      startTime: json['startTime'] ?? 0,
      endTime: json['endTime'] ?? 0,
      fileSize: json['fileSize'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'startTime': startTime,
      'endTime': endTime,
      'fileSize': fileSize,
    };
  }
}