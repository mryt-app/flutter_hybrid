package cn.missfresh.flutter_hybrid_example.util

import android.content.Context
import android.content.Intent
import cn.missfresh.flutter_hybrid.Logger
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

    const val FLUTTER_TYPE = "flutter_type"

    fun openPageByUrl(context: Context, routeName: String, params: Map<*, *>?, requestCode: Int = 0): Boolean {
        try {
            if (routeName.isNullOrEmpty() || context == null) {
                return false
            }

            var type = 1
            // todo type=1,native->flutter
            Logger.e("openPageByUrl == params:$params")
//            if (params != null && params.isNotEmpty()) {
//                Logger.e("openPageByUrl == params1111:$params")
//
//                if (params.containsKey(FLUTTER_TYPE)) {
//                    type = params[FLUTTER_TYPE] as Int
//                }
//            }

            when (type) {
                0 -> {
                    var intent = Intent(context, FlutterFragmentActivity::class.java)
                    intent.putExtra(Messager.ROUTE_NAME, routeName)
                    if (params != null && params.isNotEmpty()) {
                        intent.putExtra(Messager.PARAMS, params as Serializable)
                    }
                    context.startActivity(intent)
                }
                1 -> {
                    var intent = Intent(context, FlutterActivity::class.java)
                    intent.putExtra(Messager.ROUTE_NAME, routeName)
                    if (params != null && params.isNotEmpty()) {
                        intent.putExtra(Messager.PARAMS, params as Serializable)
                    }
                    context.startActivity(intent)
                }
                2 -> {
                    // todo 打开native页面，使用url和params需业务方根据自己的路由规则调用已存在的路由处理方法打开业务方自己的页面
                    context.startActivity(Intent(context, NativeActivity::class.java))
                }
            }

            return true
        } catch (t: Throwable) {
            return false
        }
    }
}