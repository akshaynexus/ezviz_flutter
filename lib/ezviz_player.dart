import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:ezviz_flutter/ezviz_definition.dart';
import 'package:ezviz_flutter/ezviz_methods.dart';
import 'package:ezviz_flutter/ezviz_utils.dart';

typedef EzvizPlayerCreatedCallback =
    void Function(EzvizPlayerController controller);

///用与和原生代码关联 播放器管理类
class EzvizPlayerController {
  late final MethodChannel _channel;
  late final EventChannel _eventChannel;
  bool _isDisposed = false;

  /// 事件监听
  StreamSubscription? _dataSubscription;

  EzvizPlayerController(int id) {
    try {
      _channel = MethodChannel(
        '${EzvizPlayerChannelMethods.methodChannelName}_$id',
      );
      _eventChannel = EventChannel(
        '${EzvizPlayerChannelEvents.eventChannelName}_$id',
      );
    } catch (e) {
      print('Error initializing EzvizPlayerController: $e');
      // Create dummy channels to prevent null reference errors
      _channel = MethodChannel('dummy_channel');
      _eventChannel = EventChannel('dummy_event_channel');
    }
  }

  // Removed unused _safeInvokeMethod helper to satisfy analyzer

  /// Dispose the controller safely
  void dispose() {
    if (!_isDisposed) {
      _isDisposed = true;
      removePlayerEventHandler();
    }
  }

  /// 设置EventHandler
  void setPlayerEventHandler(EzvizOnEvent event, EzvizOnError error) {
    /// 释放之前的handler
    removePlayerEventHandler();
    _dataSubscription = _eventChannel.receiveBroadcastStream().listen((data) {
      if (data is Map<String, dynamic> || data is String) {
        var jsonData = data is String ? json.decode(data) : data;
        ezvizLog("JSON => $jsonData");
        var ezvizEvent = EzvizEvent.init(jsonData);
        if (ezvizEvent != null) {
          if (ezvizEvent.eventType == EzvizChannelEvents.playerStatusChange) {
            try {
              // Handle both cases: data as JSON string or as direct object
              if (jsonData['data'] is String) {
                var mapData = json.decode(jsonData['data']);
                ezvizEvent.data = EzvizPlayerStatus.fromJson(mapData);
              } else if (jsonData['data'] is Map) {
                ezvizEvent.data = EzvizPlayerStatus.fromJson(jsonData['data']);
              }
            } catch (e) {
              ezvizLog("Error parsing player status: $e");
              // Create a default status if parsing fails
              ezvizEvent.data = EzvizPlayerStatus(
                status: 5,
                message: "Parse error: $e",
              );
            }
          }
          event(ezvizEvent);
        }
      }
    }, onError: error);
  }

  /// 停止EventHandler
  void removePlayerEventHandler() {
    if (_dataSubscription != null) {
      _dataSubscription?.cancel();
    }
  }

  /// 初始化播放器
  /// - Parameters:
  ///   - deviceSerial: 设备序列号
  ///   - cameraNo: 通道号
  Future<void> initPlayerByDevice(String deviceSerial, int cameraNo) async {
    final data = <String, dynamic>{
      'deviceSerial': deviceSerial,
      'cameraNo': cameraNo,
    };
    try {
      await _channel.invokeMethod(
        EzvizPlayerChannelMethods.initPlayerByDevice,
        data,
      );
      print("INITED");
    } catch (e) {
      print("ERROR: $e");
    }
  }

  /// 初始化播放器
  /// - Parameters:
  ///   - url: 直播地址
  Future<void> initPlayerByUrl(String url) async {
    final data = <String, dynamic>{'url': url};
    await _channel.invokeMethod(EzvizPlayerChannelMethods.initPlayerUrl, data);
  }

  /// 初始化局域网播放器
  /// - Parameters:
  ///   - userId: 用户ID
  ///   - cameraNo: 通道号
  ///   - streamType: 码流类型 1:主码流 2:子码流
  Future<void> initPlayerByUser(
    int userId,
    int cameraNo,
    int streamType,
  ) async {
    if (!EzvizStreamTypes.isStreamType(streamType)) {
      ezvizLog('不合法的参数: streamType');
      return;
    }
    final data = <String, dynamic>{
      'userId': userId,
      'cameraNo': cameraNo,
      'streamType': streamType,
    };
    await _channel.invokeMethod(
      EzvizPlayerChannelMethods.initPlayerByUser,
      data,
    );
  }

  /// 开启直播
  Future<bool> startRealPlay() async {
    return await _channel.invokeMethod(EzvizPlayerChannelMethods.startRealPlay);
  }

  /// 结束直播
  Future<bool> stopRealPlay() async {
    return await _channel.invokeMethod(EzvizPlayerChannelMethods.stopRealPlay);
  }

  /// 开始回放
  Future<bool> startReplay(DateTime startTime, DateTime endTime) async {
    final data = <String, dynamic>{
      'startTime': dateToStr(startTime),
      'endTime': dateToStr(endTime),
    };
    return await _channel.invokeMethod(
      EzvizPlayerChannelMethods.startReplay,
      data,
    );
  }

  /// 停止回放
  Future<bool> stopReplay() async {
    return await _channel.invokeMethod(EzvizPlayerChannelMethods.stopReplay);
  }

  /// 释放播放器
  Future<void> release() async {
    _channel.invokeMethod(EzvizPlayerChannelMethods.playerRelease);
  }

  /// 设置视频解码密码
  Future<void> setPlayVerifyCode(String verifyCode) async {
    final data = <String, dynamic>{'verifyCode': verifyCode};
    await _channel.invokeMethod(
      EzvizPlayerChannelMethods.setPlayVerifyCode,
      data,
    );
  }

  /// 暂停回放
  Future<bool> pausePlayback() async {
    return await _channel.invokeMethod(EzvizPlayerChannelMethods.pausePlayback);
  }

  /// 恢复回放
  Future<bool> resumePlayback() async {
    return await _channel.invokeMethod(
      EzvizPlayerChannelMethods.resumePlayback,
    );
  }

  /// 开启声音
  Future<bool> openSound() async {
    return await _channel.invokeMethod('openSound');
  }

  /// 关闭声音
  Future<bool> closeSound() async {
    return await _channel.invokeMethod('closeSound');
  }

  /// 截屏
  Future<String?> capturePicture() async {
    try {
      final result = await _channel.invokeMethod('capturePicture');
      return result as String?;
    } catch (e) {
      print('Error capturing picture: $e');
      return null;
    }
  }

  /// 开始录像
  Future<bool> startRecording() async {
    try {
      return await _channel.invokeMethod('startRecording');
    } catch (e) {
      print('Error starting recording: $e');
      return false;
    }
  }

  /// 停止录像
  Future<bool> stopRecording() async {
    try {
      return await _channel.invokeMethod('stopRecording');
    } catch (e) {
      print('Error stopping recording: $e');
      return false;
    }
  }

  /// 获取录像状态
  Future<bool> isRecording() async {
    try {
      return await _channel.invokeMethod('isRecording');
    } catch (e) {
      print('Error getting recording status: $e');
      return false;
    }
  }
}

/// 萤石云播放器
class EzvizPlayer extends StatefulWidget {
  final EzvizPlayerCreatedCallback onCreated;

  const EzvizPlayer({super.key, required this.onCreated});

  @override
  State<EzvizPlayer> createState() => _EzvizPlayerState();
}

class _EzvizPlayerState extends State<EzvizPlayer>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  bool _isDisposed = false;
  EzvizPlayerController? _controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _isDisposed = true;
    WidgetsBinding.instance.removeObserver(this);
    _controller?.removePlayerEventHandler();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Handle app lifecycle to prevent surface issues
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _controller?.removePlayerEventHandler();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_isDisposed) {
      return Container(color: Colors.black);
    }

    return Container(
      color: Colors.black45,
      child: SafeArea(child: _buildSafePlatformView()),
    );
  }

  Widget _buildSafePlatformView() {
    try {
      return Container(
        constraints: BoxConstraints(
          minWidth: 1.0,
          minHeight: 1.0,
          maxWidth: double.infinity,
          maxHeight: double.infinity,
        ),
        child: nativeView(),
      );
    } catch (e) {
      print('Error building platform view: $e');
      return Container(
        color: Colors.black,
        child: Center(
          child: Text(
            'Video player unavailable',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  Widget nativeView() {
    // Support both dart:io Platform and Flutter's defaultTargetPlatform to
    // keep behavior correct across devices and host environments.
    final bool isAndroid =
        !kIsWeb &&
        (Platform.isAndroid || defaultTargetPlatform == TargetPlatform.android);
    final bool isIOS =
        !kIsWeb &&
        (Platform.isIOS || defaultTargetPlatform == TargetPlatform.iOS);

    if (isAndroid) {
      return AndroidView(
        viewType: EzvizPlayerChannelMethods.methodChannelName,
        onPlatformViewCreated: onPlatformViewCreated,
        creationParamsCodec: const StandardMessageCodec(),
        hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{},
      );
    } else if (isIOS) {
      return UiKitView(
        viewType: EzvizPlayerChannelMethods.methodChannelName,
        onPlatformViewCreated: onPlatformViewCreated,
        creationParamsCodec: const StandardMessageCodec(),
        hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{},
      );
    } else {
      return Text(
        '${kIsWeb ? 'web' : 'Current platform'} is not yet supported by this plugin',
      );
    }
  }

  Future<void> onPlatformViewCreated(id) async {
    if (_isDisposed) return;

    try {
      _controller = EzvizPlayerController(id);
      widget.onCreated(_controller!);
    } catch (e) {
      print('Error creating platform view controller: $e');
      // Create a dummy controller to prevent null reference errors
      _controller = EzvizPlayerController(id);
      widget.onCreated(_controller!);
    }
  }
}
