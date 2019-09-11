package cn.missfresh.flutter_hybrid.messaging

import cn.missfresh.flutter_hybrid.FlutterHybridPlugin
import cn.missfresh.flutter_hybrid.Logger
import cn.missfresh.flutter_hybrid.router.Router
import io.flutter.plugin.common.MethodChannel

/**
 * Created by sjl
 * on 2019-09-03
 * 数据通信
 */
class DataMessager : Messager() {

    companion object {
        const val NAME_MESSAGER = "NativeNavigation"

        //protocol name
        const val OPEN_PAGE = "openPage"
        const val CLOSE_PAGE = "closePage"
        const val FETCH_START_PAGE_INFO = "fetchStartPageInfo"
        const val SHOWN_PAGE_CHANGED = "flutterShownPageChanged"
        const val FLUTTER_CAN_POP_CHANGED = "flutterCanPopChanged"

        // flutterCanPopChanged protocol parameter
        const val CAN_POP = "canPop"
        // flutterShownPageChanged protocol parameter
        const val OLD_PAGE = "oldPage"
        const val NEW_PAGE = "newPage"

        // closePage protocol parameter
        const val PAGE_ID = "pageId"
    }

    /**
     * Messager name
     */
    override fun name(): String {
        return NAME_MESSAGER
    }

    override fun handleMethodCall(method: String, arguments: Any?, result: MethodChannel.Result) {
        Logger.d("handleMethodCall:$method")

        when (method) {
            OPEN_PAGE -> {
                arguments as Map<*, *>
                openPage(arguments[ROUTE_NAME].toString(), arguments[PARAMS] as Map<*, *>)
                return
            }
            CLOSE_PAGE -> {
                arguments as Map<*, *>
                closePage(arguments[PAGE_ID].toString())
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
                arguments as Map<*, *>
                Logger.e("$FLUTTER_CAN_POP_CHANGED======$arguments")
                var canPop = false
                if (arguments.containsKey(CAN_POP)) {
                    canPop = arguments[CAN_POP] as Boolean
                }
                flutterCanPop(canPop)
                return
            }
        }
    }

    private fun flutterCanPop(canPop: Boolean) {
        var containerStatus = FlutterHybridPlugin
                .instance.containerManager().getCurrentStatus()

        if (containerStatus == null) {
            containerStatus = FlutterHybridPlugin.instance
                    .containerManager().getLastContainerStatus()
        }

        containerStatus?.getContainer()?.setContainerCanPop(canPop)
    }

    private fun showPageChanged(oldPage: String, newPage: String) {
        Logger.e("$OLD_PAGE=$oldPage")
        Logger.e("$NEW_PAGE=$newPage")
        FlutterHybridPlugin.instance.containerManager()
                .onShownContainerChanged(oldPage, newPage)
    }

    private fun fetchStartPageInfo(result: MethodChannel.Result) {
        val pageInfo = HashMap<String, Any>()
        try {
            var containerStatus = FlutterHybridPlugin
                    .instance.containerManager().getCurrentStatus()

            if (containerStatus == null) {
                containerStatus = FlutterHybridPlugin.instance
                        .containerManager().getLastContainerStatus()
            }

            containerStatus?.apply {

                pageInfo[ROUTE_NAME] = getContainer().getContainerName()
                if (getContainer().getContainerParams().isNullOrEmpty()) {
                    pageInfo[PARAMS] = getContainer().getContainerParams().toString()
                }
                pageInfo[UNIQUE_ID] = containerId()

                Logger.d(ROUTE_NAME + "=" + pageInfo[ROUTE_NAME])
                Logger.d(PARAMS + "=" + pageInfo[PARAMS])
                Logger.d(UNIQUE_ID + "=" + pageInfo[UNIQUE_ID])
            }

            result.success(pageInfo)

        } catch (t: Throwable) {
            result.success(pageInfo)
        }
    }

    /**
     * Close page with pageId
     * @param pageId
     */
    private fun closePage(pageId: String) {
        Router().closePage(pageId)
    }

    /**
     * open a new page
     * @param routeName
     * @param params
     */
    private fun openPage(routeName: String, params: Map<*, *>) {
        Router().openPage(null, routeName, params)
    }
}