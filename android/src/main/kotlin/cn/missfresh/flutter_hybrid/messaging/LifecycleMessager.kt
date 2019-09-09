package cn.missfresh.flutter_hybrid.messaging

import io.flutter.plugin.common.MethodChannel

/**
 * Created by sjl
 * on 2019-09-03
 * 生命周期相关通信
 */
class LifecycleMessager : Messager() {

    override fun name(): String {
        return "NativePageLifecycle"
    }

    override fun handleMethodCall(method: String, arguments: Any?, result: MethodChannel.Result) {
    }
}