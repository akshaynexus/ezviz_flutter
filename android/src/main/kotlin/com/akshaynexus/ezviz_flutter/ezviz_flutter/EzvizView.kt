package com.akshaynexus.ezviz_flutter.ezviz_flutter

import android.content.Context
import android.view.View
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import java.text.SimpleDateFormat
import java.util.*
import android.util.Log

class EzvizFlutterPlayerView(
    context: Context,
    messenger: BinaryMessenger, // Используем BinaryMessenger вместо PluginRegistry.Registrar
    id: Int
) : PlatformView, MethodChannel.MethodCallHandler, EventChannel.StreamHandler, EzvizPlayerEventHandler {

    private val player: EzvizPlayerView = EzvizPlayerView(context)
    private val methodChannel: MethodChannel
    private val eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null
    
    companion object {
        private val json = Json { 
            ignoreUnknownKeys = true
            encodeDefaults = true
        }
    }

    init {
        player.eventHandler = this
        val methodChannelName = EzvizPlayerChannelMethods.methodChannelName + "_$id"
        val eventChannelName = EzvizPlayerChannelEvents.eventChannelName + "_$id"
        methodChannel = MethodChannel(messenger, methodChannelName)
        eventChannel = EventChannel(messenger, eventChannelName)
        eventChannel.setStreamHandler(this)
        methodChannel.setMethodCallHandler(this)
    }

    override fun getView(): View = player

    override fun dispose() {
        player.playRelease()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            EzvizPlayerChannelMethods.initPlayerByDevice -> {
                val map = call.arguments as? Map<*, *>
                val deviceSerial = map?.get("deviceSerial") as? String ?: ""
                val cameraNo = map?.get("cameraNo") as? Int ?: 0
                player.initPlayer(deviceSerial, cameraNo)
            }

            EzvizPlayerChannelMethods.initPlayerByUser -> {
                // TODO: обновите это для новой версии библиотеки
                // val map = call.arguments as? Map<*, *>
                // val userId = map?.get("userId") as? Int ?: 0
                // val cameraNo = map?.get("cameraNo") as? Int ?: 0
                // val streamType = map?.get("streamType") as? Int ?: 0
                // player.initPlayer(userId, cameraNo, streamType)
            }

            EzvizPlayerChannelMethods.initPlayerUrl -> {
                val map = call.arguments as? Map<*, *>
                val url = map?.get("url") as? String ?: ""
                player.initPlayer(url)
            }

            EzvizPlayerChannelMethods.playerRelease -> {
                player.playRelease()
            }

            EzvizPlayerChannelMethods.setPlayVerifyCode -> {
                val map = call.arguments as? Map<*, *>
                val verifyCode = map?.get("verifyCode") as? String ?: ""
                player.setPlayVerifyCode(verifyCode)
            }

            EzvizPlayerChannelMethods.startRealPlay -> {
                player.startRealPlay()
            }

            EzvizPlayerChannelMethods.stopRealPlay -> {
                player.stopRealPlay()
            }

            EzvizPlayerChannelMethods.startReplay -> {
                val map = call.arguments as? Map<*, *>
                val startTime = map?.get("startTime") as? String ?: ""
                val endTime = map?.get("endTime") as? String ?: ""
                val localDateFormat = SimpleDateFormat("yyyyMMddHHmmss", Locale.getDefault())
                val startDate = localDateFormat.parse(startTime) ?: Date()
                val endDate = localDateFormat.parse(endTime) ?: Date()
                val startCalendar = Calendar.getInstance().apply { time = startDate }
                val endCalendar = Calendar.getInstance().apply { time = endDate }
                player.startPlayback(startCalendar, endCalendar)
            }

            EzvizPlayerChannelMethods.stopReplay -> {
                player.stopPlayBack()
            }

            "openSound" -> {
                result.success(player.openSound())
            }

            "closeSound" -> {
                result.success(player.closeSound())
            }

            "capturePicture" -> {
                result.success(player.capturePicture())
            }

            "startRecording" -> {
                result.success(player.startRecording())
            }

            "stopRecording" -> {
                result.success(player.stopRecording())
            }

            "isRecording" -> {
                result.success(player.isRecording())
            }
            
            "pausePlayback" -> {
                result.success(player.pausePlayback())
            }
            
            "resumePlayback" -> {
                result.success(player.resumePlayback())
            }
            
            "seekPlayback" -> {
                val map = call.arguments as? Map<*, *>
                val timeMs = map?.get("timeMs") as? Long ?: 0
                result.success(player.seekPlayback(timeMs))
            }
            
            "getOSDTime" -> {
                result.success(player.getOSDTime())
            }
            
            "setPlaySpeed" -> {
                val map = call.arguments as? Map<*, *>
                val speed = map?.get("speed") as? Float ?: 1.0f
                result.success(player.setPlaySpeed(speed))
            }
            
            "startLocalRecord" -> {
                val map = call.arguments as? Map<*, *>
                val filePath = map?.get("filePath") as? String ?: ""
                result.success(player.startLocalRecord(filePath))
            }
            
            "stopLocalRecord" -> {
                result.success(player.stopLocalRecord())
            }
            
            "isLocalRecording" -> {
                result.success(player.isLocalRecording())
            }

            else -> result.notImplemented()
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        this.eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        this.eventSink = null
    }

    override fun onDispatchStatus(event: EzvizEventResult) {
        // Always use manual JSON creation to avoid serialization issues
        val jsonString = buildString {
            append("{")
            append("\"eventType\":\"${event.eventType.replace("\"", "\\\"")}\"")
            append(",\"msg\":\"${event.msg.replace("\"", "\\\"")}\"")
            append(",\"data\":")
            if (event.data != null) {
                append("\"${event.data.replace("\"", "\\\"")}\"")
            } else {
                append("null")
            }
            append("}")
        }
        this.eventSink?.success(jsonString)
    }
}