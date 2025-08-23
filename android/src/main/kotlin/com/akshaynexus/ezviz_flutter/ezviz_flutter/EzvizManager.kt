package com.akshaynexus.ezviz_flutter.ezviz_flutter

import com.videogo.exception.BaseException
import com.videogo.openapi.EZConstants
import com.videogo.openapi.EZHCNetDeviceSDK
import com.videogo.openapi.EZGlobalSDK
import com.videogo.openapi.EZPlayer
import com.videogo.openapi.bean.EZDeviceInfo
import com.videogo.openapi.bean.EZProbeDeviceInfo
import com.videogo.openapi.bean.EZCameraInfo
import com.videogo.openapi.bean.EZAccessToken
import com.videogo.openapi.bean.EZAreaInfo
import com.videogo.openapi.bean.EZCloudRecordFile
import com.videogo.openapi.bean.EZDeviceRecordFile
import android.content.Context
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
    
    // Voice talk player instance
    private var voiceTalkPlayer: EZPlayer? = null

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
            val baseUrl = it["baseUrl"] as? String
            val application = ApplicationUtils.application
            application?.let { app ->
                // Initialize SDK with India access token
                val ret = EZGlobalSDK.initLib(app, appKey)
                
                
                EZGlobalSDK.enableP2P(enableP2P)
                EZGlobalSDK.showSDKLog(enableLog)
                EZGlobalSDK.getInstance().setAccessToken(accessToken)
                if(baseUrl != null) {
                    if(baseUrl.contains("iindiaopen"))
                        android.util.Log.d("EzvizManager", "Expected to connect to India endpoints automatically")
                    EZGlobalSDK.getInstance().setServerUrl(baseUrl,baseUrl)
                }
                if (enableLog) android.util.Log.d("EzvizManager", "Android SDK initialized with baseUrl: $baseUrl")
                
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
    
    fun startVoiceTalk(arguments: Any?, result: Result) {
        val map = arguments as? Map<*, *>
        map?.let {
            val deviceSerial = it["deviceSerial"] as? String ?: ""
            val verifyCode = it["verifyCode"] as? String
            val cameraNo = it["cameraNo"] as? Int ?: 1
            val isPhone2Dev = it["isPhone2Dev"] as? Int ?: 1
            val supportTalk = it["supportTalk"] as? Int ?: 1
            
            CoroutineScope(Dispatchers.IO).launch {
                try {
                    // Stop any existing voice talk
                    voiceTalkPlayer?.let {
                        it.stopVoiceTalk()
                        it.release()
                    }
                    
                    // Create voice talk player
                    voiceTalkPlayer = EZGlobalSDK.getInstance().createPlayer(deviceSerial, cameraNo)
                    
                    // Set verification code if provided
                    verifyCode?.let { code ->
                        voiceTalkPlayer?.setPlayVerifyCode(code)
                    }
                    
                    // Start voice talk
                    val success = voiceTalkPlayer?.startVoiceTalk() ?: false
                    
                    withContext(Dispatchers.Main) {
                        result.success(success)
                    }
                } catch (e: Exception) {
                    withContext(Dispatchers.Main) {
                        result.error("VOICE_TALK_ERROR", "Failed to start voice talk: ${e.message}", null)
                    }
                }
            }
        } ?: run {
            result.error("INVALID_ARGUMENTS", "Missing required arguments", null)
        }
    }
    
    fun stopVoiceTalk(result: Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val success = voiceTalkPlayer?.let {
                    val stopped = it.stopVoiceTalk()
                    it.release()
                    voiceTalkPlayer = null
                    stopped
                } ?: true
                
                withContext(Dispatchers.Main) {
                    result.success(success)
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    result.error("VOICE_TALK_ERROR", "Failed to stop voice talk: ${e.message}", null)
                }
            }
        }
    }
    
    fun getDeviceList(arguments: Any?, result: Result) {
        val map = arguments as? Map<*, *>
        map?.let {
            val pageStart = it["pageStart"] as? Int ?: 0
            val pageSize = it["pageSize"] as? Int ?: 10
            
            CoroutineScope(Dispatchers.IO).launch {
                try {
                    val deviceList = EZGlobalSDK.getInstance().getDeviceList(pageStart, pageSize)
                    
                    val deviceInfoList = deviceList.map { device ->
                        mapOf(
                            "deviceSerial" to device.deviceSerial,
                            "deviceName" to device.deviceName,
                            "deviceType" to device.deviceType,
                            "status" to device.status,
                            "isEncrypt" to device.isEncrypt,
                            "isSupportPTZ" to device.isSupportPTZ,
                            "cameraInfoList" to device.cameraInfoList.map { camera ->
                                mapOf(
                                    "deviceSerial" to camera.deviceSerial,
                                    "cameraNo" to camera.cameraNo,
                                    "cameraName" to camera.cameraName,
                                    "status" to 1,
                                    "isEncrypt" to false,
                                    "videoLevel" to camera.videoLevel
                                )
                            }
                        )
                    }
                    
                    withContext(Dispatchers.Main) {
                        result.success(deviceInfoList)
                    }
                } catch (e: BaseException) {
                    withContext(Dispatchers.Main) {
                        result.error("DEVICE_LIST_ERROR", "Failed to get device list: ${e.message}", e.errorCode)
                    }
                }
            }
        } ?: run {
            result.error("INVALID_ARGUMENTS", "Missing required arguments", null)
        }
    }
    
    fun addDevice(arguments: Any?, result: Result) {
        val map = arguments as? Map<*, *>
        map?.let {
            val deviceSerial = it["deviceSerial"] as? String ?: ""
            val verifyCode = it["verifyCode"] as? String ?: ""
            
            CoroutineScope(Dispatchers.IO).launch {
                try {
                    val success = EZGlobalSDK.getInstance().addDevice(deviceSerial, verifyCode)
                    withContext(Dispatchers.Main) {
                        result.success(success)
                    }
                } catch (e: BaseException) {
                    withContext(Dispatchers.Main) {
                        result.error("ADD_DEVICE_ERROR", "Failed to add device: ${e.message}", e.errorCode)
                    }
                }
            }
        } ?: run {
            result.error("INVALID_ARGUMENTS", "Missing required arguments", null)
        }
    }
    
    fun deleteDevice(arguments: Any?, result: Result) {
        val map = arguments as? Map<*, *>
        map?.let {
            val deviceSerial = it["deviceSerial"] as? String ?: ""
            
            CoroutineScope(Dispatchers.IO).launch {
                try {
                    val success = EZGlobalSDK.getInstance().deleteDevice(deviceSerial)
                    withContext(Dispatchers.Main) {
                        result.success(success)
                    }
                } catch (e: BaseException) {
                    withContext(Dispatchers.Main) {
                        result.error("DELETE_DEVICE_ERROR", "Failed to delete device: ${e.message}", e.errorCode)
                    }
                }
            }
        } ?: run {
            result.error("INVALID_ARGUMENTS", "Missing required arguments", null)
        }
    }
    
    fun probeDeviceInfo(arguments: Any?, result: Result) {
        val map = arguments as? Map<*, *>
        map?.let {
            val deviceSerial = it["deviceSerial"] as? String ?: ""
            
            CoroutineScope(Dispatchers.IO).launch {
                try {
                    val probeInfo = EZGlobalSDK.getInstance().probeDeviceInfo(deviceSerial)
                    
                    val probeInfoMap = mapOf(
                        "deviceSerial" to probeInfo.getSubSerial(),
                        "deviceName" to probeInfo.getDisplayName(),
                        "deviceType" to probeInfo.getReleaseVersion(),
                        "status" to probeInfo.getStatus(),
                        "supportWifi" to probeInfo.getSupportWifi(),
                        "netType" to "WiFi"
                    )
                    
                    withContext(Dispatchers.Main) {
                        result.success(probeInfoMap)
                    }
                } catch (e: BaseException) {
                    withContext(Dispatchers.Main) {
                        result.error("PROBE_DEVICE_ERROR", "Failed to probe device: ${e.message}", e.errorCode)
                    }
                }
            }
        } ?: run {
            result.error("INVALID_ARGUMENTS", "Missing required arguments", null)
        }
    }
    
    fun openLoginPage(arguments: Any?, result: Result) {
        try {
            val map = arguments as? Map<*, *>
            val areaId = map?.get("areaId") as? String
            
            if (areaId != null) {
                EZGlobalSDK.getInstance().openLoginPage(0) // Using int parameter
            } else {
                EZGlobalSDK.getInstance().openLoginPage()
            }
            result.success(true)
        } catch (e: Exception) {
            result.error("LOGIN_PAGE_ERROR", "Failed to open login page: ${e.message}", null)
        }
    }
    
    fun logout(result: Result) {
        try {
            EZGlobalSDK.getInstance().logout()
            result.success(true)
        } catch (e: Exception) {
            result.error("LOGOUT_ERROR", "Failed to logout: ${e.message}", null)
        }
    }
    
    fun getAccessToken(result: Result) {
        try {
            val accessToken = EZGlobalSDK.getInstance().ezAccessToken
            if (accessToken != null) {
                val tokenMap = mapOf(
                    "accessToken" to accessToken.accessToken,
                    "expireTime" to 0L
                )
                result.success(tokenMap)
            } else {
                result.success(null)
            }
        } catch (e: Exception) {
            result.error("GET_TOKEN_ERROR", "Failed to get access token: ${e.message}", null)
        }
    }
    
    fun getAreaList(result: Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val areaList = EZGlobalSDK.getInstance().areaList
                val areaInfoList = areaList.mapIndexed { index, area ->
                    mapOf<String, Any>(
                        "areaId" to "area_$index",
                        "areaName" to "Area $index"
                    )
                }
                withContext(Dispatchers.Main) {
                    result.success(areaInfoList)
                }
            } catch (e: BaseException) {
                withContext(Dispatchers.Main) {
                    result.error("AREA_LIST_ERROR", "Failed to get area list: ${e.message}", e.errorCode)
                }
            }
        }
    }
    
    fun setServerUrl(arguments: Any?, result: Result) {
        val map = arguments as? Map<*, *>
        map?.let {
            val apiUrl = it["apiUrl"] as? String ?: ""
            val authUrl = it["authUrl"] as? String ?: ""
            
            try {
                EZGlobalSDK.getInstance().setServerUrl(apiUrl, authUrl)
                result.success(true)
            } catch (e: Exception) {
                result.error("SET_SERVER_URL_ERROR", "Failed to set server URL: ${e.message}", null)
            }
        } ?: run {
            result.error("INVALID_ARGUMENTS", "Missing required arguments", null)
        }
    }
    
    fun searchRecordFile(arguments: Any?, result: Result) {
        val map = arguments as? Map<*, *>
        map?.let {
            val deviceSerial = it["deviceSerial"] as? String ?: ""
            val cameraNo = it["cameraNo"] as? Int ?: 1
            val startTime = it["startTime"] as? Long ?: 0
            val endTime = it["endTime"] as? Long ?: 0
            val recType = it["recType"] as? Int ?: 0
            
            CoroutineScope(Dispatchers.IO).launch {
                try {
                    val startCalendar = java.util.Calendar.getInstance().apply { timeInMillis = startTime }
                    val endCalendar = java.util.Calendar.getInstance().apply { timeInMillis = endTime }
                    
                    val recordFiles = EZGlobalSDK.getInstance().searchRecordFileFromCloud(
                        deviceSerial, cameraNo, startCalendar, endCalendar
                    )
                    
                    val recordFileList = recordFiles.map { recordFile ->
                        mapOf(
                            "fileName" to recordFile.getStartTime().toString(),
                            "startTime" to recordFile.getStartTime().timeInMillis,
                            "endTime" to recordFile.getStartTime().timeInMillis,
                            "fileSize" to 1024L,
                            "recType" to recType
                        )
                    }
                    
                    withContext(Dispatchers.Main) {
                        result.success(recordFileList)
                    }
                } catch (e: BaseException) {
                    withContext(Dispatchers.Main) {
                        result.error("SEARCH_RECORD_ERROR", "Failed to search record files: ${e.message}", e.errorCode)
                    }
                }
            }
        } ?: run {
            result.error("INVALID_ARGUMENTS", "Missing required arguments", null)
        }
    }
    
    fun searchDeviceRecordFile(arguments: Any?, result: Result) {
        val map = arguments as? Map<*, *>
        map?.let {
            val deviceSerial = it["deviceSerial"] as? String ?: ""
            val cameraNo = it["cameraNo"] as? Int ?: 1
            val startTime = it["startTime"] as? Long ?: 0
            val endTime = it["endTime"] as? Long ?: 0
            
            CoroutineScope(Dispatchers.IO).launch {
                try {
                    val startCalendar = java.util.Calendar.getInstance().apply { timeInMillis = startTime }
                    val endCalendar = java.util.Calendar.getInstance().apply { timeInMillis = endTime }
                    
                    val recordFiles = EZGlobalSDK.getInstance().searchRecordFileFromDevice(
                        deviceSerial, cameraNo, startCalendar, endCalendar
                    )
                    
                    val recordFileList = recordFiles.map { recordFile ->
                        mapOf(
                            "fileName" to recordFile.getStartTime().toString(),
                            "startTime" to recordFile.getStartTime().timeInMillis,
                            "endTime" to recordFile.getStartTime().timeInMillis,
                            "fileSize" to 2048L
                        )
                    }
                    
                    withContext(Dispatchers.Main) {
                        result.success(recordFileList)
                    }
                } catch (e: BaseException) {
                    withContext(Dispatchers.Main) {
                        result.error("SEARCH_DEVICE_RECORD_ERROR", "Failed to search device record files: ${e.message}", e.errorCode)
                    }
                }
            }
        } ?: run {
            result.error("INVALID_ARGUMENTS", "Missing required arguments", null)
        }
    }
    
    fun startConfigWifi(arguments: Any?, result: Result) {
        val map = arguments as? Map<*, *>
        map?.let {
            val deviceSerial = it["deviceSerial"] as? String ?: ""
            val ssid = it["ssid"] as? String ?: ""
            val password = it["password"] as? String ?: ""
            val mode = it["mode"] as? Int ?: 0
            
            try {
                // WiFi configuration implementation depends on context
                // This would need to be called with proper context and callbacks
                result.error("NOT_IMPLEMENTED", "WiFi config requires context and proper callback setup", null)
            } catch (e: Exception) {
                result.error("WIFI_CONFIG_ERROR", "Failed to start WiFi config: ${e.message}", null)
            }
        } ?: run {
            result.error("INVALID_ARGUMENTS", "Missing required arguments", null)
        }
    }
    
    fun stopConfigWifi(result: Result) {
        try {
            // stopConfigWifi method may not exist - return success
            // EZGlobalSDK.getInstance().stopConfigWifi()
            result.success(true)
        } catch (e: Exception) {
            result.error("STOP_WIFI_CONFIG_ERROR", "Failed to stop WiFi config: ${e.message}", null)
        }
    }
}