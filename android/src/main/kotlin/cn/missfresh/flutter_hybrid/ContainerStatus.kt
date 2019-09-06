package cn.missfresh.flutter_hybrid

import android.os.Handler
import cn.missfresh.flutter_hybrid.interfaces.IContainerStatus
import cn.missfresh.flutter_hybrid.interfaces.IFlutterViewContainer

/**
 * Created by sjl
 * on 2019-09-02
 */
class ContainerStatus : IContainerStatus {

    private val mContainer: IFlutterViewContainer
    private val mUniqueId: String

    private var mContainerStatus = ContainerStatusEnum.STATE_UNKNOW
    private val mProxy = LifecycleProxy()

    private val mHandler = Handler()

    constructor(container: IFlutterViewContainer) {
        mContainer = container
        mUniqueId = System.currentTimeMillis().toString() + "_" + hashCode()
    }

    override fun onCreate() {
        mContainerStatus = ContainerStatusEnum.STATE_CREATED
        mContainer.getFHFlutterView().resumeFlutterView()
        mProxy.create()
    }

    override fun onAppear() {
        mContainerStatus = ContainerStatusEnum.STATE_APPEAR
        mContainer.getFHFlutterView().resumeFlutterView()
        mProxy.appear()
    }

    override fun onDisappear() {
        mProxy.disappear()
        mContainerStatus = ContainerStatusEnum.STATE_DISAPPEAR

        /**
         * Bug workaround:
         * If current container is finishing, we should call destroy flutter page early.
         */
        if (mContainer.isFinishing()) {
            mHandler.post { mProxy.destroy() }
        }
    }

    override fun onDestroy() {
        mProxy.destroy()
        mContainerStatus = ContainerStatusEnum.STATE_DESTROYED
    }

    override fun getContainer(): IFlutterViewContainer {
        return mContainer
    }

    override fun containerStatus(): Int {
        return mContainerStatus.status
    }

    override fun uniqueId(): String {
        return mUniqueId
    }

    private inner class LifecycleProxy {
        private var containerStatus = ContainerStatusEnum.STATE_UNKNOW

        fun create() {
            if (containerStatus == ContainerStatusEnum.STATE_UNKNOW) {

                FlutterHybridPlugin.instance.lifecycleMessager().invokeMethod(
                        "nativePageDidInit", mContainer.getContainerName(),
                        mContainer.getContainerParams(), mUniqueId)

                Logger.e("nativePageDidInit")

                containerStatus = ContainerStatusEnum.STATE_CREATED

                FlutterHybridPlugin.instance.lifecycleMessager().invokeMethod(
                        "nativePageWillAppear", mContainer.getContainerName(),
                        mContainer.getContainerParams(), mUniqueId)
            }
        }

        fun appear() {
            mHandler.postDelayed({

                FlutterHybridPlugin.instance.lifecycleMessager().invokeMethod(
                        "nativePageDidAppear", mContainer.getContainerName(),
                        mContainer.getContainerParams(), mUniqueId)

            }, 10)
            Logger.e("nativePageDidAppear")
            containerStatus = ContainerStatusEnum.STATE_APPEAR
        }

        fun disappear() {
            if (containerStatus < ContainerStatusEnum.STATE_DISAPPEAR) {

                FlutterHybridPlugin.instance.lifecycleMessager().invokeMethod(
                        "nativePageWillDisappear", mContainer.getContainerName(),
                        mContainer.getContainerParams(), mUniqueId)


                FlutterHybridPlugin.instance.lifecycleMessager().invokeMethod(
                        "nativePageDidDisappear", mContainer.getContainerName(),
                        mContainer.getContainerParams(), mUniqueId)

                Logger.e("nativePageDidDisappear")
                containerStatus = ContainerStatusEnum.STATE_DISAPPEAR
            }
        }

        fun destroy() {
            if (containerStatus < ContainerStatusEnum.STATE_DESTROYED) {

                FlutterHybridPlugin.instance.lifecycleMessager().invokeMethod(
                        "nativePageWillDealloc", mContainer.getContainerName(),
                        mContainer.getContainerParams(), mUniqueId)

                Logger.e("nativePageWillDealloc")
                containerStatus = ContainerStatusEnum.STATE_DESTROYED
            }
        }
    }
}