package cn.missfresh.flutter_hybrid.containers

import android.app.Activity
import android.os.Bundle
import android.support.v4.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import cn.missfresh.flutter_hybrid.FlutterHybridPlugin
import cn.missfresh.flutter_hybrid.Logger
import cn.missfresh.flutter_hybrid.interfaces.IFlutterViewContainer
import cn.missfresh.flutter_hybrid.messaging.Messager.Companion.PARAMS
import cn.missfresh.flutter_hybrid.messaging.Messager.Companion.ROUTE_NAME
import cn.missfresh.flutter_hybrid.view.FHFlutterView

/**
 * Created by sjl
 * on 2019-09-02
 */
abstract class FHFlutterFragment : Fragment(), IFlutterViewContainer {

    private lateinit var mFlutterContent: FlutterViewStub
    private var resumed = false
    private var canPopFlutterView: Boolean = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        onRegisterPlugins(FlutterHybridPlugin.instance.containerManager().onContainerCreate(this))
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        super.onCreateView(inflater, container, savedInstanceState)
        mFlutterContent = FlutterViewStub(activity!!, FlutterHybridPlugin.instance.viewProvider().createFlutterView(this))
        return mFlutterContent
    }

    override fun onResume() {
        super.onResume()
        if (!resumed) {
            resumed = true
            FlutterHybridPlugin.instance.containerManager().onContainerAppear(this)
            mFlutterContent.attachFlutterView(getFHFlutterView())
        }
    }

    override fun onPause() {
        super.onPause()
        if (resumed) {
            resumed = false
            mFlutterContent.snapshot()
            FlutterHybridPlugin.instance.containerManager().onContainerDisappear(this)
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        mFlutterContent.removeViews()
        FlutterHybridPlugin.instance.containerManager().onContainerDestroy(this)
    }

    override fun getFHFlutterView(): FHFlutterView {
        return FlutterHybridPlugin.instance.viewProvider().createFlutterView(this)
    }

    override fun getCurrActivity(): Activity {
        return context as Activity
    }

    override fun onContainerAppear() {
        mFlutterContent.onContainerAppear()
    }

    override fun onContainerDisappear() {
        mFlutterContent.onContainerDisappear()
    }

    override fun destroyContainerView() {
        activity?.finish()
    }

    override fun isFinishing(): Boolean {
        return (context as Activity).isFinishing
    }

    override fun setContainerCanPop(canPop: Boolean) {
        canPopFlutterView = canPop
    }

    override fun getContainerCanPop(): Boolean {
        return canPopFlutterView
    }

    override fun getContainerName(): String {
        activity?.intent?.extras?.getString(ROUTE_NAME)?.let {
            return it
        }
        return ""
    }

    override fun getContainerParams(): Map<String, Any> {
        var params = hashMapOf<String, Any>()
        activity?.intent?.extras?.let {
            if (it.containsKey(PARAMS)) {
                it.getSerializable(PARAMS)?.let {
                    Logger.e("FHFlutterFragment getContainerParams:$it")
                    Logger.e("""FHFlutterFragment getContainerParams:${(it as HashMap<String, Any>)}""")
                    it as HashMap<String, Any>
                    if (!it.isNullOrEmpty()) {
                        Logger.e("""FHFlutterFragment Params isNullOrEmpty :${(it as HashMap<String, Any>)}""")
                        params = it
                    }
                }
            }
        }
        if (params.isEmpty()) {
            params["default"] = "default"
            Logger.e("""FHFlutterFragment params is isEmpty:$params""")
        } else {
            Logger.e("""FHFlutterFragment params:$params""")
        }
        return params
    }
}