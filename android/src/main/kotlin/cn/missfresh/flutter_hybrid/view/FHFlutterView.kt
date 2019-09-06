package cn.missfresh.flutter_hybrid.view

import android.content.Context
import android.graphics.Bitmap
import android.support.v4.view.ViewCompat
import android.util.AttributeSet
import android.view.SurfaceHolder
import cn.missfresh.flutter_hybrid.Logger
import io.flutter.view.FlutterNativeView
import io.flutter.view.FlutterView
import java.util.HashMap

/**
 * Created by sjl
 * on 2019-09-01
 */
class FHFlutterView : FlutterView {

    private var mFirstFrame = false
    var isResumed = false
    private lateinit var mFlutterHybridCallback: FlutterHybridCallback


    constructor(context: Context, attrs: AttributeSet?, nativeView: FlutterNativeView) : super(context, attrs, nativeView) {
        addFirstFrameListener { mFirstFrame = true }

        try {
            val field = FlutterView::class.java.getDeclaredField("mSurfaceCallback")
            field.isAccessible = true
            val cb = field.get(this) as SurfaceHolder.Callback
            holder.removeCallback(cb)
            mFlutterHybridCallback = FlutterHybridCallback(cb)
            holder.addCallback(mFlutterHybridCallback)
        } catch (t: Throwable) {
            Logger.e(t.toString())
        }

    }

    fun firstFrameCalled(): Boolean {
        return mFirstFrame
    }

    override fun onPostResume() {
        super.onPostResume()
        requestFocus()
    }

    fun resumeFlutterView() {
        if (!isResumed) {
            isResumed = true
            super.onPostResume()
            Logger.d("resume flutter view")
        }
    }

    fun stopFlutterView() {
        if (isResumed) {
            isResumed = false
            super.onStop()
            Logger.d("stop flutter view")
        }
    }

    override fun detach(): FlutterNativeView {
        return flutterNativeView
    }

    override fun getBitmap(): Bitmap? {
        if (flutterNativeView == null || !flutterNativeView.isAttached) {
            Logger.e("FlutterView not attached!")
            return null
        }
        return super.getBitmap()
    }

    fun scheduleFrame() {
        if (isResumed) {
            val map = HashMap<String, String>()
            map["type"] = "scheduleFrame"
            // todo
            //NavigationService.getService().emitEvent(map)
        }
    }

    internal inner class FlutterHybridCallback(private val callback: SurfaceHolder.Callback) : SurfaceHolder.Callback {

        override fun surfaceCreated(holder: SurfaceHolder) {
            try {
                callback.surfaceCreated(holder)
            } catch (t: Throwable) {
                Logger.e(t.toString())
            }
        }

        override fun surfaceChanged(holder: SurfaceHolder, format: Int, width: Int, height: Int) {
            try {
                callback.surfaceChanged(holder, format, width, height)
                scheduleFrame()
            } catch (t: Throwable) {
                Logger.e(t.toString())
            }
        }

        override fun surfaceDestroyed(holder: SurfaceHolder) {
            try {
                callback.surfaceDestroyed(holder)
            } catch (t: Throwable) {
                Logger.e(t.toString())
            }
        }
    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        ViewCompat.requestApplyInsets(this)
    }

}