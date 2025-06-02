import Flutter
import UIKit
import EZOpenSDKFramework

func ezvizLog(msg: String) {
    print("EZviz Log: \(msg)")
}

public class SwiftFlutterEzvizPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    private var isInit = false
    private var eventChannel: FlutterEventChannel?
    private var eventSink: FlutterEventSink?

    deinit {
        if isInit {
            EZGlobalSDK.destoryLib()
        }
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: EzvizChannelMethods.methodChannelName, binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: EzvizChannelEvents.eventChannelName, binaryMessenger: registrar.messenger())

        let instance = SwiftFlutterEzvizPlugin()
        instance.eventChannel = eventChannel
        eventChannel.setStreamHandler(instance)

        registrar.addMethodCallDelegate(instance, channel: methodChannel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case EzvizChannelMethods.platformVersion:
            result("iOS " + UIDevice.current.systemVersion)
        case EzvizChannelMethods.sdkVersion:
            EzvizManager.sdkVersion(result: result)
        case EzvizChannelMethods.initSDK:
            isInit = true
            EzvizManager.initSDK(call.arguments, result: result)
        case EzvizChannelMethods.enableLog:
            EzvizManager.enableLog(call.arguments)
        case EzvizChannelMethods.enableP2P:
            EzvizManager.enableP2P(call.arguments)
        case EzvizChannelMethods.setAccessToken:
            EzvizManager.setAccessToken(call.arguments)
        case EzvizChannelMethods.deviceInfo:
            EzvizManager.getDeviceInfo(call.arguments, result: result)
        case EzvizChannelMethods.deviceInfoList:
            EzvizManager.getDeviceInfoList(result: result)
        case EzvizChannelMethods.setVideoLevel:
            EzvizManager.setVideoLevel(call.arguments, result: result)
        case EzvizChannelMethods.controlPTZ:
            EzvizManager.controlPTZ(call.arguments, result: result)
        case EzvizChannelMethods.loginNetDevice:
            EzvizManager.loginNetDevice(call.arguments, result: result)
        case EzvizChannelMethods.logoutNetDevice:
            EzvizManager.logoutNetDevice(call.arguments, result: result)
        case EzvizChannelMethods.netControlPTZ:
            EzvizManager.netControlPTZ(call.arguments, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        ezvizLog(msg: "onListen \(String(describing: eventSink))")
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        ezvizLog(msg: "onCancel \(String(describing: eventSink))")
        self.eventSink = nil
        return nil
    }
}