package com.akshaynexus.ezviz_flutter.ezviz_flutter

import android.content.Context
import android.view.SurfaceView
import android.view.SurfaceHolder
import android.view.ViewGroup
import android.graphics.Point
import android.widget.FrameLayout
import kotlin.math.ceil

class EzvizPlayerLayout(context: Context) : FrameLayout(context) {
    private var mSurfaceView: SurfaceView? = null
    private var mHeight = 0
    private var mWidth = 0
    private var mVideoWidth = 0
    private var mVideoHeight = 0
    private var mCallback: SurfaceHolder.Callback? = null
    init {
        initSurfaceView()
    }

    private fun initSurfaceView() {
        if (mSurfaceView == null) {
            mSurfaceView = SurfaceView(context)
            //解決黑屏
            mSurfaceView?.setZOrderOnTop(true)
            //mSurfaceView?.holder?.setFormat(PixelFormat.TRANSLUCENT)
            //解决覆盖绘制内容的问题
            mSurfaceView?.setZOrderMediaOverlay(true)

            val lp = LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT)
            addView(mSurfaceView,0,lp)
        }
    }

    fun getSurfaceView(): SurfaceView? {
        return mSurfaceView
    }

    fun setSurfaceHolderCallback(callback: SurfaceHolder.Callback?) {
        if (callback != null) {
            this.mCallback = callback
            if (mSurfaceView != null) {
                mSurfaceView?.holder?.addCallback(callback)
            }
        }
    }
//
//    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
//        var widthMeasureSpec = widthMeasureSpec
//        var heightMeasureSpec = heightMeasureSpec
//        mWidth = MeasureSpec.getSize(widthMeasureSpec)
//        mHeight = MeasureSpec.getSize(heightMeasureSpec)
////        val layoutParams = layoutParams
////        if (layoutParams.height == ViewGroup.LayoutParams.WRAP_CONTENT) {
////            mHeight = (mWidth * 0.562).toInt()
////        }
//        changeSurfaceSize(mSurfaceView, 0, 0)
//        widthMeasureSpec = MeasureSpec.makeMeasureSpec(mWidth, MeasureSpec.getMode(widthMeasureSpec))
//        heightMeasureSpec = MeasureSpec.makeMeasureSpec(mHeight, MeasureSpec.getMode(heightMeasureSpec))
//        super.onMeasure(widthMeasureSpec, heightMeasureSpec)
//    }

    fun setVideoSizeChange(videoWidth: Int, videoHeight: Int) {
        mVideoWidth = videoWidth
        mVideoHeight = videoHeight
        changeSurfaceSize(mSurfaceView, mVideoWidth, mVideoHeight)
    }

    /**
     * 动态设置播放区域大小
     * 当width等于0（height等于0）时，播放区域以height（width）为标准，宽高按视频分辨率比例播放
     *
     * @param width  播放区域宽
     * @param height 播放区域高
     */
    fun setSurfaceSize(width: Int, height: Int) {
        var lp: ViewGroup.LayoutParams? = layoutParams
        if (lp == null) {
            lp = ViewGroup.LayoutParams(width, height)
        } else {
            lp.width = width
            lp.height = height
        }
        if (width == 0) {
            lp.width = (height * 1.1778).toInt()
        }
        if (height == 0) {
            lp.height = (width * 0.562).toInt()
        }
        layoutParams = lp
        changeSurfaceSize(mSurfaceView, mVideoWidth, mVideoHeight)
    }

    private fun getSurfaceSize(surface: SurfaceView?, width: Int, height: Int): Point? {
        var videoWidth = width
        var videoHeight = height
        var pt: Point? = null
        if (surface == null)
            return pt
        if (videoWidth == 0 || videoHeight == 0) {
            // return;
            videoWidth = 16
            videoHeight = 9
        }
        // get screen size
        //        sw = activity.getWindow().getDecorView().getWidth();
        //        sh = activity.getWindow().getDecorView().getHeight();
        val sw = mWidth
        val sh = mHeight

        var dw = sw.toDouble()
        var dh = sh.toDouble()
        //        boolean isPortrait = activity.getResources().getConfiguration().orientation == Configuration.ORIENTATION_PORTRAIT;
        val isPortrait = false
        if (sw > sh && isPortrait || sw < sh && !isPortrait) {
            dw = sh.toDouble()
            dh = sw.toDouble()
        }
        // sanity check
        if (dw * dh == 0.0 || videoWidth * videoHeight == 0) {
            return pt
        }
        // compute the aspect ratio
        val ar: Double
        val vw: Double
        vw = videoWidth.toDouble()
        ar = videoWidth.toDouble() / videoHeight.toDouble()
        // compute the display aspect ratio
        val dar = dw / dh
        if (dar < ar)
            dh = dw / ar
        else
            dw = dh * ar
        val w = ceil(dw * videoWidth / videoWidth).toInt()
        val h = ceil(dh * videoHeight / videoHeight).toInt()
        pt = Point(w, h)
        return pt
    }

    private fun changeSurfaceSize(surface: SurfaceView?, videoWidth: Int, videoHeight: Int) {
        if (surface == null)
            return
        val holder = surface.holder

        // force surface buffer size
        val size = getSurfaceSize(surface, videoWidth, videoHeight) ?: return
        holder.setFixedSize(videoWidth, videoHeight)
        // set display size
        val lp = surface.layoutParams as ViewGroup.LayoutParams
        val oldH = lp.height
        lp.width = size.x
        lp.height = size.y
        surface.layoutParams = lp
    }
}