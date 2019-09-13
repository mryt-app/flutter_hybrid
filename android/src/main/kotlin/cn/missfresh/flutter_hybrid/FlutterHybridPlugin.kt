package cn.missfresh.flutter_hybrid

import android.app.Activity
import cn.missfresh.flutter_hybrid.interfaces.IAppInfo
import cn.missfresh.flutter_hybrid.interfaces.IContainerManager
import cn.missfresh.flutter_hybrid.interfaces.IFlutterHybridViewProvider
import cn.missfresh.flutter_hybrid.lifecycle.AppActivityLifecycle
import cn.missfresh.flutter_hybrid.messaging.DataMessager
import cn.missfresh.flutter_hybrid.messaging.Messager
import cn.missfresh.flutter_hybrid.messaging.Messager.Companion.NATIVE_NAVIGATION
import cn.missfresh.flutter_hybrid.messaging.Messager.Companion.NATIVE_PAGE_LIFECYCLE
import cn.missfresh.flutter_hybrid.messaging.MessagerProxy
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.lang.ref.WeakReference

class FlutterHybridPlugin : MethodCallHandler {

    companion object {
        val instance = FlutterHybridPluginHolder.holder

        const val FLUTTER_HYBRID = "flutter_hybrid"
    }

    private object FlutterHybridPluginHolder {
        val holder = FlutterHybridPlugin()
    }

    private lateinit var mViewProvider: IFlutterHybridViewProvider
    private lateinit var mManager: IContainerManager
    private lateinit var mAppInfo: IAppInfo

    // Messager
    private lateinit var mLifecycleMessager: Messager
    private lateinit var mDataMessager: DataMessager

    var currentActivityWeek: WeakReference<Activity>? = null

    // Whether to use the DataMessager FLUTTER_CAN_POP_CHANGED protocol
    var isUseCanPop = false

    /**
     * Initialize application information
     */
    fun init(appInfo: IAppInfo) {
        mManager = FlutterViewContainerManager()
        mViewProvider = FlutterHybridViewProvider()
        appInfo?.let {
            mAppInfo = it
            appInfo.getApplication().registerActivityLifecycleCallbacks(AppActivityLifecycle())
        }
    }

    fun registerWith(registrar: Registrar) {
        val channel = MethodChannel(registrar.view(), FLUTTER_HYBRID)
        channel.setMethodCallHandler(instance)

        val mMessagerProxy = MessagerProxy(channel)

        mDataMessager = DataMessager(NATIVE_NAVIGATION)
        mMessagerProxy.addMessager(mDataMessager)

        mLifecycleMessager = Messager(NATIVE_PAGE_LIFECYCLE)
        mMessagerProxy.addMessager(mLifecycleMessager)
    }

    /**
     * Return a messager to synchronize the Android lifecycle to Flutter
     */
    fun getLifecycleMessager(): Messager {
        return mLifecycleMessager
    }

    /**
     * Return a DataMessager for Flutter to notify Android related communication protocol by MethodChannel
     */
    fun getDataMessage(): DataMessager {
        return mDataMessager
    }

    /**
     * Returns the IFlutterHybridViewProvider
     */
    fun getViewProvider(): IFlutterHybridViewProvider {
        return mViewProvider
    }

    /**
     * Returns the IContainerManager
     */
    fun getContainerManager(): IContainerManager {
        return mManager
    }

    /**
     * Returns the IAppInfo
     */
    fun getAppInfo(): IAppInfo {
        return mAppInfo
    }

    /**
     * Return current Activity , but Activity might be null
     */
    fun getCurrentActivity(): Activity? {
        return currentActivityWeek?.get()
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else {
            result.notImplemented()
        }
    }
}