package cn.missfresh.flutter_hybrid

import cn.missfresh.flutter_hybrid.interfaces.IFlutterHybridViewProvider
import cn.missfresh.flutter_hybrid.interfaces.IFlutterViewContainer
import cn.missfresh.flutter_hybrid.view.FHFlutterView
import io.flutter.view.FlutterNativeView

/**
 * Created by sjl
 * on 2019-09-02
 */
class FlutterHybridViewProvider : IFlutterHybridViewProvider {

    private var mFlutterView: FHFlutterView? = null

    private var mFlutterNativeView: FlutterNativeView? = null

    override fun createFlutterView(container: IFlutterViewContainer): FHFlutterView {
        var activity = container.getCurrActivity()

        if (mFlutterView == null) {
            mFlutterView = FHFlutterView(activity, null, getFlutterNativeView(container))
        }
        return mFlutterView!!
    }

    override fun getFlutterNativeView(container: IFlutterViewContainer): FlutterNativeView {
        if (mFlutterNativeView == null) {
            mFlutterNativeView = FlutterNativeView(container.getCurrActivity().applicationContext)
        }
        return mFlutterNativeView!!
    }

    override fun getFHFlutterView(): FHFlutterView? {
        return mFlutterView
    }

    override fun stopFlutterView() {
        mFlutterView?.let {
            it.stopFlutterView()
        }
    }

    override fun destroy() {
        try {
            mFlutterView?.destroy()
            mFlutterNativeView?.destroy()
        } catch (e: Exception) {
            Logger.e("FlutterHybridViewProvider destroy error : $e")
        }
    }
}