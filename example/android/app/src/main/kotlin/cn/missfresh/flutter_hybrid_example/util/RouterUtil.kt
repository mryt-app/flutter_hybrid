package cn.missfresh.flutter_hybrid_example.util

import android.content.Context
import android.content.Intent
import cn.missfresh.flutter_hybrid.messaging.Messager
import cn.missfresh.flutter_hybrid_example.activity.FlutterActivity
import cn.missfresh.flutter_hybrid_example.activity.FlutterFragmentActivity
import cn.missfresh.flutter_hybrid_example.activity.NativeActivity
import java.io.Serializable

/**
 * Created by sjl
 * on 2019-09-01
 */
object RouterUtil {

    const val PAGE_TYPE = "page_type"
    const val ACTIVITY_TYPE = 0
    const val FRAGMENT_TYPE = 1
    const val NATIVE_TYPE = 2

    fun openPageByUrl(context: Context, routeName: String, params: Map<*, *>?, requestCode: Int = 0): Boolean {
        try {
            if (routeName.isNullOrEmpty() || context == null) {
                return false
            }

            var type = ACTIVITY_TYPE
            if (params != null && params.isNotEmpty()) {
                if (params.containsKey(PAGE_TYPE)) {
                    type = params[PAGE_TYPE] as Int
                }
            }

            when (type) {
                ACTIVITY_TYPE -> {
                    var intent = Intent(context, FlutterFragmentActivity::class.java)
                    intent.putExtra(Messager.ROUTE_NAME, routeName)
                    if (params != null && params.isNotEmpty()) {
                        intent.putExtra(Messager.PARAMS, params as Serializable)
                    }
                    context.startActivity(intent)
                }
                FRAGMENT_TYPE -> {
                    var intent = Intent(context, FlutterActivity::class.java)
                    intent.putExtra(Messager.ROUTE_NAME, routeName)
                    if (params != null && params.isNotEmpty()) {
                        intent.putExtra(Messager.PARAMS, params as Serializable)
                    }
                    context.startActivity(intent)
                }
                NATIVE_TYPE -> {
                    // 打开native页面，使用url和params需业务方根据自己的路由规则调用已存在的路由处理方法打开业务方自己的页面
                    context.startActivity(Intent(context, NativeActivity::class.java))
                }
            }
            return true
        } catch (t: Throwable) {
            return false
        }
    }
}