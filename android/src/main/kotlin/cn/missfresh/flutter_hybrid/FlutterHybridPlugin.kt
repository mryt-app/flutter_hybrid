package cn.missfresh.flutter_hybrid

import android.app.Activity
import android.app.Application
import android.content.Context
import android.net.Uri
import android.os.Bundle
import cn.missfresh.flutter_hybrid.interfaces.IAppInfo
import cn.missfresh.flutter_hybrid.interfaces.IContainerManager
import cn.missfresh.flutter_hybrid.interfaces.IFlutterHybridViewProvider
import cn.missfresh.flutter_hybrid.messaging.FlutterLifecycleMessager
import cn.missfresh.flutter_hybrid.messaging.LifecycleMessager
import cn.missfresh.flutter_hybrid.messaging.MessagerProxy
import com.alibaba.fastjson.JSON
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.io.UnsupportedEncodingException
import java.net.URLEncoder

class FlutterHybridPlugin : MethodCallHandler, Application.ActivityLifecycleCallbacks {

    companion object {
        val instance = FlutterHybridPluginHolder.holder
    }

    private object FlutterHybridPluginHolder {
        val holder = FlutterHybridPlugin()
    }

    private var kRid = 0
    private lateinit var mViewProvider: IFlutterHybridViewProvider
    private lateinit var mManager: IContainerManager
    private lateinit var mAppInfo: IAppInfo
    private lateinit var mMessagerProxy: MessagerProxy
    private lateinit var mLifecycleMessager: FlutterLifecycleMessager
    var isFirstLoad = true

    private var mCurrentActiveActivity: Activity? = null


    fun init(appInfo: IAppInfo) {
        mManager = FlutterViewContainerManager()
        appInfo?.let {
            mAppInfo = it
            mViewProvider = FlutterHybridViewProvider(it)
            appInfo.getApplication().registerActivityLifecycleCallbacks(instance)
        }
    }

    fun registerWith(registrar: Registrar) {
        val channel = MethodChannel(registrar.view(), "flutter_hybrid")
        channel.setMethodCallHandler(instance)

        mMessagerProxy = MessagerProxy(channel)
        mMessagerProxy.addMessager(LifecycleMessager())

        mLifecycleMessager = FlutterLifecycleMessager()
        mMessagerProxy.addMessager(mLifecycleMessager)
    }

    fun lifecycleMessager(): FlutterLifecycleMessager {
        return mLifecycleMessager
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

    fun openPage(context: Context?, url: String, params: Map<*, *>?, requestCode: Int = 0) {

        var ctx: Context? = context
        if (ctx == null) {
            ctx = currentActivity()
        }

        if (ctx == null) {
            ctx = instance.mAppInfo?.getMainActivity()
        }

        if (ctx == null) {
            ctx = instance.mAppInfo?.getApplication()
        }

        ctx?.let {
            instance.mAppInfo?.startActivity(it, concatUrl(url, params), requestCode)
        }
    }

    private fun concatUrl(url: String, params: Map<*, *>?): String {
        if (params == null || params!!.isEmpty())
            return url

        val uri = Uri.parse(url)
        val builder = uri.buildUpon()
        for ((key, value) in params) {
            value?.let {
                var str: String
                str = if (it is Map<*, *> || it is List<*>) {
                    try {
                        URLEncoder.encode(JSON.toJSONString(value), "utf-8")
                    } catch (e: UnsupportedEncodingException) {
                        it.toString()
                    }
                } else {
                    it.toString()
                }
                builder.appendQueryParameter(key.toString(), str)
            }
        }
        return builder.build().toString()
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
        if (mCurrentActiveActivity === activity) {
            mCurrentActiveActivity = null
        }
    }

    override fun onActivityDestroyed(activity: Activity?) {
        if (mCurrentActiveActivity === activity) {
            mCurrentActiveActivity = null
        }
    }

    override fun onActivitySaveInstanceState(activity: Activity?, bundle: Bundle?) {

    }

    fun destroy() {
        mViewProvider.destroy()
    }
}