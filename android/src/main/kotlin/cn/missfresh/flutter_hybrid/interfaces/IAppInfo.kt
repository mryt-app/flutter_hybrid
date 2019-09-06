package cn.missfresh.flutter_hybrid.interfaces

import android.app.Activity
import android.app.Application
import android.content.Context

/**
 * Created by sjl
 * on 2019-09-02
 */
interface IAppInfo {

    fun getMainActivity(): Activity?

    fun getApplication(): Application

    fun isDebug(): Boolean

    fun startActivity(context: Context, url: String, requestCode: Int): Boolean
}