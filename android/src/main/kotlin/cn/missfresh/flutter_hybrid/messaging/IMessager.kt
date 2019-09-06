package cn.missfresh.flutter_hybrid.messaging

import io.flutter.plugin.common.MethodChannel

/**
 * Created by sjl
 * on 2019-09-03
 */
interface IMessager {

    fun name(): String

    // flutter to Native
    fun setMethodChannel(channel: MethodChannel)

    // Native to flutter
    fun handleMethodCall(method: String, arguments: Any?, result: MethodChannel.Result)

}