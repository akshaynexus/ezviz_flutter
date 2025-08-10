//
//  EzvizManager.swift
//  ezviz_flutter
//
//  Created by 江鴻 on 2019/8/24.
//
import Foundation
import Flutter

// Conditionally import EZVIZ SDK only for device builds
#if !targetEnvironment(simulator)
import EZOpenSDKFramework
#endif


class EzvizManager {
    /// 获取SDK版本号
    static func sdkVersion(result: @escaping FlutterResult) {
        #if !targetEnvironment(simulator)
        result(EZGlobalSDK.getVersion())
        #else
        result("STUB-1.0.0-Simulator")
        #endif
    }
    
    /// 初始化SDK
    static func initSDK(_ arguments: Any?,result: @escaping FlutterResult) {
        #if !targetEnvironment(simulator)
        if let map = arguments as? Dictionary<String, Any> {
            let appKey = map["appKey"] as? String ?? AppKey
            let accessToken = map["accessToken"] as? String ?? AccessToken
            let enableLog = map["enableLog"] as? Bool ?? false
            let enableP2P = map["enableP2P"] as? Bool ?? false
            let baseUrl = map["baseUrl"] as? String
            let defaultBaseUrl = "https://open.ezvizlife.com"
            let ret = EZGlobalSDK.initLib(withAppKey: appKey, url: baseUrl ?? defaultBaseUrl, authUrl: baseUrl ?? defaultBaseUrl)
            EZGlobalSDK.setAccessToken(accessToken)
            EZGlobalSDK.setDebugLogEnable(enableLog)
            EZGlobalSDK.enableP2P(enableP2P)
            EZHCNetDeviceSDK.initSDK()
            result(ret)
        }else {
            result(false)
        }
        #else
        // Simulator stub - always return success
        result(true)
        #endif
    }
    
    /// 是否开启日志
    static func enableLog(_ arguments: Any?) {
        #if !targetEnvironment(simulator)
        if let map = arguments as? Dictionary<String, Any> {
            if let debug = map["enableLog"] as? Bool {
                EZGlobalSDK.setDebugLogEnable(debug)
            }
        }
        #else
        // Simulator stub - do nothing
        #endif
    }
    
    /// 是否开启P2P
    static func enableP2P(_ arguments: Any?) {
        #if !targetEnvironment(simulator)
        if let map = arguments as? Dictionary<String, Any> {
            if let enableP2P = map["enableP2P"] as? Bool {
                EZGlobalSDK.enableP2P(enableP2P)
            }
        }
        #else
        // Simulator stub - do nothing
        #endif
    }
    
    /// 设置Token
    static func setAccessToken(_ arguments: Any?) {
        #if !targetEnvironment(simulator)
        if let map = arguments as? Dictionary<String, Any> {
            if let accessToken = map["accessToken"] as? String {
                EZGlobalSDK.setAccessToken(accessToken)
            }
        }
        #else
        // Simulator stub - do nothing
        #endif
    }

    static func getDeviceInfo(_ arguments: Any?, result: @escaping FlutterResult) {
        #if !targetEnvironment(simulator)
        if let map = arguments as? [String: Any],
           let deviceSerial = map["deviceSerial"] as? String {
            EZGlobalSDK.getDeviceInfo(deviceSerial) { device, error in
                if let error = error {
                    ezvizLog(msg: error.localizedDescription)
                    result(nil)
                } else {
                    result(device.toJSON())
                }
            }
        } else {
            result(nil)
        }
        #else
        // Simulator stub
        result(["error": "Simulator mode - device info unavailable"])
        #endif
    }
    
    static func getDeviceInfoList(result: @escaping FlutterResult) {
        #if !targetEnvironment(simulator)
        EZGlobalSDK.getDeviceList(0, pageSize: 100) { (devices, count, error) in
            if let error = error {
                ezvizLog(msg: error.localizedDescription)
                result(FlutterError(code: "GET_DEVICE_LIST_ERROR", message: error.localizedDescription, details: nil))
                return
            }

            guard let devList = devices as? [EZDeviceInfo], !devList.isEmpty else {
                ezvizLog(msg: "Device list is empty or cannot be cast to [EZDeviceInfo]")
                result([])
                return
            }

            let devArr = devList.map { $0.toJSON() }
            result(devArr)
        }
        #else
        // Simulator stub - return empty device list
        result([])
        #endif
    }
    
    /// 设置视频通道分辨率
    static func setVideoLevel(_ arguments: Any?, result: @escaping FlutterResult) {
        #if !targetEnvironment(simulator)
        if let map = arguments as? Dictionary<String, Any> {
            let deviceSerial = map["deviceSerial"] as? String ?? ""
            let cameraId = map["cameraId"] as? Int ?? 0
            let videoLevel = map["videoLevel"] as? Int ?? 0
            // Updated to use the available case name `LevelLow`
            let ezvizVideoLevel = EZVideoLevelType.init(rawValue: videoLevel) ?? EZVideoLevelType.levelLow

            EZGlobalSDK.setVideoLevel(deviceSerial, cameraNo: cameraId, videoLevel: ezvizVideoLevel) { (error) in
                if let err = error {
                    ezvizLog(msg: err.localizedDescription)
                    result(false)
                } else {
                    result(true)
                }
            }
        }
        #else
        // Simulator stub
        result(false)
        #endif
    }
    
    /// 云台控制
    static func controlPTZ(_ arguments: Any?, result: @escaping FlutterResult) {
        #if !targetEnvironment(simulator)
        if let map = arguments as? Dictionary<String, Any> {
            let deviceSerial = map["deviceSerial"] as? String ?? ""
            let cameraId = map["cameraId"] as? Int ?? 0
            let command = map["command"] as? String ?? ""
            let action = map["action"] as? String ?? ""
            let speed = map["speed"] as? Int ?? 0
            
            if let cmd = PTZKeys[command] as? EZPTZCommand{
                if let act = PTZKeys[action] as? EZPTZAction {
                    EZGlobalSDK.controlPTZ(deviceSerial, cameraNo: cameraId, command: cmd, action: act, speed: speed) { (error) in
                        if let err = error {
                            ezvizLog(msg: err.localizedDescription)
                            result(false)
                        }else {
                            result(true)
                        }
                    }
                    
                }else {
                    ezvizLog(msg: "action字符串不合法")
                    result(false)
                }
            }else {
                ezvizLog(msg: "command字符串不合法")
                result(false)
            }
        }
        #else
        // Simulator stub
        result(false)
        #endif
    }
}


// MARK: - 网络设备相关操作
#if !targetEnvironment(simulator)
extension EzvizManager {
    
    /// 登录网络设备
    static func loginNetDevice(_ arguments: Any?, result: @escaping FlutterResult) {
        if let map = arguments as? Dictionary<String, Any> {
            let userId = map["userId"] as? String ?? ""
            let pwd = map["pwd"] as? String ?? ""
            let ipAddr = map["ipAddr"] as? String ?? ""
            let port = map["port"] as? Int ?? 0
            
            DispatchQueue.global().async {
                let deviceInfo = EZHCNetDeviceSDK.loginDevice(withUerName: userId, pwd: pwd, ipAddr: ipAddr, port: port)
                
                DispatchQueue.main.async {
                    if let dev = deviceInfo {
                        result(dev.toJSON())
                    }else {
                        ezvizLog(msg: "无法登陆设备")
                        result(nil)
                    }
                }
            }
        }
    }
    
    /// 登出网络设备
    static func logoutNetDevice(_ arguments: Any?, result: @escaping FlutterResult) {
        if let map = arguments as? Dictionary<String, Any> {
            let userId = map["userId"] as? Int ?? 0
            result(EZHCNetDeviceSDK.logoutDevice(withUserId: userId))
        }
    }
    
    /// 网络设备云台控制
    static func netControlPTZ(_ arguments: Any?, result: @escaping FlutterResult) {
        if let map = arguments as? Dictionary<String, Any> {
            let userId = map["userId"] as? Int ?? 0
            let channelNo = map["channelNo"] as? Int ?? 0
            let command = map["command"] as? String ?? ""
            let action = map["action"] as? String ?? ""
            
            if let cmd = netPTZKeys[command] as? EZPTZCommandType{
                if let act = netPTZKeys[action] as? EZPTZActionType {
                    DispatchQueue.global().async {
                        let ret = EZHCNetDeviceSDK.ptzControl(withUserId: userId, channelNo: channelNo, command: cmd, action: act)
                        DispatchQueue.main.async {
                            result(ret)
                        }
                    }
                    
                }else {
                    ezvizLog(msg: "action字符串不合法")
                    result(false)
                }
            }else {
                ezvizLog(msg: "command字符串不合法")
                result(false)
            }
        }
    }
    
}
#else
// Simulator stubs for network device operations
extension EzvizManager {
    static func loginNetDevice(_ arguments: Any?, result: @escaping FlutterResult) {
        result(nil)
    }
    
    static func logoutNetDevice(_ arguments: Any?, result: @escaping FlutterResult) {
        result(false)
    }
    
    static func netControlPTZ(_ arguments: Any?, result: @escaping FlutterResult) {
        result(false)
    }
}
#endif
