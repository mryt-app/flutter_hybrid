package cn.missfresh.flutter_hybrid.router

import android.content.Context
import cn.missfresh.flutter_hybrid.FlutterHybridPlugin

/**
 * Created by sjl
 * on 2019-09-09
 */
class Router {

    /**
     *  Open a new page through the native page, which may be a native page,
     *  or a Flutter page loaded with an Activity container, or a Flutter
     *  page loaded with a Fragment. Specifically, what type of page can be
     *  controlled by adding a custom page_type field in params, please refer
     *  to demo
     */
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

    /**
     * Close page
     *
     * @param pageId Corresponding container's containId
     */
    fun closePage(pageId: String) {
        FlutterHybridPlugin.instance.getContainerManager().destroyContainer("", pageId)
    }
}