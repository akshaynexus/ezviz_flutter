package com.akshaynexus.ezviz_flutter.ezviz_flutter

// 插件方法名称定义
internal object EzvizChannelMethods {
    /// 插件入口名称
    val methodChannelName = "ezviz_flutter"
    /// 获取平台版本号 测试通路使用
    val platformVersion = "getPlatformVersion"
    /// 初始化SDK
    val initSDK = "initSDK"
    /// 获取SDK版本号
    val sdkVersion = "getSdkVersion"
    /// 是否开启日志
    val enableLog = "enableLog"
    /// 是否开启P2P
    val enableP2P = "enableP2P"
    /// 设置accessToken
    val setAccessToken = "setAccessToken"
    /// 获取设备信息
    val deviceInfo = "getDeviceInfo"
    /// 获取设备信息列表
    val deviceInfoList = "getDeviceInfoList"
    /// 设置视频通道清晰度
    val setVideoLevel = "setVideoLevel"
    /// 云台控制
    val controlPTZ = "controlPTZ"
    /// 登录网络设备
    val loginNetDevice = "loginNetDevice"
    /// 登出网络设备
    val logoutNetDevice = "logoutNetDevice"
    /// NetDevice 云台控制
    val netControlPTZ = "netControlPTZ"
}

// 插件事件名称定义
internal object EzvizChannelEvents {
    /// 插件event入口名称
    val eventChannelName = "ezviz_flutter_event"
}

// 插件播放器方法名称定义
internal object EzvizPlayerChannelMethods {
    /// 插件播放器入口名称
    val methodChannelName = "ezviz_flutter_player"
    /// 初始化播放器设备(设备信息)
    val initPlayerByDevice = "initPlayerByDevice"
    /// 初始化播放器设备(Url)
    val initPlayerUrl = "initPlayerUrl"
    /// 初始化播放器设备(用户信息)
    val initPlayerByUser = "initPlayerByUser"
    /// 开始直播
    val startRealPlay = "startRealPlay"
    /// 结束直播
    val stopRealPlay = "stopRealPlay"
    /// 开始回播
    val startReplay = "startReplay"
    /// 结束回播
    val stopReplay = "stopReplay"
    /// 释放播放器
    val playerRelease = "playerRelease"
    /// 设置播放密码
    val setPlayVerifyCode = "setPlayVerifyCode"
}

// 插件事件名称定义
internal object EzvizPlayerChannelEvents {
    /// 插件event入口名称
    val eventChannelName = "ezviz_flutter_player_event"
    /// 播放器状态事件
    val playerStatusChange = "playerStatusChange"
}
