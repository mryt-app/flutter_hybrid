package cn.missfresh.flutter_hybrid.containers

import android.app.Activity
import android.content.Context
import android.graphics.Color
import android.os.Bundle
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.view.Window
import android.widget.FrameLayout
import android.widget.ProgressBar
import cn.missfresh.flutter_hybrid.FlutterHybridPlugin
import cn.missfresh.flutter_hybrid.Logger
import cn.missfresh.flutter_hybrid.interfaces.IFlutterViewContainer
import cn.missfresh.flutter_hybrid.view.FHFlutterView
import io.flutter.app.FlutterActivity
import io.flutter.view.FlutterNativeView
import io.flutter.view.FlutterView

/**
 * Created by sjl
 * on 2019-09-02
 */
abstract class FHFlutterActivity : FlutterActivity(), IFlutterViewContainer {

    private lateinit var mFlutterContent: FlutterContent

    override fun onCreate(savedInstanceState: Bundle?) {
        window.requestFeature(Window.FEATURE_NO_TITLE)
        super.onCreate(savedInstanceState)

        mFlutterContent = FlutterContent(this)
        setContentView(mFlutterContent)

        FlutterHybridPlugin.instance.containerManager().onContainerCreate(this)
        onRegisterPlugins(this)
    }

    override fun createFlutterView(context: Context?): FlutterView {
        return FlutterHybridPlugin.instance.viewProvider().createFlutterView(this)
    }

    override fun createFlutterNativeView(): FlutterNativeView {
        return FlutterHybridPlugin.instance.viewProvider().createFlutterNativeView(this)
    }

    override fun onPostResume() {
        super.onPostResume()
        FlutterHybridPlugin.instance.containerManager().onContainerAppear(this)
        mFlutterContent.attachFlutterView(getFHFlutterView())
    }

    override fun onPause() {
        mFlutterContent.detachFlutterView()
        FlutterHybridPlugin.instance.containerManager().onContainerDisappear(this)
        super.onPause()
    }

    override fun onDestroy() {
        FlutterHybridPlugin.instance.containerManager().onContainerDestroy(this)
        mFlutterContent.removeViews()
        super.onDestroy()
    }

    override fun onBackPressed() {
        FlutterHybridPlugin.instance.containerManager().onBackPressed(this)
    }

    override fun getFHFlutterView(): FHFlutterView {
        return flutterView as FHFlutterView
    }

    override fun getCurrActivity(): Activity {
        return this
    }

    override fun onContainerAppear() {
        mFlutterContent.onContainerAppear()
    }

    override fun onContainerDisappear() {
        mFlutterContent.onContainerDisappear()
    }

    override fun destroyContainerView() {
        finish()
    }

    override fun retainFlutterNativeView(): Boolean {
        return true
    }

    fun createFlutterInitCoverView(): View {
        val initCover = View(this)
        initCover.setBackgroundColor(Color.WHITE)
        return initCover
    }

    internal inner class FlutterContent(context: Context) : FlutterViewStub(context) {

        init {
            setBackgroundColor(Color.WHITE)
        }

        override val getFHFlutterView: FHFlutterView
            get() = this@FHFlutterActivity.getFHFlutterView()

        fun createFlutterInitCoverView(): View {
            return this@FHFlutterActivity.createFlutterInitCoverView()
        }
    }
}