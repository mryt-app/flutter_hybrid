package cn.missfresh.flutter_hybrid.containers

import android.app.Activity
import android.os.Bundle
import cn.missfresh.flutter_hybrid.FlutterHybridPlugin
import cn.missfresh.flutter_hybrid.Logger
import cn.missfresh.flutter_hybrid.interfaces.IFlutterViewContainer
import cn.missfresh.flutter_hybrid.messaging.Messager
import cn.missfresh.flutter_hybrid.view.FHFlutterView

/**
 * Created by sjl
 * on 2019-09-02
 */
class FHFlutterActivity : Activity(), IFlutterViewContainer {

    private lateinit var mFlutterContent: FlutterViewStub

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        mFlutterContent = FlutterViewStub(this, FlutterHybridPlugin
                .instance.getViewProvider().createFlutterView(this))

        setContentView(mFlutterContent)

        FlutterHybridPlugin.instance
                .getContainerManager().onContainerCreate(this)
    }

    override fun onPostResume() {
        super.onPostResume()
        FlutterHybridPlugin.instance.getContainerManager().onContainerAppear(this)
        mFlutterContent.attachFlutterView(getFHFlutterView())
    }

    override fun onPause() {
        mFlutterContent.detachFlutterView()
        FlutterHybridPlugin.instance.getContainerManager().onContainerDisappear(this)
        super.onPause()
    }

    override fun onDestroy() {
        FlutterHybridPlugin.instance.getContainerManager().onContainerDestroy(this)
        mFlutterContent.removeViews()
        super.onDestroy()
    }

    override fun onBackPressed() {
        FlutterHybridPlugin.instance.getContainerManager().onBackPressed(this)
    }

    override fun getContainerName(): String {
        return intent?.extras?.getString(Messager.ROUTE_NAME) ?: ""
    }

    override fun getContainerParams(): Map<String, Any> {
        var params = mapOf<String, Any>()
        intent?.extras?.getSerializable(Messager.PARAMS)?.let {
            params = it as Map<String, Any>
        }
        Logger.d("FHFlutterActivity containerParams:$params")
        return params
    }

    override fun getFHFlutterView(): FHFlutterView {
        return FlutterHybridPlugin.instance.getViewProvider().createFlutterView(this)
    }

    override fun getCurrActivity(): Activity {
        return this
    }

    override fun onContainerAppear() {
        mFlutterContent.onContainerAppear()
    }

    override fun onContainerDisappear() {
        mFlutterContent.onContainerDisappear()
    }

    override fun destroyContainerView() {
        finish()
    }
}