package cn.missfresh.flutter_hybrid.view

import android.content.Context
import android.graphics.Bitmap
import android.graphics.PixelFormat
import android.support.v4.view.ViewCompat
import android.util.AttributeSet
import cn.missfresh.flutter_hybrid.Logger
import io.flutter.view.FlutterNativeView
import io.flutter.view.FlutterView

/**
 * Created by sjl
 * on 2019-09-01
 */
class FHFlutterView : FlutterView {

    private var isResumed = false

    constructor(context: Context, attrs: AttributeSet?, nativeView: FlutterNativeView) : super(context, attrs, nativeView) {
        // solve the first time loading a black screen
        setZOrderOnTop(true)
        holder.setFormat(PixelFormat.TRANSLUCENT)
    }

    override fun onPostResume() {
        super.onPostResume()
        requestFocus()
    }

    fun resumeFlutterView() {
        if (!isResumed) {
            isResumed = true
            super.onPostResume()
        }
        Logger.d("resume flutter view")
    }

    fun stopFlutterView() {
        if (isResumed) {
            isResumed = false
            super.onStop()
        }
        Logger.d("stop flutter view")
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

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        ViewCompat.requestApplyInsets(this)
    }
}