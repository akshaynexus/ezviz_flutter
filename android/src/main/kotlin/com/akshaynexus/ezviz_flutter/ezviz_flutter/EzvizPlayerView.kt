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
        if (msg.what in listOf(
                EZConstants.EZPlaybackConstants.MSG_REMOTEPLAYBACK_CONNECTION_EXCEPTION,
                EZConstants.EZPlaybackConstants.MSG_REMOTEPLAYBACK_ENCRYPT_PASSWORD_ERROR,
                EZConstants.EZRealPlayConstants.MSG_REALPLAY_PASSWORD_ERROR,
                EZConstants.EZRealPlayConstants.MSG_REALPLAY_PLAY_FAIL
            )
        ) {
            val errorInfo = msg.obj as? ErrorInfo
            dispatchStatus(EzvizPlayerStatus.Error, errorInfo?.description)
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
            val list = EZGlobalSDK.getInstance().searchRecordFileFromDevice(deviceSerial, cameraNo, startDate, endDate)
            val playbackResult = list.firstOrNull()?.let { file ->
                player?.startPlayback(file) ?: false
            } ?: false

            withContext(Dispatchers.Main) {
                if (!playbackResult) {
                    dispatchStatus(EzvizPlayerStatus.Error, "Playback list is empty")
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
        player?.setPlayVerifyCode(verifyCode)
    }

    fun setVideoSizeChange(width: Int, height: Int) {
        surfaceLayout.setSurfaceSize(width, height)
    }

    private fun dispatchStatus(status: EzvizPlayerStatus, message: String?) {
        val playerResult = EzvizPlayerResult(status.ordinal, message)
        val eventResult = EzvizEventResult(
            EzvizPlayerChannelEvents.playerStatusChange,
            "Player Status Changed",
            Json.encodeToString(playerResult)
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