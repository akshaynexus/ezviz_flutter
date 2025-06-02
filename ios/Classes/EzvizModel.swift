//
//  EzvizModel.swift
//  ezviz_flutter
//
//  Created by 江鴻 on 2019/8/24.
//

import Foundation
import EZOpenSDKFramework


let AppKey: String = "888b1f2a00d14aee910d1a7437669a2a"
let AccessToken: String = "at.1zvz23zq4ahu89r1cf1fmlv41s0h8g22-6t4r5o4vql-1hvx6ud-h0myuu18u"

let Action_START = "EZPTZAction_START"
let Action_STOP  = "EZPTZAction_STOP"
let Command_Left = "EZPTZCommand_Left"
let Command_Right = "EZPTZCommand_Right"
let Command_Up = "EZPTZCommand_Up"
let Command_Down = "EZPTZCommand_Down"
let Command_ZoomIn = "EZPTZCommand_ZoomIn"
let Command_ZoomOut = "EZPTZCommand_ZoomOut"

extension EZDeviceInfo {
    func toJSON()-> [String:Any] {
        return [
            "deviceSerial":self.deviceSerial,
            "deviceName":self.deviceName,
            "isSupportPTZ":self.isSupportPTZ,
            "cameraNum":self.cameraNum,
        ]
    }
}

extension EZHCNetDeviceInfo {
    func toJSON()-> [String:Any] {
        return [
            "userId":self.userId,
            "dChannelCount":self.dChannelCount,
            "dStartChannelNo":self.dStartChannelNo,
            "channelCount":self.channelCount,
            "startChannelNo":self.startChannelNo,
            "byDVRType":self.byDVRType,
        ]
    }
}

extension Notification.Name {
    static let EzvizPlayStatusChanged = Notification.Name("EzvizPlayStatusChanged")
}

var PTZKeys: [AnyHashable : Any] = [
    Action_START: EZPTZAction.start,
    Action_STOP: EZPTZAction.stop,
    Command_Left: EZPTZCommand.left,
    Command_Right: EZPTZCommand.right,
    Command_Up: EZPTZCommand.up,
    Command_Down: EZPTZCommand.down,
    Command_ZoomIn: EZPTZCommand.zoomIn,
    Command_ZoomOut: EZPTZCommand.zoomOut,
]

var netPTZKeys: [AnyHashable : Any] = [
    Action_START: EZPTZActionType.START,
    Action_STOP: EZPTZActionType.STOP,
    Command_Left: EZPTZCommandType.LEFT,
    Command_Right: EZPTZCommandType.RIGHT,
    Command_Up: EZPTZCommandType.UP,
    Command_Down: EZPTZCommandType.DOWN,
    Command_ZoomIn: EZPTZCommandType.ZOOM_IN,
    Command_ZoomOut: EZPTZCommandType.ZOOM_OUT,
]

/// 数据返回
struct EzvizPlayerEventResult : Codable {
    let eventType: String
    let msg: String
    let data: String?
    
    init(eventType: String, msg: String, data: String?) {
        self.eventType = eventType
        self.msg = msg
        self.data = data
    }
}

/// 播放状态
struct EzvizPlayerResult: Codable {
    let status: UInt
    let message: String?
    
    init(status: UInt,message: String?) throws {
        self.status = status
        self.message = message
    }
}
