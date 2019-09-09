package cn.missfresh.flutter_hybrid.interfaces

import cn.missfresh.flutter_hybrid.view.FHFlutterView
import io.flutter.view.FlutterNativeView

/**
 * Created by sjl
 * on 2019-09-02
 */
interface IFlutterHybridViewProvider {

    fun createFlutterView(container: IFlutterViewContainer): FHFlutterView

    fun getFlutterNativeView(container: IFlutterViewContainer): FlutterNativeView

    fun getFHFlutterView(): FHFlutterView?

    fun stopFlutterView()

    fun destroy()
}