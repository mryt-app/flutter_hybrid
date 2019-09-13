package cn.missfresh.flutter_hybrid.lifecycle

import android.os.Handler
import cn.missfresh.flutter_hybrid.FlutterHybridPlugin
import cn.missfresh.flutter_hybrid.Logger
import cn.missfresh.flutter_hybrid.interfaces.IContainerLifecycle
import cn.missfresh.flutter_hybrid.interfaces.IFlutterViewContainer

/**
 * Created by sjl
 * on 2019-09-02
 */
class ContainerLifecycleManager : IContainerLifecycle {

    private val mContainer: IFlutterViewContainer
    val mContainerId: String

    private var mContainerStatus = ContainerLifecycleEnum.STATE_UN_KNOW
    private val mLifecycleProxy = LifecycleProxy()

    private val mHandler = Handler()

    constructor(container: IFlutterViewContainer) {
        mContainer = container
        mContainerId = System.currentTimeMillis().toString() + "_" + hashCode()
    }

    override fun onCreate() {
        mContainerStatus = ContainerLifecycleEnum.STATE_CREATED
        mContainer.getFHFlutterView().resumeFlutterView()
        mLifecycleProxy.create()
    }

    override fun onAppear() {
        mContainerStatus = ContainerLifecycleEnum.STATE_APPEAR
        mContainer.getFHFlutterView().resumeFlutterView()
        mLifecycleProxy.appear()
    }

    override fun onDisappear() {
        mLifecycleProxy.disappear()
        mContainerStatus = ContainerLifecycleEnum.STATE_DISAPPEAR

        /**
         * If current container is finishing, we should call destroy flutter page early.
         */
        if (mContainer.isFinishing()) {
            mHandler.post { mLifecycleProxy.destroy() }
        }
    }

    override fun onDestroy() {
        mLifecycleProxy.destroy()
        mContainerStatus = ContainerLifecycleEnum.STATE_DESTROYED
    }

    override fun getContainer(): IFlutterViewContainer {
        return mContainer
    }

    override fun getContainerLifecycleState(): Int {
        return mContainerStatus.lifecycleState
    }

    override fun containerId(): String {
        return mContainerId
    }

    private inner class LifecycleProxy {
        private var containerStatus = ContainerLifecycleEnum.STATE_UN_KNOW

        fun create() {
            if (containerStatus == ContainerLifecycleEnum.STATE_UN_KNOW) {

                FlutterHybridPlugin.instance.getLifecycleMessager().invokeMethod(
                        "nativePageDidInit", mContainer.getContainerName(),
                        mContainer.getContainerParams(), mContainerId)

                Logger.d("LifecycleProxy nativePageDidInit")

                containerStatus = ContainerLifecycleEnum.STATE_CREATED

                FlutterHybridPlugin.instance.getLifecycleMessager().invokeMethod(
                        "nativePageWillAppear", mContainer.getContainerName(),
                        mContainer.getContainerParams(), mContainerId)
            }
        }

        fun appear() {
            mHandler.postDelayed({

                FlutterHybridPlugin.instance.getLifecycleMessager().invokeMethod(
                        "nativePageDidAppear", mContainer.getContainerName(),
                        mContainer.getContainerParams(), mContainerId)

            }, 10)
            Logger.d("LifecycleProxy nativePageDidAppear")
            containerStatus = ContainerLifecycleEnum.STATE_APPEAR
        }

        fun disappear() {
            if (containerStatus < ContainerLifecycleEnum.STATE_DISAPPEAR) {

                FlutterHybridPlugin.instance.getLifecycleMessager().invokeMethod(
                        "nativePageWillDisappear", mContainer.getContainerName(),
                        mContainer.getContainerParams(), mContainerId)


                FlutterHybridPlugin.instance.getLifecycleMessager().invokeMethod(
                        "nativePageDidDisappear", mContainer.getContainerName(),
                        mContainer.getContainerParams(), mContainerId)

                Logger.d("LifecycleProxy nativePageWillDisappear and nativePageDidDisappear")
                containerStatus = ContainerLifecycleEnum.STATE_DISAPPEAR
            }
        }

        fun destroy() {
            if (containerStatus < ContainerLifecycleEnum.STATE_DESTROYED) {

                FlutterHybridPlugin.instance.getLifecycleMessager().invokeMethod(
                        "nativePageWillDealloc", mContainer.getContainerName(),
                        mContainer.getContainerParams(), mContainerId)

                Logger.d("LifecycleProxy nativePageWillDealloc")
                containerStatus = ContainerLifecycleEnum.STATE_DESTROYED
            }
        }
    }
}