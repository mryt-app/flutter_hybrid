package cn.missfresh.flutter_hybrid

import android.util.Log
import java.lang.Exception

/**
 * Created by sjl
 * on 2019-09-02
 */
object Logger {
    private const val TAG = "flutter_hybrid"

    fun e(msg: String) {
        if (isDebug()) {
            Log.e(TAG, msg)
        }
    }

    fun d(msg: String) {
        if (isDebug()) {
            Log.d(TAG, msg)
        }
    }

    fun i(msg: String) {
        if (isDebug()) {
            Log.i(TAG, msg)
        }
    }

    fun isDebug(): Boolean {
        return try {
            if (FlutterHybridPlugin.instance.appInfo() != null) {
                FlutterHybridPlugin.instance.appInfo()!!.isDebug()
            } else {
                false
            }
        } catch (e: Exception) {
            false
        }
    }
}