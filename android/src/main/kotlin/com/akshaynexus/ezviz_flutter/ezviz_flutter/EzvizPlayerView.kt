package com.akshaynexus.ezviz_flutter.ezviz_flutter

import android.content.Context
import android.util.Log
import android.view.SurfaceHolder
import android.widget.FrameLayout
import com.videogo.openapi.EZGlobalSDK
import com.videogo.openapi.EZPlayer
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.util.*
import java.util.concurrent.atomic.AtomicBoolean
import android.os.Handler
import android.os.Looper
import android.os.Message
import com.videogo.openapi.EZConstants
import com.videogo.errorlayer.ErrorInfo
import kotlinx.serialization.json.Json
import kotlinx.serialization.encodeToString

enum class EzvizPlayerStatus(val value: Int) {
    Idle(0), Init(1), Start(2), Pause(3), Stop(4), Error(5)
}

interface EzvizPlayerEventHandler {
    fun onDispatchStatus(event: EzvizEventResult)
}

class EzvizPlayerView(context: Context) : FrameLayout(context), SurfaceHolder.Callback {
    private val TAG = "EZvizPlayerView"
    private var player: EZPlayer? = null
    private var url: String? = null
    private var deviceSerial: String? = null
    private var cameraNo: Int = 0
    private lateinit var surfaceLayout: EzvizPlayerLayout
    private val isInitSurface = AtomicBoolean(false)
    private val isResumePlay = AtomicBoolean(true)
    private var playStatus: EzvizPlayerStatus
    
    companion object {
        private val json = Json { 
            ignoreUnknownKeys = true
            encodeDefaults = true
        }
    }

    var eventHandler: EzvizPlayerEventHandler? = null

    private val mHandler: Handler = object : Handler(Looper.getMainLooper()) {
        override fun handleMessage(msg: Message) {
            Log.e(TAG, "ID: ${msg.what}")
            when (msg.what) {
                EZConstants.EZRealPlayConstants.MSG_REALPLAY_PLAY_START -> {
                    dispatchStatus(EzvizPlayerStatus.Start, null)
                }
                EZConstants.EZRealPlayConstants.MSG_REALPLAY_STOP_SUCCESS -> {
                    dispatchStatus(EzvizPlayerStatus.Stop, null)
                }
                EZConstants.EZPlaybackConstants.MSG_REMOTEPLAYBACK_PLAY_START -> {
                    dispatchStatus(EzvizPlayerStatus.Start, null)
                }
                EZConstants.EZPlaybackConstants.MSG_REMOTEPLAYBACK_STOP_SUCCESS -> {
                    dispatchStatus(EzvizPlayerStatus.Stop, null)
                }
                else -> handleErrorMessage(msg)
            }
        }
    }

    init {
        initSurfaceLayout()
        playStatus = EzvizPlayerStatus.Idle
    }

    private fun initSurfaceLayout() {
        surfaceLayout = EzvizPlayerLayout(context)
        val layoutParams = LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT)
        surfaceLayout.setSurfaceHolderCallback(this)
        addView(surfaceLayout, 0, layoutParams)
    }

    private fun handleErrorMessage(msg: Message) {
        when (msg.what) {
            EZConstants.EZPlaybackConstants.MSG_REMOTEPLAYBACK_ENCRYPT_PASSWORD_ERROR,
            EZConstants.EZRealPlayConstants.MSG_REALPLAY_PASSWORD_ERROR -> {
                val errorInfo = msg.obj as? ErrorInfo
                val errorMessage = "Verification code error: ${errorInfo?.description ?: "Invalid password"}"
                Log.e(TAG, "Encryption password error: $errorMessage")
                dispatchStatus(EzvizPlayerStatus.Error, errorMessage)
            }
            EZConstants.EZPlaybackConstants.MSG_REMOTEPLAYBACK_CONNECTION_EXCEPTION,
            EZConstants.EZRealPlayConstants.MSG_REALPLAY_PLAY_FAIL -> {
                val errorInfo = msg.obj as? ErrorInfo
                val errorMessage = errorInfo?.description ?: "Playback failed"
                Log.e(TAG, "Playback error: $errorMessage")
                dispatchStatus(EzvizPlayerStatus.Error, errorMessage)
            }
            else -> {
                // Handle other potential error messages
                if (msg.what < 0) { // Negative values typically indicate errors
                    val errorInfo = msg.obj as? ErrorInfo
                    val errorMessage = errorInfo?.description ?: "Unknown error: ${msg.what}"
                    Log.e(TAG, "Player error: $errorMessage")
                    dispatchStatus(EzvizPlayerStatus.Error, errorMessage)
                }
            }
        }
    }

    fun initPlayer(deviceSerial: String, cameraNo: Int) {
        player?.release()
        this.url = null
        Log.d(TAG, "deviceSerial: $deviceSerial, cameraNo: $cameraNo, instance = ${EZGlobalSDK.getInstance()}")
        player = EZGlobalSDK.getInstance().createPlayer(deviceSerial, cameraNo).apply {
            setSurfaceHold(surfaceLayout.getSurfaceView()?.holder)
            setHandler(mHandler)
        }
        this.deviceSerial = deviceSerial
        this.cameraNo = cameraNo
        dispatchStatus(EzvizPlayerStatus.Init, null)
    }

    fun initPlayer(url: String) {
        player?.release()
        this.deviceSerial = null
        this.cameraNo = 0
        player = EZGlobalSDK.getInstance().createPlayerWithUrl(url).apply {
            setSurfaceHold(surfaceLayout.getSurfaceView()?.holder)
            setHandler(mHandler)
        }
        this.url = url
        dispatchStatus(EzvizPlayerStatus.Init, null)
    }

    fun startRealPlay(): Boolean {
        return player?.startRealPlay()?.also {
            dispatchStatus(EzvizPlayerStatus.Start, null)
        } ?: false
    }

    fun stopRealPlay(): Boolean {
        return player?.stopRealPlay() ?: false
    }

    fun startPlayback(startDate: Calendar, endDate: Calendar) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val list = EZGlobalSDK.getInstance().searchRecordFileFromDevice(deviceSerial, cameraNo, startDate, endDate)
                val playbackResult = list.firstOrNull()?.let { file ->
                    player?.startPlayback(file) ?: false
                } ?: false

                withContext(Dispatchers.Main) {
                    if (!playbackResult) {
                        dispatchStatus(EzvizPlayerStatus.Error, "No recordings found in the specified time range")
                    }
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    Log.e(TAG, "Error searching for recordings: ${e.message}")
                    dispatchStatus(EzvizPlayerStatus.Error, "Failed to get recordings: ${e.message}")
                }
            }
        }
    }

    fun stopPlayBack(): Boolean {
        return player?.stopPlayback() ?: false
    }

    fun playRelease() {
        player?.run {
            stopPlayback()
            stopRealPlay()
            release()
        }
        player = null
        dispatchStatus(EzvizPlayerStatus.Idle, null)
    }

    fun setPlayVerifyCode(verifyCode: String) {
        try {
            Log.d(TAG, "Setting play verify code for encrypted camera")
            player?.setPlayVerifyCode(verifyCode)
        } catch (e: Exception) {
            Log.e(TAG, "Error setting verify code: ${e.message}")
            dispatchStatus(EzvizPlayerStatus.Error, "Failed to set verification code: ${e.message}")
        }
    }

    fun openSound(): Boolean {
        return player?.openSound() ?: false
    }

    fun closeSound(): Boolean {
        return player?.closeSound() ?: false
    }

    fun capturePicture(): String? {
        return try {
            // Capture picture functionality - implementation depends on SDK version
            // For now, return null indicating not implemented
            Log.w(TAG, "Capture picture not implemented in current SDK version")
            null
        } catch (e: Exception) {
            Log.e(TAG, "Error capturing picture: ${e.message}")
            null
        }
    }

    fun startRecording(): Boolean {
        return try {
            // Recording functionality - implementation depends on SDK version
            Log.w(TAG, "Start recording not implemented in current SDK version")
            false
        } catch (e: Exception) {
            Log.e(TAG, "Error starting recording: ${e.message}")
            false
        }
    }

    fun stopRecording(): Boolean {
        return try {
            // Stop recording functionality - implementation depends on SDK version
            Log.w(TAG, "Stop recording not implemented in current SDK version")
            false
        } catch (e: Exception) {
            Log.e(TAG, "Error stopping recording: ${e.message}")
            false
        }
    }

    fun isRecording(): Boolean {
        return try {
            // Recording status check - implementation depends on SDK version
            false
        } catch (e: Exception) {
            Log.e(TAG, "Error checking recording status: ${e.message}")
            false
        }
    }

    fun setVideoSizeChange(width: Int, height: Int) {
        surfaceLayout.setSurfaceSize(width, height)
    }

    private fun dispatchStatus(status: EzvizPlayerStatus, message: String?) {
        // Always use manual JSON creation to avoid serialization issues
        val jsonString = buildString {
            append("{")
            append("\"status\":${status.value}")
            append(",\"message\":")
            if (message != null) {
                append("\"${message.replace("\"", "\\\"")}\"")
            } else {
                append("null")
            }
            append("}")
        }
        
        val eventResult = EzvizEventResult(
            EzvizPlayerChannelEvents.playerStatusChange,
            "Player Status Changed",
            jsonString
        )
        eventHandler?.onDispatchStatus(eventResult)
    }

    override fun surfaceChanged(holder: SurfaceHolder, format: Int, width: Int, height: Int) {}

    override fun surfaceCreated(holder: SurfaceHolder) {
        Log.i(TAG, "surfaceCreated")
        player?.setSurfaceHold(holder)
        if (isInitSurface.compareAndSet(false, true) && isResumePlay.get()) {
            isResumePlay.set(false)
        }
    }

    override fun surfaceDestroyed(holder: SurfaceHolder) {
        Log.i(TAG, "surfaceDestroyed")
        isInitSurface.set(false)
    }
}