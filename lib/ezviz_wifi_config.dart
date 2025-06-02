import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:ezviz_flutter/ezviz_methods.dart';
import 'package:ezviz_flutter/ezviz_utils.dart';

/// Wi-Fi Configuration modes
enum EzvizWifiConfigMode {
  wifi, // Wi-Fi configuration mode
  wave, // Sound wave configuration mode
  ap, // Access Point (hotspot) mode
}

/// Wi-Fi Configuration result
class EzvizWifiConfigResult {
  final bool isSuccess;
  final String? errorMessage;
  final String? deviceSerial;

  EzvizWifiConfigResult({
    required this.isSuccess,
    this.errorMessage,
    this.deviceSerial,
  });

  factory EzvizWifiConfigResult.fromJson(Map<String, dynamic> json) {
    return EzvizWifiConfigResult(
      isSuccess: json['isSuccess'] ?? false,
      errorMessage: json['errorMessage'],
      deviceSerial: json['deviceSerial'],
    );
  }
}

/// Wi-Fi Configuration functionality for EZVIZ devices
class EzvizWifiConfig {
  static const MethodChannel _channel = const MethodChannel(
    EzvizChannelMethods.methodChannelName,
  );

  static const EventChannel _configEventChannel = const EventChannel(
    'ezviz_flutter_wifi_config_event',
  );

  /// Wi-Fi configuration event listener
  static StreamSubscription? _configSubscription;

  /// Set up Wi-Fi configuration event handler
  static void setConfigEventHandler(Function(EzvizWifiConfigResult) onResult) {
    _configSubscription?.cancel();
    _configSubscription = _configEventChannel.receiveBroadcastStream().listen((
      data,
    ) {
      if (data is Map<String, dynamic> || data is String) {
        var jsonData = data is String ? json.decode(data) : data;
        final result = EzvizWifiConfigResult.fromJson(jsonData);
        onResult(result);
      }
    });
  }

  /// Remove Wi-Fi configuration event handler
  static void removeConfigEventHandler() {
    _configSubscription?.cancel();
    _configSubscription = null;
  }

  /// Start Wi-Fi configuration (Wi-Fi mode)
  ///
  /// - Parameters:
  ///   - deviceSerial: Device serial number
  ///   - ssid: Wi-Fi network name
  ///   - password: Wi-Fi password (optional for open networks)
  ///   - mode: Configuration mode (wifi or wave)
  static Future<bool> startWifiConfig({
    required String deviceSerial,
    required String ssid,
    String? password,
    EzvizWifiConfigMode mode = EzvizWifiConfigMode.wifi,
  }) async {
    try {
      final bool result = await _channel.invokeMethod('startConfigWifi', {
        'deviceSerial': deviceSerial,
        'ssid': ssid,
        'password': password,
        'mode': _getModeString(mode),
      });
      return result;
    } catch (e) {
      ezvizLog('Error starting Wi-Fi config: $e');
      return false;
    }
  }

  /// Start Access Point (hotspot) configuration
  ///
  /// - Parameters:
  ///   - deviceSerial: Device serial number
  ///   - ssid: Target Wi-Fi network name
  ///   - password: Target Wi-Fi password
  ///   - verifyCode: Device verification code
  ///   - routerName: Router name (optional)
  static Future<bool> startAPConfig({
    required String deviceSerial,
    required String ssid,
    String? password,
    String? verifyCode,
    String? routerName,
  }) async {
    try {
      final bool result = await _channel.invokeMethod('startConfigAP', {
        'deviceSerial': deviceSerial,
        'ssid': ssid,
        'password': password,
        'verifyCode': verifyCode,
        'routerName': routerName,
      });
      return result;
    } catch (e) {
      ezvizLog('Error starting AP config: $e');
      return false;
    }
  }

  /// Stop Wi-Fi configuration process
  ///
  /// - Parameters:
  ///   - mode: Configuration mode to stop
  static Future<bool> stopConfig({required EzvizWifiConfigMode mode}) async {
    try {
      final bool result = await _channel.invokeMethod('stopConfig', {
        'mode': _getModeString(mode),
      });
      return result;
    } catch (e) {
      ezvizLog('Error stopping config: $e');
      return false;
    }
  }

  /// Convert enum to string
  static String _getModeString(EzvizWifiConfigMode mode) {
    switch (mode) {
      case EzvizWifiConfigMode.wifi:
        return 'wifi';
      case EzvizWifiConfigMode.wave:
        return 'wave';
      case EzvizWifiConfigMode.ap:
        return 'ap';
    }
  }
}
