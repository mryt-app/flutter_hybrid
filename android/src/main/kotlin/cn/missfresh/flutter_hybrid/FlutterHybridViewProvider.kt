package cn.missfresh.flutter_hybrid

import cn.missfresh.flutter_hybrid.interfaces.IAppInfo
import cn.missfresh.flutter_hybrid.interfaces.IFlutterHybridViewProvider
import cn.missfresh.flutter_hybrid.interfaces.IFlutterViewContainer
import cn.missfresh.flutter_hybrid.view.FHFlutterNativeView
import cn.missfresh.flutter_hybrid.view.FHFlutterView

/**
 * Created by sjl
 * on 2019-09-02
 */
class FlutterHybridViewProvider internal constructor(private val mAppInfo: IAppInfo) : IFlutterHybridViewProvider {

    private var mFlutterView: FHFlutterView? = null

    private var mFlutterNativeView: FHFlutterNativeView? = null

    override fun createFlutterView(container: IFlutterViewContainer): FHFlutterView {
        var activity = mAppInfo.getMainActivity()

        if (activity == null) {
            Logger.d("create Flutter View not with MainActivity")
            activity = container.getCurrActivity()
        }
        if (mFlutterView == null) {
            mFlutterView = FHFlutterView(activity, null, createFlutterNativeView(container))
        }
        return mFlutterView!!
    }

    override fun createFlutterNativeView(container: IFlutterViewContainer): FHFlutterNativeView {
        if (mFlutterNativeView == null) {
            mFlutterNativeView = FHFlutterNativeView(container.getCurrActivity().applicationContext)
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
        mFlutterView?.destroy()
        mFlutterNativeView?.destroy()
    }
}