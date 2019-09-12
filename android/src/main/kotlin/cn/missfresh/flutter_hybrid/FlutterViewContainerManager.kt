package cn.missfresh.flutter_hybrid

import android.os.Handler
import android.os.Looper
import android.text.TextUtils
import cn.missfresh.flutter_hybrid.interfaces.IContainerLifecycle
import cn.missfresh.flutter_hybrid.interfaces.IContainerManager
import cn.missfresh.flutter_hybrid.interfaces.IFlutterViewContainer
import cn.missfresh.flutter_hybrid.lifecycle.ContainerLifecycleEnum
import cn.missfresh.flutter_hybrid.lifecycle.ContainerLifecycleManager
import cn.missfresh.flutter_hybrid.messaging.DataMessager.Companion.BACK_BUTTON_PRESSED
import cn.missfresh.flutter_hybrid.view.FHFlutterView
import io.flutter.plugin.common.PluginRegistry
import io.flutter.view.FlutterMain
import io.flutter.view.FlutterRunArguments

/**
 * Created by sjl
 * on 2019-09-02
 */
class FlutterViewContainerManager : IContainerManager {

    private var mCurrentLifecycleState: IContainerLifecycle? = null

    private val mContainLifecycleList = HashMap<IFlutterViewContainer, IContainerLifecycle>()

    override fun onContainerCreate(container: IFlutterViewContainer): PluginRegistry {
        assertCallOnMainThread()

        val containerLifecycleManager = ContainerLifecycleManager(container)
        val pluginRegistry: PluginRegistryImpl
        if (mContainLifecycleList.put(container, containerLifecycleManager) != null) {
            Logger.e("container ${container.getContainerName()} already exists!")
            pluginRegistry = PluginRegistryImpl(container.getFHFlutterView())
            registerPlugins(pluginRegistry)
            return pluginRegistry
        }

        FlutterMain.ensureInitializationComplete(container.getCurrActivity().applicationContext, null)
        val flutterView = FlutterHybridPlugin.instance.getViewProvider().createFlutterView(container)
        if (!flutterView.flutterNativeView.isApplicationRunning) {
            val appBundlePath = FlutterMain.findAppBundlePath(container.getCurrActivity().applicationContext)
            appBundlePath?.let {
                val arguments = FlutterRunArguments()
                arguments.bundlePath = it
                arguments.entrypoint = "main"
                flutterView.runFromBundle(arguments)
            }
        }

        mContainLifecycleList[container]?.apply {
            if (getContainerLifecycleState() == ContainerLifecycleEnum.STATE_UN_KNOW.lifecycleState) {
                onCreate()
            }

            mCurrentLifecycleState = this
        }
        pluginRegistry = PluginRegistryImpl(container.getFHFlutterView())
        registerPlugins(pluginRegistry)
        return pluginRegistry
    }

    override fun onContainerAppear(container: IFlutterViewContainer) {
        assertCallOnMainThread()

        mContainLifecycleList[container]?.apply {
            if (getContainerLifecycleState() != ContainerLifecycleEnum.STATE_CREATED.lifecycleState
                    && getContainerLifecycleState() != ContainerLifecycleEnum.STATE_DISAPPEAR.lifecycleState) {
                Logger.e("onContainerAppear state error, current state:" + getContainerLifecycleState())
                return
            }
            onAppear()
            mCurrentLifecycleState = this
        }
    }

    override fun onContainerDisappear(container: IFlutterViewContainer) {
        assertCallOnMainThread()
        mContainLifecycleList[container]?.apply {
            if (getContainerLifecycleState() == ContainerLifecycleEnum.STATE_APPEAR.lifecycleState) {
                onDisappear()
            }
            mCurrentLifecycleState = this
        }
        if (!container.isFinishing()) {
            checkIfFlutterViewNeedStopLater()
        }
    }

    override fun onContainerDestroy(container: IFlutterViewContainer) {
        assertCallOnMainThread()

        mCurrentLifecycleState?.let {
            if (it.getContainer() == container) {
                mCurrentLifecycleState = null
            }
        }

        val record = mContainLifecycleList.remove(container)
        if (record == null) {
            Logger.e("container:" + container.getContainerName() + " not exists yet!")
            return
        }

        mContainLifecycleList[container]?.apply {
            if (getContainerLifecycleState() == ContainerLifecycleEnum.STATE_DESTROYED.lifecycleState) {
                onDestroy()
            }
            mCurrentLifecycleState = this
        }

        checkIfFlutterViewNeedStopLater()
    }

    private fun checkIfFlutterViewNeedStopLater() {
        Handler(Looper.getMainLooper()).postDelayed({
            if (!hasContainerAppear()) {
                FlutterHybridPlugin.instance.getViewProvider().stopFlutterView()
            }
        }, 100)
    }

    override fun hasContainerAppear(): Boolean {
        assertCallOnMainThread()

        for (entry in mContainLifecycleList.entries) {
            if (entry.value.getContainerLifecycleState() === ContainerLifecycleEnum.STATE_APPEAR.lifecycleState) {
                return true
            }
        }
        return false
    }

    override fun onBackPressed(container: IFlutterViewContainer) {
        assertCallOnMainThread()

        mContainLifecycleList[container]?.let {
            if (FlutterHybridPlugin.instance.isUseCanPop) {
                if (container.getContainerCanPop()) {
                    FlutterHybridPlugin.instance.getDataMessage().invokeMethod(BACK_BUTTON_PRESSED,
                            container.getContainerName(), container.getContainerParams(), it.containerId())
                } else {
                    container.destroyContainerView()
                }
            } else {
                FlutterHybridPlugin.instance.getDataMessage().invokeMethod(BACK_BUTTON_PRESSED,
                        container.getContainerName(), container.getContainerParams(), it.containerId())
            }
        }
    }

    override fun destroyContainer(name: String, uq: String) {
        assertCallOnMainThread()

        var done = false
        for (entry in mContainLifecycleList.entries) {
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

    override fun getCurrentLifecycleState(): IContainerLifecycle? {
        return mCurrentLifecycleState
    }

    override fun getLastContainerLifecycle(): IContainerLifecycle? {
        val values = mContainLifecycleList.values
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

        for (entry in mContainLifecycleList.entries) {
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

    private fun registerPlugins(registry: PluginRegistry) {
        try {
            val clz = Class.forName("io.flutter.plugins.GeneratedPluginRegistrant")
            val method = clz.getDeclaredMethod("registerWith", PluginRegistry::class.java)
            method.invoke(null, registry)
        } catch (t: Throwable) {

        }
    }
}