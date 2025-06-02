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
        self.play?.setPlayVerifyCode(verifyCode)
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
        print("播放失败，%@",error.debugDescription)
        setPlayerStatus(.Error, msg: error.localizedDescription)
    }
    
    func player(_ player: EZPlayer!, didReceivedMessage messageCode: Int) {
        print("播放中，messageCode %d",messageCode)
    }
    
    func player(_ player: EZPlayer!, didReceivedDataLength dataLength: Int) {
        print("播放中，dataLength %d",dataLength)
    }
    
    func player(_ player: EZPlayer!, didReceivedDisplayHeight height: Int, displayWidth width: Int) {
        print("播放中，height %d width %d",height,width)
    }
}


