package cn.missfresh.flutter_hybrid.containers

import android.app.Activity
import android.content.Context
import android.graphics.Color
import android.os.Bundle
import android.support.v4.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import cn.missfresh.flutter_hybrid.FlutterHybridPlugin
import cn.missfresh.flutter_hybrid.interfaces.IFlutterViewContainer
import cn.missfresh.flutter_hybrid.view.FHFlutterView

/**
 * Created by sjl
 * on 2019-09-02
 */
abstract class FHFlutterFragment : Fragment(), IFlutterViewContainer {

    private lateinit var mContent: FlutterContent
    private var resumed = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        onRegisterPlugins(FlutterHybridPlugin.instance.containerManager().onContainerCreate(this))
    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        super.onCreateView(inflater, container, savedInstanceState)
        mContent = FlutterContent(activity!!)
        return mContent
    }

    override fun onResume() {
        super.onResume()
        if (!resumed) {
            resumed = true
            FlutterHybridPlugin.instance.containerManager().onContainerAppear(this)
            mContent.attachFlutterView(getFHFlutterView())
        }
    }

    override fun onPause() {
        super.onPause()
        if (resumed) {
            resumed = false
            mContent.snapshot()
            FlutterHybridPlugin.instance.containerManager().onContainerDisappear(this)
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        mContent.removeViews()
        FlutterHybridPlugin.instance.containerManager().onContainerDestroy(this)
    }

    override fun getFHFlutterView(): FHFlutterView {
        return FlutterHybridPlugin.instance.viewProvider().createFlutterView(this)
    }

    override fun getCurrActivity(): Activity {
        return context as Activity
    }

    override fun onContainerAppear() {
        mContent.onContainerAppear()
    }

    override fun onContainerDisappear() {
        mContent.onContainerDisappear()
    }

    override fun isFinishing(): Boolean {
        return (context as Activity).isFinishing
    }

    protected fun createFlutterInitCoverView(): View {
        val initCover = View(context)
        initCover.setBackgroundColor(Color.WHITE)
        return initCover
    }

    internal inner class FlutterContent(context: Context) : FlutterViewStub(context) {

        override val getFHFlutterView: FHFlutterView
            get() = this@FHFlutterFragment.getFHFlutterView()

        fun createFlutterInitCoverView(): View {
            return this@FHFlutterFragment.createFlutterInitCoverView()
        }
    }

}