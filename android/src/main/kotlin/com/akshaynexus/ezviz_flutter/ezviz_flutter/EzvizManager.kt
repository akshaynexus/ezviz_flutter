package com.akshaynexus.ezviz_flutter.ezviz_flutter

import com.videogo.exception.BaseException
import com.videogo.openapi.EZConstants
import com.videogo.openapi.EZHCNetDeviceSDK
import com.videogo.openapi.EZGlobalSDK
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

object EzvizManager {

    private val ptzKeys = mapOf(
        Action_START to EZConstants.EZPTZAction.EZPTZActionSTART.name,
        Action_STOP to EZConstants.EZPTZAction.EZPTZActionSTOP.name,
        Command_Left to EZConstants.EZPTZCommand.EZPTZCommandLeft.name,
        Command_Right to EZConstants.EZPTZCommand.EZPTZCommandRight.name,
        Command_Up to EZConstants.EZPTZCommand.EZPTZCommandUp.name,
        Command_Down to EZConstants.EZPTZCommand.EZPTZCommandDown.name,
        Command_ZoomIn to EZConstants.EZPTZCommand.EZPTZCommandZoomIn.name,
        Command_ZoomOut to EZConstants.EZPTZCommand.EZPTZCommandZoomOut.name
    )

    fun sdkVersion(result: Result) {
        result.success(EZGlobalSDK.getVersion())
    }

    fun initSDK(arguments: Any?, result: Result) {
        val map = arguments as? Map<*, *>
        map?.let {
            val appKey = it["appKey"] as? String ?: ""
            val accessToken = it["accessToken"] as? String ?: ""
            val enableLog = it["enableLog"] as? Boolean ?: false
            val enableP2P = it["enableP2P"] as? Boolean ?: false
            val application = ApplicationUtils.application
            application?.let { app ->
                val ret = EZGlobalSDK.initLib(app, appKey)
                EZGlobalSDK.enableP2P(enableP2P)
                EZGlobalSDK.showSDKLog(enableLog)
                EZGlobalSDK.getInstance().setAccessToken(accessToken)
                EZHCNetDeviceSDK.getInstance()
                result.success(ret)
            }
        }
    }

    fun enableLog(arguments: Any?) {
        val map = arguments as? Map<*, *>
        map?.let {
            val debug = it["enableLog"] as? Boolean ?: false
            EZGlobalSDK.showSDKLog(debug)
        }
    }

    fun enableP2P(arguments: Any?) {
        val map = arguments as? Map<*, *>
        map?.let {
            val debug = it["enableP2P"] as? Boolean ?: false
            EZGlobalSDK.enableP2P(debug)
        }
    }

    fun setAccessToken(arguments: Any?) {
        val map = arguments as? Map<*, *>
        map?.let {
            val accessToken = it["accessToken"] as? String ?: ""
            EZGlobalSDK.getInstance().setAccessToken(accessToken)
        }
    }

    fun getDeviceInfo(arguments: Any?, result: Result) {
        CoroutineScope(Dispatchers.IO).launch {
            val map = arguments as? Map<*, *>
            map?.let {
                try {
                    val deviceSerial = it["deviceSerial"] as? String ?: ""
                    val deviceInfo = EZGlobalSDK.getInstance().getDeviceInfo(deviceSerial)
                    withContext(Dispatchers.Main) {
                        if (deviceInfo == null) {
                            result.success(null)
                        } else {
                            val device = mapOf(
                                "deviceSerial" to deviceInfo.deviceSerial,
                                "deviceName" to deviceInfo.deviceName,
                                "isSupportPTZ" to deviceInfo.isSupportPTZ,
                                "cameraNum" to deviceInfo.cameraNum
                            )
                            result.success(device)
                        }
                    }
                } catch (e: BaseException) {
                    withContext(Dispatchers.Main) {
                        result.error("获取设备异常", e.localizedMessage, null)
                    }
                }
            }
        }
    }

    fun getDeviceList(result: Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val deviceInfoList = EZGlobalSDK.getInstance().getDeviceList(0, 100)
                withContext(Dispatchers.Main) {
                    if (deviceInfoList.isNullOrEmpty()) {
                        result.success(null)
                    } else {
                        val array = deviceInfoList.map { deviceInfo ->
                            mapOf(
                                "deviceSerial" to deviceInfo.deviceSerial,
                                "deviceName" to deviceInfo.deviceName,
                                "isSupportPTZ" to deviceInfo.isSupportPTZ,
                                "cameraNum" to deviceInfo.cameraNum
                            )
                        }
                        result.success(array)
                    }
                }
            } catch (e: BaseException) {
                withContext(Dispatchers.Main) {
                    result.error("获取设备异常", e.localizedMessage, null)
                }
            }
        }
    }

    fun setVideoLevel(arguments: Any?, result: Result) {
        val map = arguments as? Map<*, *>
        map?.let {
            val deviceSerial = it["deviceSerial"] as? String ?: ""
            val cameraId = it["cameraId"] as? Int ?: 0
            val videoLevel = it["videoLevel"] as? Int ?: 0

            CoroutineScope(Dispatchers.IO).launch {
                val ret = EZGlobalSDK.getInstance().setVideoLevel(deviceSerial, cameraId, videoLevel)
                withContext(Dispatchers.Main) {
                    result.success(ret)
                }
            }
        }
    }

    fun controlPTZ(arguments: Any?, result: Result) {
        val map = arguments as? Map<*, *>
        map?.let {
            try {
                val deviceSerial = it["deviceSerial"] as? String ?: ""
                val cameraId = it["cameraId"] as? Int ?: 0
                val command = it["command"] as? String ?: ""
                val action = it["action"] as? String ?: ""
                val speed = it["speed"] as? Int ?: 0

                CoroutineScope(Dispatchers.IO).launch {
                    try {
                        val ret = EZGlobalSDK.getInstance().controlPTZ(
                            deviceSerial,
                            cameraId,
                            EZConstants.EZPTZCommand.valueOf(ptzKeys[command] ?: ""),
                            EZConstants.EZPTZAction.valueOf(ptzKeys[action] ?: ""),
                            speed
                        )
                        withContext(Dispatchers.Main) {
                            result.success(ret)
                        }
                    } catch (e: BaseException) {
                        withContext(Dispatchers.Main) {
                            result.error("云台控制异常", e.localizedMessage, null)
                        }
                    }
                }
            } catch (e: BaseException) {
                result.error("云台控制异常", e.localizedMessage, null)
            }
        }
    }

    fun loginNetDevice(arguments: Any?, result: Result) {
        val map = arguments as? Map<*, *>
        map?.let {
            val userId = it["userId"] as? String ?: ""
            val pwd = it["pwd"] as? String ?: ""
            val ipAddr = it["ipAddr"] as? String ?: ""
            val port = it["port"] as? Int ?: 0

            CoroutineScope(Dispatchers.IO).launch {
                try {
                    val netDevice = EZHCNetDeviceSDK.getInstance().loginDeviceWithUerName(userId, pwd, ipAddr, port)
                    withContext(Dispatchers.Main) {
                        result.success(
                            netDevice?.let {
                                mapOf(
                                    "userId" to netDevice.loginId,
                                    "channelCount" to netDevice.byChanNum,
                                    "startChannelNo" to netDevice.byStartChan,
                                    "dStartChannelNo" to netDevice.byStartDChan,
                                    "dChannelCount" to netDevice.byIPChanNum,
                                    "byDVRType" to netDevice.byDVRType
                                )
                            }
                        )
                    }
                } catch (e: BaseException) {
                    withContext(Dispatchers.Main) {
                        result.error("登录网络设备异常", e.localizedMessage, null)
                    }
                }
            }
        }
    }

    fun logoutNetDevice(arguments: Any?, result: Result) {
        val map = arguments as? Map<*, *>
        map?.let {
            val userId = it["userId"] as? Int ?: 0

            CoroutineScope(Dispatchers.IO).launch {
                val ret = EZHCNetDeviceSDK.getInstance().logoutDeviceWithUserId(userId)
                withContext(Dispatchers.Main) {
                    result.success(ret)
                }
            }
        }
    }

    fun netControlPTZ(arguments: Any?, result: Result) {
        result.error("Android不支持此方法", null, null)
    }
}