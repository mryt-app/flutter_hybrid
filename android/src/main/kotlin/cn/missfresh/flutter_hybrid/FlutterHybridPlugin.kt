package cn.missfresh.flutter_hybrid

import android.app.Activity
import android.app.Application
import android.os.Bundle
import cn.missfresh.flutter_hybrid.interfaces.IAppInfo
import cn.missfresh.flutter_hybrid.interfaces.IContainerManager
import cn.missfresh.flutter_hybrid.interfaces.IFlutterHybridViewProvider
import cn.missfresh.flutter_hybrid.messaging.DataMessager
import cn.missfresh.flutter_hybrid.messaging.LifecycleMessager
import cn.missfresh.flutter_hybrid.messaging.MessagerProxy
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class FlutterHybridPlugin : MethodCallHandler, Application.ActivityLifecycleCallbacks {

    companion object {
        val instance = FlutterHybridPluginHolder.holder
    }

    private object FlutterHybridPluginHolder {
        val holder = FlutterHybridPlugin()
    }

    private lateinit var mViewProvider: IFlutterHybridViewProvider
    private lateinit var mManager: IContainerManager
    private lateinit var mAppInfo: IAppInfo

    private lateinit var mMessagerProxy: MessagerProxy
    private lateinit var mLifecycleMessager: LifecycleMessager
    private lateinit var mDataMessager: DataMessager

    private var mCurrentActiveActivity: Activity? = null

    fun init(appInfo: IAppInfo) {
        mManager = FlutterViewContainerManager()
        mViewProvider = FlutterHybridViewProvider()
        appInfo?.let {
            mAppInfo = it
            appInfo.getApplication().registerActivityLifecycleCallbacks(instance)
        }
    }

    fun registerWith(registrar: Registrar) {
        val channel = MethodChannel(registrar.view(), "flutter_hybrid")
        channel.setMethodCallHandler(instance)

        mMessagerProxy = MessagerProxy(channel)

        mDataMessager = DataMessager()
        mMessagerProxy.addMessager(mDataMessager)

        mLifecycleMessager = LifecycleMessager()
        mMessagerProxy.addMessager(mLifecycleMessager)
    }

    fun lifecycleMessager(): LifecycleMessager {
        return mLifecycleMessager
    }

    fun dataMessage(): DataMessager {
        return mDataMessager
    }

    fun viewProvider(): IFlutterHybridViewProvider {
        return mViewProvider
    }

    fun containerManager(): IContainerManager {
        return mManager
    }

    fun appInfo(): IAppInfo {
        return mAppInfo
    }

    fun currentActivity(): Activity? {
        return mCurrentActiveActivity
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else {
            result.notImplemented()
        }
    }

    override fun onActivityCreated(activity: Activity?, bundle: Bundle?) {

    }

    override fun onActivityStarted(activity: Activity?) {
        mCurrentActiveActivity = activity
    }

    override fun onActivityResumed(activity: Activity?) {
        mCurrentActiveActivity = activity
    }

    override fun onActivityPaused(activity: Activity?) {

    }

    override fun onActivityStopped(activity: Activity?) {
        if (mCurrentActiveActivity == activity) {
            mCurrentActiveActivity = null
        }
    }

    override fun onActivityDestroyed(activity: Activity?) {
        if (mCurrentActiveActivity == activity) {
            mCurrentActiveActivity = null
        }
    }

    override fun onActivitySaveInstanceState(activity: Activity?, bundle: Bundle?) {

    }
}
