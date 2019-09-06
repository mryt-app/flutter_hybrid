package cn.missfresh.flutter_hybrid

import android.app.Activity
import android.os.Handler
import android.os.Looper
import android.text.TextUtils
import cn.missfresh.flutter_hybrid.interfaces.IContainerManager
import cn.missfresh.flutter_hybrid.interfaces.IContainerStatus
import cn.missfresh.flutter_hybrid.interfaces.IFlutterViewContainer
import cn.missfresh.flutter_hybrid.view.FHFlutterView
import io.flutter.plugin.common.PluginRegistry
import io.flutter.view.FlutterMain
import io.flutter.view.FlutterRunArguments
import java.lang.ref.WeakReference
import java.util.HashSet
import java.util.LinkedHashMap

/**
 * Created by sjl
 * on 2019-09-02
 */
class FlutterViewContainerManager : IContainerManager {

    private val mStatusList = LinkedHashMap<IFlutterViewContainer, IContainerStatus>()

    private var mCurrentStatus: IContainerStatus? = null

    private val mStatusRefs = HashSet<StatusRef>()

    private val mHandler = Handler(Looper.getMainLooper())

    override fun onContainerCreate(container: IFlutterViewContainer): PluginRegistry {
        assertCallOnMainThread()

        val record = ContainerStatus(container)
        if (mStatusList.put(container, record) != null) {
            Logger.e("container:" + container.getContainerName() + " already exists!")
            return PluginRegistryImpl(container.getCurrActivity(), container.getFHFlutterView())
        }

        mStatusRefs.add(StatusRef(record.uniqueId(), container))

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

        handleStatusToLifecycle(container)

        return PluginRegistryImpl(container.getCurrActivity(), container.getFHFlutterView())
    }

    override fun onContainerAppear(container: IFlutterViewContainer) {
        assertCallOnMainThread()

        handleStatusToLifecycle(container)
    }

    override fun onContainerDisappear(container: IFlutterViewContainer) {
        assertCallOnMainThread()

        handleStatusToLifecycle(container)

        if (!container.isFinishing()) {
            checkIfFlutterViewNeedStopLater()
        }
    }

    override fun onContainerDestroy(container: IFlutterViewContainer) {
        assertCallOnMainThread()

        mCurrentStatus?.let {
            if (it.getContainer() === container) {
                mCurrentStatus = null
            }
        }

        val record = mStatusList.remove(container)
        if (record == null) {
            Logger.e("container:" + container.getContainerName() + " not exists yet!")
            return
        }

        handleStatusToLifecycle(container)

        checkIfFlutterViewNeedStopLater()
    }

    private fun checkIfFlutterViewNeedStopLater() {
        mHandler.postDelayed({
            if (!hasContainerAppear()) {
                FlutterHybridPlugin.instance.viewProvider().stopFlutterView()
            }
        }, 100)
    }


    private fun handleStatusToLifecycle(container: IFlutterViewContainer) {
        mStatusList[container]?.apply {
            when (containerStatus()) {
                ContainerStatusEnum.STATE_UNKNOW.status -> onCreate()
                ContainerStatusEnum.STATE_CREATED.status -> onAppear()
                ContainerStatusEnum.STATE_APPEAR.status -> onDisappear()
                ContainerStatusEnum.STATE_DISAPPEAR.status -> onDestroy()
            }
            mCurrentStatus = this
        }
    }

    override fun hasContainerAppear(): Boolean {
        assertCallOnMainThread()

        for (entry in mStatusList.entries) {
            if (entry.value.containerStatus() === ContainerStatusEnum.STATE_APPEAR.status) {
                return true
            }
        }
        return false
    }

    override fun onBackPressed(container: IFlutterViewContainer) {
        assertCallOnMainThread()

        mStatusList[container]?.let {

            FlutterHybridPlugin.instance.dataMessage().invokeMethod("backButtonPressed",
                    container.getContainerName(), container.getContainerParams(), it.uniqueId())
        }
    }

    override fun destroyContainerRecord(name: String, uq: String) {
        assertCallOnMainThread()

        var done = false
        for (entry in mStatusList.entries) {
            if (TextUtils.equals(uq, entry.value.uniqueId())) {
                entry.key.destroyContainerView()
                done = true
                break
            }
        }

        if (!done) {
            Logger.e("destroyContainerRecord can not find name:$name uniqueId:$uq")
        }
    }

    override fun onContainerResult(container: IFlutterViewContainer, result: Map<*, *>) {
        mStatusList[container]?.let {
            it.onResult(result)
        }
    }

    override fun setContainerResult(uniqueId: String, result: Map<*, *>?) {
        //todo
    }

    override fun getCurrentTopRecord(): IContainerStatus? {
        return mCurrentStatus
    }

    override fun getLastRecord(): IContainerStatus? {
        val values = mStatusList.values
        if (!values.isEmpty()) {
            val array = ArrayList(values)
            return array[array.size - 1]
        }
        return null
    }

    override fun findContainerById(uniqueId: String): IFlutterViewContainer? {
        var container: IFlutterViewContainer? = null
        for (entry in mStatusList.entries) {
            if (TextUtils.equals(uniqueId, entry.value.uniqueId())) {
                container = entry.key
                break
            }
        }

        if (container == null) {
            for (ref in mStatusRefs) {
                if (TextUtils.equals(uniqueId, ref.uniqueId)) {
                    return ref.container.get()
                }
            }
        }

        return container
    }

    override fun onShownContainerChanged(old: String, now: String) {
        assertCallOnMainThread()
        Logger.d("onShownContainerChanged")
        var oldContainer: IFlutterViewContainer? = null
        var nowContainer: IFlutterViewContainer? = null

        for (entry in mStatusList.entries) {
            if (TextUtils.equals(old, entry.value.uniqueId())) {
                oldContainer = entry.key
            }

            if (TextUtils.equals(now, entry.value.uniqueId())) {
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

    class StatusRef internal constructor(val uniqueId: String, container: IFlutterViewContainer) {
        val container: WeakReference<IFlutterViewContainer>

        init {
            this.container = WeakReference(container)
        }
    }

    class PluginRegistryImpl internal constructor(activity: Activity, private val fhFlutterView: FHFlutterView) : PluginRegistry {

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