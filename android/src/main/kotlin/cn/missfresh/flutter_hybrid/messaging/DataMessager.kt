package cn.missfresh.flutter_hybrid.messaging

import cn.missfresh.flutter_hybrid.FlutterHybridPlugin
import cn.missfresh.flutter_hybrid.Logger
import io.flutter.plugin.common.MethodChannel

/**
 * Created by sjl
 * on 2019-09-03
 * 数据通信
 */
class DataMessager : IMessager {

    companion object {
        const val OPEN_PAGE = "openPage"
        const val CLOSE_PAGE = "closePage"
        const val FETCH_START_PAGE_INFO = "fetchStartPageInfo"
        const val SHOWN_PAGE_CHANGED = "flutterShownPageChanged"
        const val FLUTTER_CAN_POP_CHANGED = "flutterCanPopChanged"
    }

    override fun name(): String {
        return "NativeNavigation"
    }

    private var mMethodChannel: MethodChannel? = null

    override fun setMethodChannel(channel: MethodChannel) {
        mMethodChannel = channel
    }

    override fun handleMethodCall(method: String, arguments: Any?, result: MethodChannel.Result) {
        Logger.e("handleMethodCall=$method")

        when (method) {
            OPEN_PAGE -> {
                arguments as Map<*, *>
                openPage(arguments)
                return
            }
            CLOSE_PAGE -> {
                arguments as Map<*, *>
                closePage(arguments)
                return
            }
            FETCH_START_PAGE_INFO -> {
                fetchStartPageInfo(result)
                return
            }
            SHOWN_PAGE_CHANGED -> {
                arguments as Map<*, *>
                showPageChanged(arguments)
                return
            }
            FLUTTER_CAN_POP_CHANGED -> {
                arguments as Map<*, *>
                flutterCanPop(result, arguments)
                return
            }
        }
    }

    private fun flutterCanPop(result: MethodChannel.Result, arguments: Map<*, *>) {
        result.success(arguments["canPop"] as Boolean)
    }

    private fun showPageChanged(arguments: Map<*, *>) {
        Logger.e("oldPage=" + arguments["oldPage"])
        Logger.e("newPage=" + arguments["newPage"])
        FlutterHybridPlugin.instance.containerManager()
                .onShownContainerChanged(arguments["oldPage"]
                        .toString(), arguments["newPage"].toString())
    }

    private fun fetchStartPageInfo(result: MethodChannel.Result) {
        val pageInfo = HashMap<String, Any>()
        try {
            var containerStatus = FlutterHybridPlugin
                    .instance.containerManager().getCurrentTopStatus()

            if (containerStatus == null) {
                containerStatus = FlutterHybridPlugin.instance
                        .containerManager().getLastContainerStatus()
            }

            containerStatus?.apply {

                pageInfo["routeName"] = getContainer().getContainerName()
                pageInfo["params"] = getContainer().getContainerParams()
                pageInfo["uniqueId"] = uniqueId()

                Logger.d("routeName=" + pageInfo["routeName"])
                Logger.d("params=" + pageInfo["params"])
                Logger.d("uniqueId=" + pageInfo["uniqueId"])
            }

            result.success(pageInfo)

        } catch (t: Throwable) {
            result.success(pageInfo)
        }
    }

    private fun closePage(arguments: Map<*, *>) {
        FlutterHybridPlugin.instance.containerManager()
                .destroyContainerRecord("", arguments["pageId"].toString())
    }

    private fun openPage(arguments: Map<*, *>) {
        FlutterHybridPlugin.instance.openPage(null,
                arguments["routeName"].toString(), arguments["params"] as Map<*, *>)
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
        Logger.e("$channelMethod")
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