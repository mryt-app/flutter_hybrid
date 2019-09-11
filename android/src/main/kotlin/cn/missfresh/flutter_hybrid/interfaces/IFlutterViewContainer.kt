package cn.missfresh.flutter_hybrid.interfaces

import android.app.Activity
import cn.missfresh.flutter_hybrid.view.FHFlutterView

/**
 * Created by sjl
 * on 2019-09-02
 */
interface IFlutterViewContainer {

    fun getContainerName(): String

    fun getContainerParams(): Map<String, Any>

    fun getFHFlutterView(): FHFlutterView

    fun getCurrActivity(): Activity

    fun onContainerAppear()

    fun onContainerDisappear()

    fun destroyContainerView()

    fun isFinishing(): Boolean

    fun setContainerCanPop(canPop: Boolean)

    fun getContainerCanPop(): Boolean
}