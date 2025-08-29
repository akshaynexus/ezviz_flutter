import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:ezviz_flutter/ezviz_definition.dart';
import 'package:ezviz_flutter/ezviz_methods.dart';
import 'package:ezviz_flutter/ezviz_utils.dart';

/// 插件Manager
class EzvizManager {
  static const MethodChannel _channel = MethodChannel(
    EzvizChannelMethods.methodChannelName,
  );

  static const EventChannel _eventChannel = EventChannel(
    EzvizChannelEvents.eventChannelName,
  );

  ///单例模式
  static final EzvizManager _instance = EzvizManager._init();
  factory EzvizManager.shared() => _instance;

  ///私有构造函数
  EzvizManager._init();

  /// 事件监听
  StreamSubscription? _dataSubscription;

  /// 设置EventHandler
  void setEventHandler(EzvizOnEvent event, EzvizOnError error) {
    /// 释放之前的handler
    removeEventHandler();
    _dataSubscription = _eventChannel.receiveBroadcastStream().listen((data) {
      if (data is Map<String, dynamic> || data is String) {
        var jsonData = data is String ? json.decode(data) : data;
        ezvizLog("JSON => $jsonData");
        var ezvizEvent = EzvizEvent.init(jsonData);
        if (ezvizEvent != null) {
          event(ezvizEvent);
        }
      }
    }, onError: error);
  }

  /// 停止EventHandler
  void removeEventHandler() {
    if (_dataSubscription != null) {
      _dataSubscription?.cancel();
    }
  }

  Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod(
      EzvizChannelMethods.platformVersion,
    );
    return version;
  }

  Future<String> get sdkVersion async {
    final String version = await _channel.invokeMethod(
      EzvizChannelMethods.sdkVersion,
    );
    return version;
  }

  /// 初始化SDK
  Future<bool> initSDK(EzvizInitOptions? options) async {
    options ??= EzvizInitOptions();
    try {
      final bool result = await _channel.invokeMethod(
        EzvizChannelMethods.initSDK,
        options.toJson(),
      );
      print('result = $result');
      return result;
    } catch (e) {
      ezvizLog('ERROR =  $e');
      return false;
    }
  }

  /// 是否开启日志
  Future enableLog(bool enableLog) async {
    await _channel.invokeMethod(EzvizChannelMethods.enableLog, {
      'enableLog': enableLog,
    });
  }

  /// 是否开启P2P
  Future enableP2P(bool enableP2P) async {
    await _channel.invokeMethod(EzvizChannelMethods.enableP2P, {
      'enableP2P': enableP2P,
    });
  }

  /// 设置AccessToken
  Future setAccessToken(String accessToken) async {
    await _channel.invokeMethod(EzvizChannelMethods.setAccessToken, {
      'accessToken': accessToken,
    });
  }

  /// 获取设备信息
  ///
  Future<EzvizDeviceInfo?> getDeviceInfo(String deviceSerial) async {
    Map<String, dynamic>? result = await _channel.invokeMapMethod(
      EzvizChannelMethods.deviceInfo,
      {'deviceSerial': deviceSerial},
    );
    if (result != null) {
      return EzvizDeviceInfo.fromJson(result);
    } else {
      return null;
    }
  }

  /// 获取所有的设备信息
  Future<List<EzvizDeviceInfo>?> get deviceList async {
    List<Map<String, dynamic>>? result = await _channel.invokeListMethod(
      EzvizChannelMethods.deviceInfoList,
    );
    if (result != null) {
      final deviceList = <EzvizDeviceInfo>[];
      for (final item in result) {
        deviceList.add(EzvizDeviceInfo.fromJson(item));
      }
      return deviceList;
    } else {
      return null;
    }
  }

  /// 设置视频通道清晰度
  ///
  /// 如果是正在播放时调用该接口，设置清晰度成功以后必须让EZPlayer调用stopRealPlay再调用startRealPlay重新取流才成完成画面清晰度的切换。
  /// - Parameters:
  ///   - deviceSerial: 设备序列号
  ///   - cameraId: 通道号
  ///   - videoLevel: 通道清晰度，0-流畅，1-均衡，2-高清，3-超清
  Future<bool> setVideoLevel(
    String deviceSerial,
    int cameraId,
    int videoLevel,
  ) async {
    /// 不合法的参数
    if (!EzvizVideoLevels.isVideolLevel(videoLevel)) {
      ezvizLog('不合法的参数: videoLevel');
      return false;
    }

    final bool result = await _channel.invokeMethod(
      EzvizChannelMethods.setVideoLevel,
      {
        "deviceSerial": deviceSerial,
        "cameraId": cameraId,
        "videoLevel": videoLevel,
      },
    );
    return result;
  }

  /// 云台控制
  ///
  /// - Parameters:
  ///   - deviceSerial: 设备序列号
  ///   - cameraId: 通道号
  ///   - command: 云台指令
  ///   - action: 云台动作
  ///   - speed: 云台速度
  Future<bool> controlPTZ(
    String deviceSerial,
    int cameraId,
    String command,
    String action,
    int speed,
  ) async {
    if (!EzvizPtzCommands.isPtzCommand(command)) {
      ezvizLog('不合法的参数: command');
      return false;
    }

    if (!EzvizPtzActions.isPtzAction(action)) {
      ezvizLog('不合法的参数: action');
      return false;
    }

    if (!EzvizPtzSpeeds.isPtzSpeed(speed)) {
      ezvizLog('不合法的参数: speed');
      return false;
    }

    final bool result = await _channel
        .invokeMethod(EzvizChannelMethods.controlPTZ, {
          "deviceSerial": deviceSerial,
          "cameraId": cameraId,
          "command": command,
          "action": action,
          "speed": speed,
        });

    return result;
  }

  /// 登录网络设备
  ///
  /// - Parameters:
  ///   - userId: 用户名
  ///   - pwd: 密码
  ///   - ipAddr: 网络地址
  ///   - port: 端口号
  Future<EzvizNetDeviceInfo?> loginNetDevice(
    String userId,
    String pwd,
    String ipAddr,
    int port,
  ) async {
    final Map<String, dynamic>? result = await _channel.invokeMapMethod(
      EzvizChannelMethods.loginNetDevice,
      {"userId": userId, "pwd": pwd, "ipAddr": ipAddr, "port": port},
    );
    if (result != null) {
      return EzvizNetDeviceInfo.fromJson(result);
    } else {
      return null;
    }
  }

  /// 登出网络设备
  ///
  /// - Parameters:
  ///   - userId: 用户名
  Future<bool> logoutNetDevice(String userId) async {
    final bool result = await _channel.invokeMethod(
      EzvizChannelMethods.logoutNetDevice,
      {"usrId": userId},
    );
    return result;
  }

  /// 网络设备云台控制
  ///
  /// - Parameters:
  ///   - userId: 用户ID号
  ///   - channelNo: 通道号
  ///   - command: 云台指令
  ///   - action: 云台动作
  Future<bool> netControlPTZ(
    int userId,
    int channelNo,
    String command,
    String action,
  ) async {
    if (!EzvizPtzCommands.isPtzCommand(command)) {
      ezvizLog('不合法的参数: command');
      return false;
    }

    if (!EzvizPtzActions.isPtzAction(action)) {
      ezvizLog('不合法的参数: action');
      return false;
    }

    final bool result = await _channel.invokeMethod(
      EzvizChannelMethods.netControlPTZ,
      {
        "usrId": userId,
        "channelNo": channelNo,
        "command": command,
        "action": action,
      },
    );
    return result;
  }
}
