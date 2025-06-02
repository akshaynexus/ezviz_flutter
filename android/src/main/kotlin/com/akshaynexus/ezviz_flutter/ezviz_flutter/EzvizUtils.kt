package com.akshaynexus.ezviz_flutter.ezviz_flutter


import android.app.Application
/**
 * 根据反射得到Application
 */
internal object ApplicationUtils {

    private var mApplication: Application? = null

    val application: Application?
        get() {
            if (mApplication == null) {
                mApplication = applicationInner
            }
            return mApplication
        }

    private val applicationInner: Application?
        get() {
            try {
                val activityThread = Class.forName("android.app.ActivityThread")

                val currentApplication = activityThread.getDeclaredMethod("currentApplication")
                val currentActivityThread = activityThread.getDeclaredMethod("currentActivityThread")

                val current = currentActivityThread.invoke(null as Any?)
                val app = currentApplication.invoke(current)

                return app as Application
            } catch (e: Exception) {
                e.printStackTrace()
                return null
            }

        }

    fun init(application: Application) {
        mApplication = application
    }
}