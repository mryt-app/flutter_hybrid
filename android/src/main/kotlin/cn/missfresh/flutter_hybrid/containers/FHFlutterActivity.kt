package cn.missfresh.flutter_hybrid.containers

import android.app.Activity
import android.content.Context
import android.os.Bundle
import android.view.Window
import cn.missfresh.flutter_hybrid.FlutterHybridPlugin
import cn.missfresh.flutter_hybrid.Logger
import cn.missfresh.flutter_hybrid.interfaces.IFlutterViewContainer
import cn.missfresh.flutter_hybrid.messaging.Messager
import cn.missfresh.flutter_hybrid.view.FHFlutterView
import io.flutter.app.FlutterActivity
import io.flutter.view.FlutterNativeView
import io.flutter.view.FlutterView

/**
 * Created by sjl
 * on 2019-09-02
 */
abstract class FHFlutterActivity : FlutterActivity(), IFlutterViewContainer {

    private lateinit var mFlutterContent: FlutterViewStub

    private var canPopFlutterView: Boolean = false

    override fun onCreate(savedInstanceState: Bundle?) {
        window.requestFeature(Window.FEATURE_NO_TITLE)
        super.onCreate(savedInstanceState)

        mFlutterContent = FlutterViewStub(this, createFlutterView(this))
        setContentView(mFlutterContent)

        FlutterHybridPlugin.instance.containerManager().onContainerCreate(this)
        onRegisterPlugins(this)
    }

    override fun createFlutterView(context: Context?): FlutterView {
        return FlutterHybridPlugin.instance.viewProvider().createFlutterView(this)
    }

    override fun createFlutterNativeView(): FlutterNativeView {
        return FlutterHybridPlugin.instance.viewProvider().getFlutterNativeView(this)
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
        super.onDestroy()
        mFlutterContent.removeViews()
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

    override fun setContainerCanPop(canPop: Boolean) {
        canPopFlutterView = canPop
    }

    override fun getContainerCanPop(): Boolean {
        return canPopFlutterView
    }

    override fun getContainerName(): String {
        Logger.e("getContainerName is $intent?.extras?.getString(Messager.ROUTE_NAME)")
        return intent?.extras?.getString(Messager.ROUTE_NAME) ?: ""
    }

    override fun getContainerParams(): Map<String, Any> {
        var params = mapOf<String, Any>()
        intent?.extras?.getSerializable(Messager.PARAMS)?.let {
            params = it as Map<String, Any>
        }
        Logger.e("getContainerParams:$params")
        return params
    }
}