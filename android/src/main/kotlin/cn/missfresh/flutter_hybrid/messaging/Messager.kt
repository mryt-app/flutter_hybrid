package cn.missfresh.flutter_hybrid.messaging

import cn.missfresh.flutter_hybrid.Logger
import io.flutter.plugin.common.MethodChannel

/**
 * Created by sjl
 * on 2019-09-03
 */
open class Messager(var name: String) {

    companion object {
        // protocol parameter
        const val ROUTE_NAME = "routeName"
        const val PARAMS = "params"
        const val UNIQUE_ID = "uniqueID"

        const val NATIVE_PAGE_LIFECYCLE = "NativePageLifecycle"
        const val NATIVE_NAVIGATION = "NativeNavigation"
    }

    private var mMethodChannel: MethodChannel? = null

    // flutter to Native
    fun setMethodChannel(channel: MethodChannel) {
        mMethodChannel = channel
    }

    fun invokeMethod(methodName: String, routeName: String, params: Map<*, *>, uniqueId: String) {
        val args = hashMapOf<String, Any>()
        args[ROUTE_NAME] = routeName
        args[PARAMS] = params
        args[UNIQUE_ID] = uniqueId
        invokeMethod(methodName, args)
    }

    private fun invokeMethod(method: String, params: Map<*, *>) {
        var channelMethod = "$name.$method"
        Logger.d("$channelMethod")
        mMethodChannel?.invokeMethod(channelMethod, params, object : MethodChannel.Result {
            override fun notImplemented() {
                Logger.e("invokeMethod $method  notImplemented")
            }

            override fun error(p0: String?, msg: String?, p2: Any?) {
                Logger.e("invokeMethod $method error : $msg")
            }

            override fun success(p0: Any?) {
                Logger.e("invokeMethod $method success")
            }
        })
    }

    // Native to flutter
    open fun handleMethodCall(method: String, arguments: Any?, result: MethodChannel.Result) {}

}