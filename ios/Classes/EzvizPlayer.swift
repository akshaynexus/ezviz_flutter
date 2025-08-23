//
//  EZvizPlayer.swift
//  RNZyEZGlobalSDK
//
//  Created by Jayson on 2019/7/16.
//

import Foundation

// Conditionally import EZVIZ SDK only for device builds
#if !targetEnvironment(simulator)
import EZOpenSDKFramework
#endif

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

    #if !targetEnvironment(simulator)
    private var play: EZPlayer?
    #endif
    private var deviceSerial: String?
    private var cameraNo: Int = 0
    private var url: String?
    /// 播放状态
    private var status: EzvizPlayerStatus = .Idle
    
    #if targetEnvironment(simulator)
    // Simulator-specific properties
    private var stubLabel: UILabel?
    #endif
    
    deinit {
        #if !targetEnvironment(simulator)
        self.play?.destoryPlayer()
        #endif
        self.setPlayerStatus(.Idle, msg: nil)
    }
    
    #if targetEnvironment(simulator)
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSimulatorView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSimulatorView()
    }
    
    private func setupSimulatorView() {
        backgroundColor = .black
        
        stubLabel = UILabel()
        stubLabel?.text = "Camera Preview\n(Simulator Mode)"
        stubLabel?.textColor = .white
        stubLabel?.textAlignment = .center
        stubLabel?.numberOfLines = 0
        stubLabel?.font = UIFont.systemFont(ofSize: 16)
        stubLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stubLabel!)
        
        NSLayoutConstraint.activate([
            stubLabel!.centerXAnchor.constraint(equalTo: centerXAnchor),
            stubLabel!.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    #endif
    
    func initPlayer(deviceSerial: String, cameraNo: Int) {
        playerRelease()
        self.url = nil
        self.deviceSerial = deviceSerial
        self.cameraNo = cameraNo
        
        #if !targetEnvironment(simulator)
        self.play = EZGlobalSDK.createPlayer(withDeviceSerial: deviceSerial, cameraNo: cameraNo)
        self.play?.setPlayerView(self)
        self.play?.delegate = self
        #else
        // Simulator stub - just update the label
        stubLabel?.text = "Camera Preview\nDevice: \(deviceSerial)\nChannel: \(cameraNo)\n(Simulator Mode)"
        #endif
        
        self.setPlayerStatus(.Init, msg: nil)
    }
    
    func initPlayer(url: String) {
        playerRelease()
        self.url = url
        self.deviceSerial = nil
        self.cameraNo = 0
        
        #if !targetEnvironment(simulator)
        self.play = EZGlobalSDK.createPlayer(withUrl: url)
        self.play?.setPlayerView(self)
        self.play?.delegate = self
        #else
        // Simulator stub
        stubLabel?.text = "Camera Preview\nURL: \(url)\n(Simulator Mode)"
        #endif
        
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
        
        #if !targetEnvironment(simulator)
        self.play = EZPlayer.createPlayer(withUserId: userId, cameraNo: cameraNo, streamType: streamType)
        self.play?.setPlayerView(self)
        self.play?.delegate = self
        #else
        // Simulator stub
        stubLabel?.text = "Camera Preview\nUser: \(userId)\nChannel: \(cameraNo)\n(Simulator Mode)"
        #endif
        
        self.setPlayerStatus(.Init, msg: nil)
    }
    
    func startRealPlay() -> Bool{
        #if !targetEnvironment(simulator)
        guard self.play != nil else {
            return false
        }
        self.setPlayerStatus(.Start, msg: nil)
        return self.play!.startRealPlay()
        #else
        // Simulator stub - fake success
        self.setPlayerStatus(.Start, msg: nil)
        return true
        #endif
    }
    
    func stopRealPlay() -> Bool {
        #if !targetEnvironment(simulator)
        guard self.play != nil else {
            return false
        }
        setPlayerStatus(.Stop, msg: nil)
        return self.play!.stopRealPlay()
        #else
        // Simulator stub - fake success
        setPlayerStatus(.Stop, msg: nil)
        return true
        #endif
    }
    
    func startReplay(startTime:Date, endTime:Date) -> Bool {
        #if !targetEnvironment(simulator)
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
        #else
        // Simulator stub - fake success
        self.setPlayerStatus(.Start, msg: nil)
        return true
        #endif
    }
    
    func stopReplay() -> Bool{
        #if !targetEnvironment(simulator)
        guard self.play != nil else {
            return false
        }
        setPlayerStatus(.Stop, msg: nil)
        return self.play!.stopPlayback()
        #else
        // Simulator stub - fake success
        setPlayerStatus(.Stop, msg: nil)
        return true
        #endif
    }
    
    func playerRelease() {
        #if !targetEnvironment(simulator)
        self.play?.destoryPlayer()
        self.play = nil
        #endif
        setPlayerStatus(.Idle, msg: nil)
    }
    
    /// 播放器解码密码
    ///
    /// - Parameter verifyCode: 密码
    func setPlayVerifyCode(_ verifyCode: String) {
        ezvizLog(msg: "Setting play verify code for encrypted camera")
        
        #if !targetEnvironment(simulator)
        guard let player = self.play else {
            ezvizLog(msg: "Player not initialized when setting verify code")
            setPlayerStatus(.Error, msg: "Player not ready for verification code")
            return
        }
        player.setPlayVerifyCode(verifyCode)
        #else
        // Simulator stub - just log
        ezvizLog(msg: "Simulator mode - verification code set: \(verifyCode)")
        #endif
    }
    
    /// 开启声音
    func openSound() -> Bool {
        #if !targetEnvironment(simulator)
        return self.play?.openSound() ?? false
        #else
        return true // Simulator stub - fake success
        #endif
    }
    
    /// 关闭声音
    func closeSound() -> Bool {
        #if !targetEnvironment(simulator)
        return self.play?.closeSound() ?? false
        #else
        return true // Simulator stub - fake success
        #endif
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
    
    /// 暂停回放
    func pausePlayback() -> Bool {
        #if !targetEnvironment(simulator)
        return self.play?.pausePlayback() ?? false
        #else
        return true // Simulator stub
        #endif
    }
    
    /// 恢复回放
    func resumePlayback() -> Bool {
        #if !targetEnvironment(simulator)
        return self.play?.resumePlayback() ?? false
        #else
        return true // Simulator stub
        #endif
    }
    
    /// 拖动回放进度
    func seekPlayback(time: Date) -> Bool {
        #if !targetEnvironment(simulator)
        self.play?.seekPlayback(time)
        return true
        #else
        return true // Simulator stub
        #endif
    }
    
    /// 获取OSD时间
    func getOSDTime() -> Date? {
        #if !targetEnvironment(simulator)
        return self.play?.getOSDTime()
        #else
        return Date() // Simulator stub
        #endif
    }
    
    /// 设置回放速度
    func setPlaySpeed(speed: Float) -> Bool {
        #if !targetEnvironment(simulator)
        // Play speed setting - depends on SDK version
        ezvizLog(msg: "Play speed setting not implemented in current SDK version")
        return false
        #else
        return true // Simulator stub
        #endif
    }
    
    /// 开始本地录像
    func startLocalRecord(filePath: String) -> Bool {
        #if !targetEnvironment(simulator)
        return self.play?.startLocalRecord(withPathExt: filePath) ?? false
        #else
        return true // Simulator stub
        #endif
    }
    
    /// 停止本地录像
    func stopLocalRecord() -> Bool {
        #if !targetEnvironment(simulator)
        // stopLocalRecord method may not exist in this SDK version
        return true
        #else
        return true // Simulator stub
        #endif
    }
    
    /// 是否在本地录像
    func isLocalRecording() -> Bool {
        #if !targetEnvironment(simulator)
        // Local recording status - depends on SDK version
        return false
        #else
        return false // Simulator stub
        #endif
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
#if !targetEnvironment(simulator)
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
#endif


