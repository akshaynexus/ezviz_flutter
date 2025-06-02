//
//  EzvizChannelMethods.swift
//  ezviz_flutter
//
//  Created by 江鴻 on 2019/8/23.
//

import Foundation

// 插件方法名称定义
class EzvizChannelMethods {
    /// 插件入口名称
    static let methodChannelName = "ezviz_flutter";
    /// 获取平台版本号 测试通路使用
    static let platformVersion = "getPlatformVersion";
    /// 初始化SDK
    static let initSDK = "initSDK";
    /// 获取SDK版本号
    static let sdkVersion = "getSdkVersion";
    /// 是否开启日志
    static let enableLog = "enableLog";
    /// 是否开启P2P
    static let enableP2P = "enableP2P";
    /// 设置accessToken
    static let setAccessToken = "setAccessToken";
    /// 获取设备信息
    static let deviceInfo = "getDeviceInfo";
    /// 获取设备信息列表
    static let deviceInfoList = "getDeviceInfoList";
    /// 设置视频通道清晰度
    static let setVideoLevel = "setVideoLevel";
    /// 云台控制
    static let controlPTZ = "controlPTZ";
    /// 登录网络设备
    static let loginNetDevice = "loginNetDevice";
    /// 登出网络设备
    static let logoutNetDevice = "logoutNetDevice";
    /// NetDevice 云台控制
    static let netControlPTZ = "netControlPTZ";
}

// 插件事件名称定义
class EzvizChannelEvents {
    /// 插件event入口名称
    static let eventChannelName = "ezviz_flutter_event";
}

// 插件播放器方法名称定义
class EzvizPlayerChannelMethods {
    /// 插件播放器入口名称
    static let methodChannelName = "ezviz_flutter_player";
    /// 初始化播放器设备(设备信息)
    static let initPlayerByDevice = "initPlayerByDevice";
    /// 初始化播放器设备(Url)
    static let initPlayerUrl = "initPlayerUrl";
    /// 初始化播放器设备(用户信息)
    static let initPlayerByUser = "initPlayerByUser";
    /// 开始直播
    static let startRealPlay = "startRealPlay";
    /// 结束直播
    static let stopRealPlay = "stopRealPlay";
    /// 开始回播
    static let startReplay = "startReplay";
    /// 结束回播
    static let stopReplay = "stopReplay";
    /// 释放播放器
    static let playerRelease = "playerRelease";
    /// 设置播放密码
    static let setPlayVerifyCode = "setPlayVerifyCode";
}

// 插件事件名称定义
class EzvizPlayerChannelEvents {
    /// 插件event入口名称
    static let eventChannelName = "ezviz_flutter_player_event";
    /// 播放器状态事件
    static let playerStatusChange = "playerStatusChange";
}
