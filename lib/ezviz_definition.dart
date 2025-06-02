/// 插件事件处理
typedef void EzvizOnEvent(EzvizEvent event);

/// 插件事件异常
typedef void EzvizOnError(error);

/// 初始化SDK参数对象
class EzvizInitOptions {
  final String appKey;
  final String accessToken;
  final bool enableLog;
  final bool enableP2P;

  EzvizInitOptions({
    this.appKey = "",
    this.accessToken = "",
    this.enableLog = false,
    this.enableP2P = false,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appKey'] = this.appKey;
    data['accessToken'] = this.accessToken;
    data['enableLog'] = this.enableLog;
    data['enableP2P'] = this.enableP2P;
    return data;
  }
}

/// 网络摄像机设备信息
class EzvizNetDeviceInfo {
  // userID,建立播放器时需要
  final String userId;

  // 数字通道数
  final int dChannelCount;

  // 起始数字通道号，0为无效果
  final int dStartChannelNo;

  // 模拟通道数
  final int channelCount;

  // 起始模拟通道号，0为无效果
  final int startChannelNo;

  // 设备类型
  final int byDVRType;

  EzvizNetDeviceInfo({
    required this.userId,
    this.dChannelCount = 0,
    this.dStartChannelNo = 0,
    this.channelCount = 0,
    this.startChannelNo = 0,
    this.byDVRType = 0,
  });

  factory EzvizNetDeviceInfo.fromJson(Map<String, dynamic> json) {
    return EzvizNetDeviceInfo(
      userId: json['userId'],
      dChannelCount: json['dChannelCount'],
      dStartChannelNo: json['dStartChannelNo'],
      channelCount: json['channelCount'],
      startChannelNo: json['startChannelNo'],
      byDVRType: json['byDVRType'],
    );
  }
}

/// 设备信息
class EzvizDeviceInfo {
  /// 设备串号
  final String deviceSerial;

  /// 设备名称
  final String deviceName;

  /// 是否支持云台控制
  final bool isSupportPTZ;

  /// 摄像机通道号
  final int cameraNum;

  EzvizDeviceInfo({
    required this.deviceSerial,
    required this.deviceName,
    this.isSupportPTZ = false,
    this.cameraNum = 0,
  });

  factory EzvizDeviceInfo.fronJson(Map<String, dynamic> json) {
    return EzvizDeviceInfo(
      deviceSerial: json['deviceSerial'],
      deviceName: json['deviceName'],
      isSupportPTZ: json['isSupportPTZ'],
      cameraNum: json['cameraNum'],
    );
  }
}

/// Event的对象
class EzvizEvent {
  /// event类型 (见EzvizEventNames)
  String eventType;

  /// 信息
  String msg;

  /// 成功后的数据
  dynamic data;

  EzvizEvent(this.eventType, this.msg);

  static EzvizEvent? init(Map<String, dynamic> data) {
    if (data['eventType'] == null) return null;

    return new EzvizEvent(data['eventType'] as String, data['msg'] as String);
  }
}

/// 播放状态对象
class EzvizPlayerStatus {
  /// 状态
  ///   * 0 Idle: 空闲状态，默认状态
  ///   * 1 Init: 初始化状态
  ///   * 2 Start: 播放状态
  ///   * 3 Pause: 暂停状态(回放才有暂停状态)
  ///   * 4 Stop: 停止状态
  ///   * 9 Error: 错误状态
  final int status;

  /// 错误信息，只有在Error状态才不为空
  final String? message;

  EzvizPlayerStatus({required this.status, required this.message});

  factory EzvizPlayerStatus.fromJson(Map<String, dynamic> json) {
    return EzvizPlayerStatus(status: json['status'], message: json['message']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}
