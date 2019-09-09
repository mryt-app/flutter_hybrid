package cn.missfresh.flutter_hybrid

import android.os.Handler
import android.os.Looper
import android.text.TextUtils
import cn.missfresh.flutter_hybrid.interfaces.IContainerLifecycle
import cn.missfresh.flutter_hybrid.interfaces.IContainerManager
import cn.missfresh.flutter_hybrid.interfaces.IFlutterViewContainer
import cn.missfresh.flutter_hybrid.view.FHFlutterView
import io.flutter.plugin.common.PluginRegistry
import io.flutter.view.FlutterMain
import io.flutter.view.FlutterRunArguments

/**
 * Created by sjl
 * on 2019-09-02
 */
class FlutterViewContainerManager : IContainerManager {

    private var mCurrentStatus: IContainerLifecycle? = null

    private val mStatusList = HashMap<IFlutterViewContainer, IContainerLifecycle>()

    override fun onContainerCreate(container: IFlutterViewContainer): PluginRegistry {
        assertCallOnMainThread()

        val containerLifecycleManager = ContainerLifecycleManager(container)
        if (mStatusList.put(container, containerLifecycleManager) != null) {
            Logger.e("container ${container.getContainerName()} already exists!")
            return PluginRegistryImpl(container.getFHFlutterView())
        }

        FlutterMain.ensureInitializationComplete(container.getCurrActivity().applicationContext, null)
        val flutterView = FlutterHybridPlugin.instance.viewProvider().createFlutterView(container)
        if (!flutterView.flutterNativeView.isApplicationRunning) {
            val appBundlePath = FlutterMain.findAppBundlePath(container.getCurrActivity().applicationContext)
            appBundlePath?.let {
                val arguments = FlutterRunArguments()
                arguments.bundlePath = it
                arguments.entrypoint = "main"
                flutterView.runFromBundle(arguments)
            }
        }

        mStatusList[container]?.apply {
            if (getState() == ContainerLifecycleEnum.STATE_UN_KNOW.status) {
                onCreate()
            }

            mCurrentStatus = this
        }

        return PluginRegistryImpl(container.getFHFlutterView())
    }

    override fun onContainerAppear(container: IFlutterViewContainer) {
        assertCallOnMainThread()

        mStatusList[container]?.apply {
            //            if (getState() != ContainerLifecycleEnum.STATE_CREATED.status
//                    && getState() != ContainerLifecycleEnum.STATE_DISAPPEAR.status) {
            if (getState() != ContainerLifecycleEnum.STATE_CREATED.status) {
                Logger.e("performAppear state error, current state:" + getState())
                return
            }
            onAppear()
            mCurrentStatus = this
        }
    }

    override fun onContainerDisappear(container: IFlutterViewContainer) {
        assertCallOnMainThread()
        mStatusList[container]?.apply {
            if (getState() == ContainerLifecycleEnum.STATE_APPEAR.status) {
                onDisappear()
            }
            mCurrentStatus = this
        }
        if (!container.isFinishing()) {
            checkIfFlutterViewNeedStopLater()
        }
    }

    override fun onContainerDestroy(container: IFlutterViewContainer) {
        assertCallOnMainThread()

        mCurrentStatus?.let {
            if (it.getContainer() == container) {
                mCurrentStatus = null
            }
        }

        val record = mStatusList.remove(container)
        if (record == null) {
            Logger.e("container:" + container.getContainerName() + " not exists yet!")
            return
        }

        mStatusList[container]?.apply {
            if (getState() == ContainerLifecycleEnum.STATE_DESTROYED.status) {
                onDestroy()
            }
            mCurrentStatus = this
        }

        checkIfFlutterViewNeedStopLater()
    }

    private fun checkIfFlutterViewNeedStopLater() {
        Handler(Looper.getMainLooper()).postDelayed({
            if (!hasContainerAppear()) {
                FlutterHybridPlugin.instance.viewProvider().stopFlutterView()
            }
        }, 100)
    }

    override fun hasContainerAppear(): Boolean {
        assertCallOnMainThread()

        for (entry in mStatusList.entries) {
            if (entry.value.getState() === ContainerLifecycleEnum.STATE_APPEAR.status) {
                return true
            }
        }
        return false
    }

    override fun onBackPressed(container: IFlutterViewContainer) {
        assertCallOnMainThread()

        mStatusList[container]?.let {

            FlutterHybridPlugin.instance.dataMessage().invokeMethod("backButtonPressed",
                    container.getContainerName(), container.getContainerParams(), it.containerId())
        }
    }

    override fun destroyContainer(name: String, uq: String) {
        assertCallOnMainThread()

        var done = false
        for (entry in mStatusList.entries) {
            if (TextUtils.equals(uq, entry.value.containerId())) {
                entry.key.destroyContainerView()
                done = true
                break
            }
        }

        if (!done) {
            Logger.e("destroyContainer can not find name:$name containerId:$uq")
        }
    }

    override fun getCurrentStatus(): IContainerLifecycle? {
        return mCurrentStatus
    }

    override fun getLastContainerStatus(): IContainerLifecycle? {
        val values = mStatusList.values
        if (!values.isEmpty()) {
            val array = ArrayList(values)
            return array[array.size - 1]
        }
        return null
    }

    override fun onShownContainerChanged(old: String, now: String) {
        assertCallOnMainThread()
        Logger.d("onShownContainerChanged")
        var oldContainer: IFlutterViewContainer? = null
        var nowContainer: IFlutterViewContainer? = null

        for (entry in mStatusList.entries) {
            if (TextUtils.equals(old, entry.value.containerId())) {
                oldContainer = entry.key
            }

            if (TextUtils.equals(now, entry.value.containerId())) {
                nowContainer = entry.key
            }

            if (oldContainer != null && nowContainer != null) {
                break
            }
        }

        nowContainer?.onContainerAppear()

        oldContainer?.onContainerDisappear()
    }

    private fun assertCallOnMainThread() {
        if (Looper.myLooper() != Looper.getMainLooper()) {
            Logger.e("must call method on main thread")
        }
    }

    class PluginRegistryImpl internal constructor(private val fhFlutterView: FHFlutterView) : PluginRegistry {

        override fun registrarFor(pluginKey: String): PluginRegistry.Registrar {
            return fhFlutterView.pluginRegistry.registrarFor(pluginKey)
        }

        override fun hasPlugin(key: String): Boolean {
            return fhFlutterView.pluginRegistry.hasPlugin(key)
        }

        override fun <T> valuePublishedByPlugin(pluginKey: String): T {
            return fhFlutterView.pluginRegistry.valuePublishedByPlugin(pluginKey)
        }
    }
}