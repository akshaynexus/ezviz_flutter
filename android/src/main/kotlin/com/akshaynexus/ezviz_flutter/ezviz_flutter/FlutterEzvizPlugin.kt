package com.akshaynexus.ezviz_flutter.ezviz_flutter

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class FlutterEzvizPlugin : FlutterPlugin, MethodCallHandler {
  private lateinit var channel: MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "ezviz_flutter")
    channel.setMethodCallHandler(this)
    flutterPluginBinding.platformViewRegistry.registerViewFactory(
      EzvizPlayerChannelMethods.methodChannelName,
      EzvizPlayerFactory(flutterPluginBinding.binaryMessenger, flutterPluginBinding.applicationContext)
    )
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      EzvizChannelMethods.platformVersion -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      EzvizChannelMethods.sdkVersion -> {
        EzvizManager.sdkVersion(result)
      }
      EzvizChannelMethods.initSDK -> {
        EzvizManager.initSDK(call.arguments, result)
      }
      EzvizChannelMethods.enableLog -> {
        EzvizManager.enableLog(call.arguments)
      }
      EzvizChannelMethods.enableP2P -> {
        EzvizManager.enableP2P(call.arguments)
      }
      EzvizChannelMethods.setAccessToken -> {
        EzvizManager.setAccessToken(call.arguments)
      }
      EzvizChannelMethods.setVideoLevel -> {
        EzvizManager.setVideoLevel(call.arguments, result)
      }
      EzvizChannelMethods.deviceInfo -> {
        EzvizManager.getDeviceInfo(call.arguments, result)
      }
      EzvizChannelMethods.deviceInfoList -> {
        EzvizManager.getDeviceList(result)
      }
      EzvizChannelMethods.controlPTZ -> {
        EzvizManager.controlPTZ(call.arguments, result)
      }
      EzvizChannelMethods.loginNetDevice -> {
        EzvizManager.loginNetDevice(call.arguments, result)
      }
      EzvizChannelMethods.logoutNetDevice -> {
        EzvizManager.logoutNetDevice(call.arguments, result)
      }
      EzvizChannelMethods.netControlPTZ -> {
        EzvizManager.netControlPTZ(call.arguments, result)
      }
      "startVoiceTalk" -> {
        EzvizManager.startVoiceTalk(call.arguments, result)
      }
      "stopVoiceTalk" -> {
        EzvizManager.stopVoiceTalk(result)
      }
      EzvizChannelMethods.getDeviceList -> {
        EzvizManager.getDeviceList(call.arguments, result)
      }
      EzvizChannelMethods.addDevice -> {
        EzvizManager.addDevice(call.arguments, result)
      }
      EzvizChannelMethods.deleteDevice -> {
        EzvizManager.deleteDevice(call.arguments, result)
      }
      EzvizChannelMethods.probeDeviceInfo -> {
        EzvizManager.probeDeviceInfo(call.arguments, result)
      }
      EzvizChannelMethods.openLoginPage -> {
        EzvizManager.openLoginPage(call.arguments, result)
      }
      EzvizChannelMethods.logout -> {
        EzvizManager.logout(result)
      }
      EzvizChannelMethods.getAccessToken -> {
        EzvizManager.getAccessToken(result)
      }
      EzvizChannelMethods.getAreaList -> {
        EzvizManager.getAreaList(result)
      }
      EzvizChannelMethods.setServerUrl -> {
        EzvizManager.setServerUrl(call.arguments, result)
      }
      EzvizChannelMethods.searchRecordFile -> {
        EzvizManager.searchRecordFile(call.arguments, result)
      }
      EzvizChannelMethods.searchDeviceRecordFile -> {
        EzvizManager.searchDeviceRecordFile(call.arguments, result)
      }
      "startConfigWifi" -> {
        EzvizManager.startConfigWifi(call.arguments, result)
      }
      "stopConfigWifi" -> {
        EzvizManager.stopConfigWifi(result)
      }
      else -> {
        result.notImplemented()
      }
    }
  }
}