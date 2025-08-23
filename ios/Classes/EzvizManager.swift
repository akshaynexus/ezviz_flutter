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
    // Voice talk player instance
    #if !targetEnvironment(simulator)
    private static var voiceTalkPlayer: EZPlayer?
    #endif
    
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
            _ = EZGlobalSDK.getDeviceInfo(deviceSerial) { (deviceInfo, error) in
                if let error = error {
                    ezvizLog(msg: error.localizedDescription)
                    result(nil)
                } else {
                    result(deviceInfo.toJSON())
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
    
    /// Start voice talk/intercom
    static func startVoiceTalk(_ arguments: Any?, result: @escaping FlutterResult) {
        guard let map = arguments as? Dictionary<String, Any> else {
            result(false)
            return
        }
        
        let deviceSerial = map["deviceSerial"] as? String ?? ""
        let verifyCode = map["verifyCode"] as? String
        let cameraNo = map["cameraNo"] as? Int ?? 1
        
        DispatchQueue.global().async {
            // Stop any existing voice talk
            if let existingPlayer = voiceTalkPlayer {
                existingPlayer.stopVoiceTalk()
                existingPlayer.destoryPlayer()
                voiceTalkPlayer = nil
            }
            
            // Create voice talk player
            voiceTalkPlayer = EZGlobalSDK.createPlayer(withDeviceSerial: deviceSerial, cameraNo: cameraNo)
            
            // Set verification code if provided
            if let code = verifyCode {
                voiceTalkPlayer?.setPlayVerifyCode(code)
            }
            
            // Start voice talk
            let success = voiceTalkPlayer?.startVoiceTalk() ?? false
            
            DispatchQueue.main.async {
                result(success)
            }
        }
    }
    
    /// Stop voice talk/intercom
    static func stopVoiceTalk(result: @escaping FlutterResult) {
        DispatchQueue.global().async {
            let success: Bool
            if let player = voiceTalkPlayer {
                success = player.stopVoiceTalk()
                player.destoryPlayer()
                voiceTalkPlayer = nil
            } else {
                success = true // Nothing to stop
            }
            
            DispatchQueue.main.async {
                result(success)
            }
        }
    }
    
    /// Get device list with pagination - simplified version
    static func getDeviceList(_ arguments: Any?, result: @escaping FlutterResult) {
        guard let map = arguments as? Dictionary<String, Any> else {
            result([])
            return
        }
        
        let pageStart = map["pageStart"] as? Int ?? 0
        let pageSize = map["pageSize"] as? Int ?? 10
        
        // Use the existing getDeviceInfoList method for simplicity
        EZGlobalSDK.getDeviceList(pageStart, pageSize: pageSize) { (deviceList, totalCount, error) in
            if let error = error {
                result([])
                return
            }
            
            guard let devices = deviceList as? [EZDeviceInfo] else {
                result([])
                return
            }
            
            let deviceInfoList = devices.map { device in
                return device.toJSON()
            }
            
            result(deviceInfoList)
        }
    }
    
    /// Add device - simplified version
    static func addDevice(_ arguments: Any?, result: @escaping FlutterResult) {
        guard let map = arguments as? Dictionary<String, Any>,
              let deviceSerial = map["deviceSerial"] as? String else {
            result(false)
            return
        }
        
        let verifyCode = map["verifyCode"] as? String ?? ""
        
        EZGlobalSDK.addDevice(deviceSerial, verifyCode: verifyCode) { error in
            result(error == nil)
        }
    }
    
    /// Delete device - simplified version
    static func deleteDevice(_ arguments: Any?, result: @escaping FlutterResult) {
        guard let map = arguments as? Dictionary<String, Any>,
              let deviceSerial = map["deviceSerial"] as? String else {
            result(false)
            return
        }
        
        EZGlobalSDK.deleteDevice(deviceSerial) { error in
            result(error == nil)
        }
    }
    
    /// Probe device info
    static func probeDeviceInfo(_ arguments: Any?, result: @escaping FlutterResult) {
        #if !targetEnvironment(simulator)
        guard let map = arguments as? Dictionary<String, Any>,
              let deviceSerial = map["deviceSerial"] as? String else {
            result(nil)
            return
        }
        
        // Follow the same pattern as getDeviceInfo - single parameter method
        _ = EZGlobalSDK.getDeviceInfo(deviceSerial) { (deviceInfo, error) in
            if let error = error {
                result(nil)
                return
            }
            
            // Create probe info map from device info
            let probeInfoMap = [
                "deviceSerial": deviceInfo.deviceSerial ?? "",
                "deviceName": deviceInfo.deviceName ?? "",
                "deviceType": deviceInfo.deviceType ?? "",
                "status": deviceInfo.status,
                "supportWifi": deviceInfo.supportWifi,
                "netType": deviceInfo.netType ?? "Unknown"
            ] as [String : Any]
            
            result(probeInfoMap)
        }
        #else
        // Simulator stub
        result(nil)
        #endif
    }
    
    /// Open login page
    static func openLoginPage(_ arguments: Any?, result: @escaping FlutterResult) {
        let map = arguments as? Dictionary<String, Any>
        let areaId = map?["areaId"] as? String
        
        if let areaId = areaId {
            EZGlobalSDK.openLoginPage(areaId) { (accessToken) in
                result(true)
            }
        } else {
            EZGlobalSDK.openLoginPage("") { (accessToken) in
                result(true)
            }
        }
    }
    
    /// Logout
    static func logout(result: @escaping FlutterResult) {
        EZGlobalSDK.logout { error in
            result(error == nil)
        }
    }
    
    /// Get access token
    static func getAccessToken(result: @escaping FlutterResult) {
        _ = EZGlobalSDK.getUserInfo { (userInfo, error) in
            if let error = error {
                result(nil)
                return
            }
            
            let tokenMap = [
                "accessToken": userInfo.username ?? "",
                "expireTime": 0
            ] as [String : Any]
            result(tokenMap)
        }
    }
    
    /// Get area list
    static func getAreaList(result: @escaping FlutterResult) {
        EZGlobalSDK.getAreaList { (areaList, error) in
            if let error = error {
                result([])
                return
            }
            
            guard let areas = areaList as? [EZAreaInfo] else {
                result([])
                return
            }
            
            let areaInfoList = areas.map { area in
                return [
                    "areaId": String(area.id),
                    "areaName": area.name ?? ""
                ]
            }
            result(areaInfoList)
        }
    }
    
    /// Set server URL
    static func setServerUrl(_ arguments: Any?, result: @escaping FlutterResult) {
        guard let map = arguments as? Dictionary<String, Any>,
              let apiUrl = map["apiUrl"] as? String,
              let authUrl = map["authUrl"] as? String else {
            result(false)
            return
        }
        
        _ = EZGlobalSDK.initLib(withAppKey: "", url: apiUrl, authUrl: authUrl)
        result(true)
    }
    
    /// Search record files from cloud
    static func searchRecordFile(_ arguments: Any?, result: @escaping FlutterResult) {
        guard let map = arguments as? Dictionary<String, Any>,
              let deviceSerial = map["deviceSerial"] as? String else {
            result([])
            return
        }
        
        let cameraNo = map["cameraNo"] as? Int ?? 1
        let startTime = Date(timeIntervalSince1970: (map["startTime"] as? Double ?? 0) / 1000)
        let endTime = Date(timeIntervalSince1970: (map["endTime"] as? Double ?? 0) / 1000)
        let recType = map["recType"] as? Int ?? 0
        
        _ = EZGlobalSDK.searchRecordFile(fromCloud: deviceSerial, 
                                        cameraNo: cameraNo, 
                                        beginTime: startTime, 
                                        endTime: endTime) { (recordFiles, error) in
            if let files = recordFiles as? [EZCloudRecordFile] {
                let recordFileList = files.map { file in
                    return [
                        "fileName": file.fileId ?? "",
                        "startTime": Int(file.startTime?.timeIntervalSince1970 ?? 0) * 1000,
                        "endTime": Int(file.stopTime?.timeIntervalSince1970 ?? 0) * 1000,
                        "fileSize": 0,
                        "recType": (file.encryption != nil && file.encryption!.count > 0) ? 1 : 0
                    ] as [String : Any]
                }
                result(recordFileList)
            } else {
                result([])
            }
        }
    }
    
    /// Search record files from device
    static func searchDeviceRecordFile(_ arguments: Any?, result: @escaping FlutterResult) {
        guard let map = arguments as? Dictionary<String, Any>,
              let deviceSerial = map["deviceSerial"] as? String else {
            result([])
            return
        }
        
        let cameraNo = map["cameraNo"] as? Int ?? 1
        let startTime = Date(timeIntervalSince1970: (map["startTime"] as? Double ?? 0) / 1000)
        let endTime = Date(timeIntervalSince1970: (map["endTime"] as? Double ?? 0) / 1000)
        
        _ = EZGlobalSDK.searchRecordFile(fromDevice: deviceSerial, 
                                        cameraNo: cameraNo, 
                                        beginTime: startTime, 
                                        endTime: endTime) { (recordFiles, error) in
            if let files = recordFiles as? [EZDeviceRecordFile] {
                let recordFileList = files.map { file in
                    return [
                        "fileName": "",
                        "startTime": Int(file.startTime?.timeIntervalSince1970 ?? 0) * 1000,
                        "endTime": Int(file.stopTime?.timeIntervalSince1970 ?? 0) * 1000,
                        "fileSize": 0
                    ] as [String : Any]
                }
                result(recordFileList)
            } else {
                result([])
            }
        }
    }
    
    /// Start WiFi configuration
    static func startConfigWifi(_ arguments: Any?, result: @escaping FlutterResult) {
        // WiFi configuration requires proper context and callback setup
        result(false)
    }
    
    /// Stop WiFi configuration
    static func stopConfigWifi(result: @escaping FlutterResult) {
        EZGlobalSDK.stopConfigWifi()
        result(true)
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
    
    static func startVoiceTalk(_ arguments: Any?, result: @escaping FlutterResult) {
        result(false) // Simulator stub
    }
    
    static func stopVoiceTalk(result: @escaping FlutterResult) {
        result(false) // Simulator stub
    }
    
    // All the device management methods as simulator stubs
    static func getDeviceList(_ arguments: Any?, result: @escaping FlutterResult) {
        result([]) // Empty device list for simulator
    }
    
    static func addDevice(_ arguments: Any?, result: @escaping FlutterResult) {
        result(false) // Simulator stub
    }
    
    static func deleteDevice(_ arguments: Any?, result: @escaping FlutterResult) {
        result(false) // Simulator stub
    }
    
    static func probeDeviceInfo(_ arguments: Any?, result: @escaping FlutterResult) {
        result(nil) // Simulator stub
    }
    
    static func openLoginPage(_ arguments: Any?, result: @escaping FlutterResult) {
        result(false) // Simulator stub
    }
    
    static func logout(result: @escaping FlutterResult) {
        result(false) // Simulator stub
    }
    
    static func getAccessToken(result: @escaping FlutterResult) {
        result(nil) // Simulator stub
    }
    
    static func getAreaList(result: @escaping FlutterResult) {
        result([]) // Simulator stub
    }
    
    static func setServerUrl(_ arguments: Any?, result: @escaping FlutterResult) {
        result(false) // Simulator stub
    }
    
    static func searchRecordFile(_ arguments: Any?, result: @escaping FlutterResult) {
        result([]) // Simulator stub
    }
    
    static func searchDeviceRecordFile(_ arguments: Any?, result: @escaping FlutterResult) {
        result([]) // Simulator stub
    }
    
    static func startConfigWifi(_ arguments: Any?, result: @escaping FlutterResult) {
        result(false) // Simulator stub
    }
    
    static func stopConfigWifi(result: @escaping FlutterResult) {
        result(false) // Simulator stub
    }
}
#endif