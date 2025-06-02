//
//  EZvizPlayer.swift
//  RNZyEZGlobalSDK
//
//  Created by Jayson on 2019/7/16.
//

import Foundation
import EZOpenSDKFramework

/// 播放状态
///
/// - Idle: 空闲状态，默认状态
/// - Init: 初始化状态
/// - Start: 播放状态
/// - Pause: 暂停状态(回放才有暂停状态)
/// - Stop: 停止状态
/// - Error: 错误状态
enum EzvizPlayerStatus: UInt {
    case Idle   = 0
    case Init   = 1
    case Start  = 2
    case Pause  = 3
    case Stop   = 4
    case Error  = 9
}

/// 播放View
class EzvizPlayer : UIView {

    private var play: EZPlayer?
    private var deviceSerial: String?
    private var cameraNo: Int = 0
    private var url: String?
    /// 播放状态
    private var status: EzvizPlayerStatus = .Idle
    
    deinit {
        self.play?.destoryPlayer()
        self.setPlayerStatus(.Idle, msg: nil)
    }
    
    func initPlayer(deviceSerial: String, cameraNo: Int) {
        playerRelease()
        self.url = nil
        self.deviceSerial = deviceSerial
        self.cameraNo = cameraNo
        self.play = EZGlobalSDK.createPlayer(withDeviceSerial: deviceSerial, cameraNo: cameraNo)
        self.play?.setPlayerView(self)
        self.play?.delegate = self
        self.setPlayerStatus(.Init, msg: nil)
    }
    
    func initPlayer(url: String) {
        playerRelease()
        self.url = url
        self.deviceSerial = nil
        self.cameraNo = 0
        self.play = EZGlobalSDK.createPlayer(withUrl: url)
        self.play?.setPlayerView(self)
        self.play?.delegate = self
        self.setPlayerStatus(.Init, msg: nil)
    }
    
    ///
    /// 局域网设备创建播放器接口
    ///
    /// - Parameters:
    ///   - userId: 用户id，登录局域网设备后获取
    ///   - cameraNo: 通道号
    ///   - streamType: 码流类型 1:主码流 2:子码流
    func initPlayer(userId: Int, cameraNo : Int, streamType: Int) {
        playerRelease()
        self.url = nil
        self.deviceSerial = nil
        self.cameraNo = 0
        self.play = EZPlayer.createPlayer(withUserId: userId, cameraNo: cameraNo, streamType: streamType)
        self.play?.setPlayerView(self)
        self.play?.delegate = self
        self.setPlayerStatus(.Init, msg: nil)
    }
    
    func startRealPlay() -> Bool{
        guard self.play != nil else {
            return false
        }
        self.setPlayerStatus(.Start, msg: nil)
        return self.play!.startRealPlay()
    }
    
    func stopRealPlay() -> Bool {
        guard self.play != nil else {
            return false
        }
        setPlayerStatus(.Stop, msg: nil)
        return self.play!.stopRealPlay()
    }
    
    func startReplay(startTime:Date, endTime:Date) -> Bool {
        
        guard deviceSerial != nil && self.play != nil else {
            return false
        }
        var playResult = false
        
        DispatchQueue.global().async {[weak self] in
            EZGlobalSDK.searchRecordFile(fromDevice: self?.deviceSerial ?? "", cameraNo: self?.cameraNo ?? 0, beginTime: startTime, endTime: endTime) { (fileList, error) in
                if let fileList = fileList as? [EZDeviceRecordFile], let record = fileList.first {
                    let playResult = self?.play?.startPlayback(fromDevice: record) ?? false
                    if playResult {
                        self?.setPlayerStatus(.Start, msg: nil)
                    } else {
                        self?.setPlayerStatus(.Error, msg: "Can't start playback")
                    }
                } else {
                    self?.setPlayerStatus(.Error, msg: "Record list is empty")
                }
            }
        }
        
        return playResult
    }
    
    func stopReplay() -> Bool{
        guard self.play != nil else {
            return false
        }
        setPlayerStatus(.Stop, msg: nil)
        return self.play!.stopPlayback()
    }
    
    func playerRelease() {
        self.play?.destoryPlayer()
        self.play = nil
        setPlayerStatus(.Idle, msg: nil)
    }
    
    /// 播放器解码密码
    ///
    /// - Parameter verifyCode: 密码
    func setPlayVerifyCode(_ verifyCode: String) {
        ezvizLog(msg: "Setting play verify code for encrypted camera")
        guard let player = self.play else {
            ezvizLog(msg: "Player not initialized when setting verify code")
            setPlayerStatus(.Error, msg: "Player not ready for verification code")
            return
        }
        player.setPlayVerifyCode(verifyCode)
    }
    
    /// 开启声音
    func openSound() -> Bool {
        return self.play?.openSound() ?? false
    }
    
    /// 关闭声音
    func closeSound() -> Bool {
        return self.play?.closeSound() ?? false
    }
    
    /// 截屏
    func capturePicture() -> String? {
        ezvizLog(msg: "Capture picture not implemented in current SDK version")
        return nil
    }
    
    /// 开始录像
    func startRecording() -> Bool {
        ezvizLog(msg: "Start recording not implemented in current SDK version")
        return false
    }
    
    /// 停止录像
    func stopRecording() -> Bool {
        ezvizLog(msg: "Stop recording not implemented in current SDK version")
        return false
    }
    
    /// 获取录像状态
    func isRecording() -> Bool {
        return false
    }
    
    private func setPlayerStatus(_ status: EzvizPlayerStatus, msg: String?) {
        self.status = status
        NotificationCenter.default.post(name: .EzvizPlayStatusChanged, object: nil, userInfo: [
            "status": status.rawValue,
            "message": msg ?? "",
            ])
    }
    
}

// MARK: - EZPlayerDelegate
extension EzvizPlayer : EZPlayerDelegate {
    func player(_ player: EZPlayer!, didPlayFailed error: Error!) {
        let errorMsg = error.localizedDescription
        ezvizLog(msg: "Player failed with error: \(errorMsg)")
        
        // Check if error is related to encryption
        let errorStr = errorMsg.lowercased()
        if errorStr.contains("password") || errorStr.contains("verification") || 
           errorStr.contains("encrypt") || errorStr.contains("verify") {
            ezvizLog(msg: "Detected encryption-related error")
            setPlayerStatus(.Error, msg: "Verification code error: \(errorMsg)")
        } else {
            setPlayerStatus(.Error, msg: errorMsg)
        }
    }
    
    func player(_ player: EZPlayer!, didReceivedMessage messageCode: Int) {
        ezvizLog(msg: "Player message code: \(messageCode)")
        
        // Handle specific message codes that might indicate encryption issues
        // Note: These codes may vary based on SDK version
        if messageCode < 0 {
            ezvizLog(msg: "Received error message code: \(messageCode)")
        }
    }
    
    func player(_ player: EZPlayer!, didReceivedDataLength dataLength: Int) {
        // Only log this in debug mode as it's very frequent
        if dataLength > 0 {
            // Successfully receiving data
        }
    }
    
    func player(_ player: EZPlayer!, didReceivedDisplayHeight height: Int, displayWidth width: Int) {
        ezvizLog(msg: "Video display size: \(width)x\(height)")
    }
}


