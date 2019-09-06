package cn.missfresh.flutter_hybrid.messaging

import cn.missfresh.flutter_hybrid.Logger
import io.flutter.plugin.common.MethodChannel

/**
 * Created by sjl
 * on 2019-09-03
 * 生命周期相关通信
 */
class LifecycleMessager : IMessager {

    private var mMethodChannel: MethodChannel? = null

    override fun name(): String {
        return "NativePageLifecycle"
    }

    override fun setMethodChannel(channel: MethodChannel) {
        mMethodChannel = channel
    }

    override fun handleMethodCall(method: String, arguments: Any?, result: MethodChannel.Result) {

    }

    fun invokeMethod(methodName: String, routeName: String, params: Map<*, *>, uniqueId: String) {
        val args = hashMapOf<String, Any>()
        args["routeName"] = routeName
        args["params"] = params
        args["uniqueID"] = uniqueId
        invokeMethod(methodName, args)
    }

    private fun invokeMethod(method: String, params: Map<*, *>) {
        var channelMethod = name() + "." + method
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
}