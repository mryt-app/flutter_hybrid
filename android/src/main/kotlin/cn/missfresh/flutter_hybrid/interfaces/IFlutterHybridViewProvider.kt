package cn.missfresh.flutter_hybrid.interfaces

import cn.missfresh.flutter_hybrid.view.FHFlutterView
import io.flutter.view.FlutterNativeView

/**
 * Created by sjl
 * on 2019-09-02
 */
interface IFlutterHybridViewProvider {

    /**
     * Return a FHFlutterView , create FHFlutterView when FHFlutterView is null.
     */
    fun createFlutterView(container: IFlutterViewContainer): FHFlutterView

    /**
     * Return a FlutterNativeView , create FHFlutterView when FlutterNativeView is null.
     */
    fun getFlutterNativeView(container: IFlutterViewContainer): FlutterNativeView

    /**
     * Return a FHFlutterView , but FHFlutterView might be null.
     */
    fun getFHFlutterView(): FHFlutterView?

    /**
     * Calling the onStop method of FlutterView to synchronize the lifecycle state
     */
    fun stopFlutterView()

    /**
     * Called when the application is no longer alive ,
     * Call the FlutterView destroy method and the FlutterNativeView destroy method.
     */
    fun destroy()
}