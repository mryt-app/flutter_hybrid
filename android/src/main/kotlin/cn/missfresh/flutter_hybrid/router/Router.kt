package cn.missfresh.flutter_hybrid.router

import android.content.Context
import android.net.Uri
import cn.missfresh.flutter_hybrid.FlutterHybridPlugin
import cn.missfresh.flutter_hybrid.Logger
import com.alibaba.fastjson.JSON
import java.io.UnsupportedEncodingException
import java.net.URLEncoder

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
        FlutterHybridPlugin.instance.containerManager()
                .destroyContainer("", pageId)
    }

//    private fun concatUrl(url: String, params: Map<*, *>?): String {
//        if (params == null || params!!.isEmpty())
//            return url
//
//        val uri = Uri.parse(url)
//        val builder = uri.buildUpon()
//        for ((key, value) in params) {
//            value?.let {
//                var str: String
//                str = if (it is Map<*, *> || it is List<*>) {
//                    try {
//                        URLEncoder.encode(JSON.toJSONString(value), "utf-8")
//                    } catch (e: UnsupportedEncodingException) {
//                        it.toString()
//                    }
//                } else {
//                    it.toString()
//                }
//                builder.appendQueryParameter(key.toString(), str)
//            }
//        }
//        Logger.e("concatUrl==" + builder.build().toString())
//        return builder.build().toString()
//    }
}