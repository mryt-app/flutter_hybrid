package cn.missfresh.flutter_hybrid.router

import android.content.Context
import cn.missfresh.flutter_hybrid.FlutterHybridPlugin

/**
 * Created by sjl
 * on 2019-09-09
 */
class Router {

    fun openPage(context: Context?, routeName: String, params: Map<*, *>?) {
        var ctx: Context? = context
        if (ctx == null) {
            ctx = FlutterHybridPlugin.instance.getCurrentActivity()
        }

        if (ctx == null) {
            ctx = FlutterHybridPlugin.instance.getAppInfo()?.getApplication()
        }

        ctx?.let {
            FlutterHybridPlugin.instance.getAppInfo()?.startActivity(it, routeName, params)
        }
    }

    fun closePage(pageId: String) {
        FlutterHybridPlugin.instance.getContainerManager().destroyContainer("", pageId)
    }
}