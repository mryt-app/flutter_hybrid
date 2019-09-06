package cn.missfresh.flutter_hybrid_example.util

import android.content.Context
import android.content.Intent
import cn.missfresh.flutter_hybrid_example.activity.FlutterActivity
import cn.missfresh.flutter_hybrid_example.activity.FlutterFragmentActivity
import cn.missfresh.flutter_hybrid_example.activity.NativeActivity

/**
 * Created by sjl
 * on 2019-09-01
 */
object RouterUtil {

    const val NATIVE_ACTIVITY_URL = "eg://nativeActivity"
    const val FLUTTER_ACTIVITY_URL = "eg://flutterActivity"
    const val FLUTTER_FRAGMENT_ACTIVITY_URL = "eg://flutterFragmentActivity"

    fun openPageByUrl(context: Context, url: String, requestCode: Int = 0): Boolean {
        try {
            return when {
                url.isNullOrEmpty() || context == null -> {
                    return false
                }
                url.startsWith(FLUTTER_ACTIVITY_URL) -> {
                    context.startActivity(Intent(context, FlutterActivity::class.java))
                    true
                }
                url.startsWith(FLUTTER_FRAGMENT_ACTIVITY_URL) -> {
                    context.startActivity(Intent(context, FlutterFragmentActivity::class.java))
                    true
                }
                url.startsWith(NATIVE_ACTIVITY_URL) -> {
                    context.startActivity(Intent(context, NativeActivity::class.java))
                    true
                }
                else -> false
            }
        } catch (t: Throwable) {
            return false
        }
    }
}