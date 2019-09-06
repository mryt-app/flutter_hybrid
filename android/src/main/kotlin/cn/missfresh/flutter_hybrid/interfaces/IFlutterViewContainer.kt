package cn.missfresh.flutter_hybrid.interfaces

import android.app.Activity
import cn.missfresh.flutter_hybrid.view.FHFlutterView
import io.flutter.plugin.common.PluginRegistry

/**
 * Created by sjl
 * on 2019-09-02
 */
interface IFlutterViewContainer {

    companion object {
        const val RESULT_KEY = "_flutter_hybrid_result_"
    }

    fun getContainerName(): String

    fun getContainerParams(): Map<String, Any>

    fun getFHFlutterView(): FHFlutterView

    fun getCurrActivity(): Activity

    fun onContainerAppear()

    fun onContainerDisappear()

    fun destroyContainerView()

    fun isFinishing(): Boolean

    fun onRegisterPlugins(registry: PluginRegistry)
}