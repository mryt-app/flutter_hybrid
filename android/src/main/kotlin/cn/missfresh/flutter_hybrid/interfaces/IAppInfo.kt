package cn.missfresh.flutter_hybrid.interfaces

import android.app.Application
import android.content.Context

/**
 * Created by sjl
 * on 2019-09-02
 */
interface IAppInfo {

    fun getApplication(): Application

    fun startActivity(context: Context?, routeName: String, params: Map<*, *>?): Boolean

    fun isDebug(): Boolean

}