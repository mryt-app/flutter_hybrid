package cn.missfresh.flutter_hybrid.messaging

import cn.missfresh.flutter_hybrid.FlutterHybridPlugin
import cn.missfresh.flutter_hybrid.Logger
import cn.missfresh.flutter_hybrid.router.Router
import io.flutter.plugin.common.MethodChannel

/**
 * Created by sjl
 * on 2019-09-03
 */
class DataMessager(name: String) : Messager(name) {

    companion object {
        //protocol name
        const val OPEN_PAGE = "openPage"
        const val CLOSE_PAGE = "closePage"
        const val FETCH_START_PAGE_INFO = "fetchStartPageInfo"
        const val SHOWN_PAGE_CHANGED = "flutterShownPageChanged"
        const val FLUTTER_CAN_POP_CHANGED = "flutterCanPopChanged"
        const val BACK_BUTTON_PRESSED = "backButtonPressed"

        // flutterShownPageChanged protocol parameter
        const val OLD_PAGE = "oldPage"
        const val NEW_PAGE = "newPage"

        // closePage protocol parameter
        const val PAGE_ID = "pageId"
    }

    override fun handleMethodCall(method: String, arguments: Any?, result: MethodChannel.Result) {
        Logger.d("handleMethodCall:$method")

        when (method) {
            OPEN_PAGE -> {
                arguments as Map<*, *>
                val routeName = arguments[ROUTE_NAME].toString()
                val params = arguments[PARAMS] as Map<*, *>
                Router().openPage(FlutterHybridPlugin.instance.getCurrentActivity(), routeName, params)
                return
            }
            CLOSE_PAGE -> {
                arguments as Map<*, *>
                val pagId = arguments[PAGE_ID].toString()
                Router().closePage(pagId)
                return
            }
            FETCH_START_PAGE_INFO -> {
                fetchStartPageInfo(result)
                return
            }
            SHOWN_PAGE_CHANGED -> {
                arguments as Map<*, *>
                showPageChanged(arguments[OLD_PAGE].toString(),
                        arguments[NEW_PAGE].toString())
                return
            }
            FLUTTER_CAN_POP_CHANGED -> {
                return
            }
        }
    }

    /**
     * Accepted the Flutter flutterShownPageChanged protocol.
     * Called when the page display status changes.
     */
    private fun showPageChanged(oldPage: String, newPage: String) {
        Logger.e("$OLD_PAGE=$oldPage")
        Logger.e("$NEW_PAGE=$newPage")
        FlutterHybridPlugin.instance.getContainerManager()
                .onShownContainerChanged(oldPage, newPage)
    }

    /**
     * Accepted the Flutter fetchStartPageInfo protocol.
     */
    private fun fetchStartPageInfo(result: MethodChannel.Result) {
        val pageInfo = HashMap<String, Any>()
        try {
            var containerStatus = FlutterHybridPlugin
                    .instance.getContainerManager().getCurrentLifecycleState()

            if (containerStatus == null) {
                containerStatus = FlutterHybridPlugin.instance
                        .getContainerManager().getLastContainerLifecycle()
            }

            containerStatus?.apply {
                pageInfo[ROUTE_NAME] = getContainer().getContainerName()
                if (getContainer().getContainerParams().isNullOrEmpty()) {
                    pageInfo[PARAMS] = getContainer().getContainerParams().toString()
                }
                pageInfo[UNIQUE_ID] = containerId()
            }

            result.success(pageInfo)

        } catch (t: Throwable) {
            result.success(pageInfo)
        }
    }
}