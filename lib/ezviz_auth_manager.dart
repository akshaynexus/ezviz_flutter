import 'dart:async';
import 'package:flutter/services.dart';
import 'package:ezviz_flutter/ezviz_methods.dart';
import 'package:ezviz_flutter/ezviz_utils.dart';

/// Authentication and Area Management for EZVIZ SDK
class EzvizAuthManager {
  static const MethodChannel _channel = MethodChannel(
    EzvizChannelMethods.methodChannelName,
  );

  /// Open EZVIZ login page for user authentication
  /// 
  /// Parameters:
  /// - areaId: Optional area ID for global SDK (overseas version)
  /// 
  /// Returns true if login page opened successfully
  /// After successful login, a broadcast will be sent with action OAUTH_SUCCESS_ACTION
  static Future<bool> openLoginPage({String? areaId}) async {
    try {
      final bool result = await _channel.invokeMethod(
        EzvizChannelMethods.openLoginPage,
        areaId != null ? {'areaId': areaId} : null,
      );
      return result;
    } catch (e) {
      ezvizLog('Error opening login page: $e');
      return false;
    }
  }

  /// Logout current user
  /// 
  /// This will clear the cached access token and logout from EZVIZ account
  /// 
  /// Returns true if logout successful
  static Future<bool> logout() async {
    try {
      final bool result = await _channel.invokeMethod(EzvizChannelMethods.logout);
      return result;
    } catch (e) {
      ezvizLog('Error during logout: $e');
      return false;
    }
  }

  /// Get current cached access token
  /// 
  /// Returns EzvizAccessToken object or null if no token cached
  static Future<EzvizAccessToken?> getAccessToken() async {
    try {
      final result = await _channel
          .invokeMapMethod<String, dynamic>(EzvizChannelMethods.getAccessToken);

      if (result != null) {
        return EzvizAccessToken.fromJson(result);
      }
      return null;
    } catch (e) {
      ezvizLog('Error getting access token: $e');
      return null;
    }
  }

  /// Get available area list for global SDK
  /// 
  /// This is used for overseas regions to select the appropriate area
  /// 
  /// Returns list of available areas
  static Future<List<EzvizAreaInfo>> getAreaList() async {
    try {
      final List<dynamic> result = await _channel.invokeMethod(
        EzvizChannelMethods.getAreaList,
      );

      return result.map((areaData) {
        final map = Map<String, dynamic>.from(areaData as Map);
        return EzvizAreaInfo.fromJson(map);
      }).toList();
    } catch (e) {
      ezvizLog('Error getting area list: $e');
      return [];
    }
  }

  /// Set server URLs for API and authentication
  /// 
  /// Parameters:
  /// - apiUrl: API server URL
  /// - authUrl: Authentication server URL
  /// 
  /// Returns true if URLs set successfully
  static Future<bool> setServerUrl({
    required String apiUrl,
    required String authUrl,
  }) async {
    try {
      final bool result = await _channel.invokeMethod(
        EzvizChannelMethods.setServerUrl,
        {
          'apiUrl': apiUrl,
          'authUrl': authUrl,
        },
      );
      return result;
    } catch (e) {
      ezvizLog('Error setting server URL: $e');
      return false;
    }
  }
}

/// Access Token information
class EzvizAccessToken {
  final String accessToken;
  final int expireTime;

  EzvizAccessToken({
    required this.accessToken,
    required this.expireTime,
  });

  factory EzvizAccessToken.fromJson(Map<String, dynamic> json) {
    return EzvizAccessToken(
      accessToken: json['accessToken'] ?? '',
      expireTime: json['expireTime'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'expireTime': expireTime,
    };
  }

  /// Check if the access token is expired
  bool get isExpired {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    return currentTime >= expireTime;
  }

  /// Get remaining time until expiration in minutes
  int get remainingMinutes {
    if (isExpired) return 0;
    
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final remainingMs = expireTime - currentTime;
    return (remainingMs / (1000 * 60)).round();
  }
}

/// Area information for global SDK
class EzvizAreaInfo {
  final String areaId;
  final String areaName;

  EzvizAreaInfo({
    required this.areaId,
    required this.areaName,
  });

  factory EzvizAreaInfo.fromJson(Map<String, dynamic> json) {
    return EzvizAreaInfo(
      areaId: json['areaId'] ?? '',
      areaName: json['areaName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'areaId': areaId,
      'areaName': areaName,
    };
  }
}
