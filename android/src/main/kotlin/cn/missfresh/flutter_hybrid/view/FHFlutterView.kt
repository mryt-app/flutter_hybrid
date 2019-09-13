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

    /**
     * solve the first time loading a black screen
     */
    constructor(context: Context, attrs: AttributeSet?, nativeView: FlutterNativeView)
            : super(context, attrs, nativeView) {
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

    /**
     * The AppLifecycleState.paused state of the Flutter lifecycle is
     * prevented from being called when the two FlatterView pages are
     * switched, so that the newly opened Flutter lifecycle calls the
     * bug that the Flutter page cannot be refreshed after clicking the page.
     */
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

    /**
     * Call the parent class getBitmap method to return a bitmap
     */
    override fun getBitmap(): Bitmap? {
        // Safety check
        if (flutterNativeView == null || !flutterNativeView.isAttached) {
            Logger.e("FlutterView not attached!")
            return null
        }
        return super.getBitmap()
    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        /**
         * Ask that a new dispatch of {@link #onApplyWindowInsets(WindowInsets)} be performed.
         */
        ViewCompat.requestApplyInsets(this)
    }
}