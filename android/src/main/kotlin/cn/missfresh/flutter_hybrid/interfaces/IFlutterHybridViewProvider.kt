package cn.missfresh.flutter_hybrid.interfaces

import cn.missfresh.flutter_hybrid.view.FHFlutterNativeView
import cn.missfresh.flutter_hybrid.view.FHFlutterView

/**
 * Created by sjl
 * on 2019-09-02
 */
interface IFlutterHybridViewProvider {

    fun createFlutterView(container: IFlutterViewContainer): FHFlutterView

    fun createFlutterNativeView(container: IFlutterViewContainer): FHFlutterNativeView

    fun getFHFlutterView(): FHFlutterView?

    fun stopFlutterView()

    fun destroy()
}