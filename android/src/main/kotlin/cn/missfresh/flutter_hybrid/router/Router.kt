package cn.missfresh.flutter_hybrid.router

import android.content.Context
import cn.missfresh.flutter_hybrid.FlutterHybridPlugin

/**
 * Created by sjl
 * on 2019-09-09
 */
class Router {

    fun openPage(context: Context?, routeName: String, params: Map<*, *>?, requestCode: Int = -1) {
        var ctx: Context? = context
        if (ctx == null) {
            ctx = FlutterHybridPlugin.instance.currentActivity()
        }

        if (ctx == null) {
            ctx = FlutterHybridPlugin.instance.appInfo()?.getApplication()
        }

        ctx?.let {
            FlutterHybridPlugin.instance.appInfo()?.startActivity(it, routeName, params, requestCode)
        }
    }

    fun closePage(pageId: String) {
        FlutterHybridPlugin.instance.containerManager().destroyContainer("", pageId)
    }
}