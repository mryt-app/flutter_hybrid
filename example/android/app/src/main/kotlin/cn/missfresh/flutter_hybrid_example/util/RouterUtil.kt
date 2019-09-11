package cn.missfresh.flutter_hybrid_example.util

import android.content.Context
import android.content.Intent
import cn.missfresh.flutter_hybrid.containers.FHFlutterActivity
import cn.missfresh.flutter_hybrid.messaging.Messager
import cn.missfresh.flutter_hybrid_example.activity.FlutterFragmentActivity
import cn.missfresh.flutter_hybrid_example.activity.NativeActivity
import java.io.Serializable

/**
 * Created by sjl
 * on 2019-09-01
 */
object RouterUtil {

    const val PAGE_TYPE = "page_type"
    const val FRAGMENT_TYPE = 0
    const val ACTIVITY_TYPE = 1
    const val NATIVE_TYPE = 2

    fun openPageByUrl(context: Context, routeName: String, params: Map<*, *>?, requestCode: Int = 0): Boolean {
        try {
            if (routeName.isNullOrEmpty() || context == null) {
                return false
            }

            var type = FRAGMENT_TYPE
            // PAGE_TYPE 在Flutter可以不传，此处统一处理，简化使用参数
            if (params != null && params.isNotEmpty()) {
                if (params.containsKey(PAGE_TYPE)) {
                    type = params[PAGE_TYPE] as Int
                }
            }

            when (type) {
                FRAGMENT_TYPE -> {
                    val intent = Intent(context, FHFlutterActivity::class.java)
                    startActivity(context, intent, routeName, params)
                }
                ACTIVITY_TYPE -> {
                    val intent = Intent(context, FlutterFragmentActivity::class.java)
                    startActivity(context, intent, routeName, params)
                }
                NATIVE_TYPE -> {
                    // 打开native页面，使用url和params需业务方根据自己的路由规则调用已存在的路由处理方法打开业务方自己的页面
                    val intent = Intent(context, NativeActivity::class.java)
                    startActivity(context, intent, routeName, params)
                }
            }
            return true
        } catch (t: Throwable) {
            return false
        }
    }

    private fun startActivity(context: Context, intent: Intent, routeName: String, params: Map<*, *>?) {
        context?.let {
            intent.putExtra(Messager.ROUTE_NAME, routeName)
            if (params != null && params.isNotEmpty()) {
                intent.putExtra(Messager.PARAMS, params as Serializable)
            }
            it.startActivity(intent)
        }
    }
}