package cn.missfresh.flutter_hybrid.interfaces

import io.flutter.plugin.common.PluginRegistry

/**
 * Created by sjl
 * on 2019-09-02
 */
interface IContainerManager {

    fun onContainerCreate(container: IFlutterViewContainer): PluginRegistry

    fun onContainerAppear(container: IFlutterViewContainer)

    fun onContainerDisappear(container: IFlutterViewContainer)

    fun onContainerDestroy(container: IFlutterViewContainer)

    fun onBackPressed(container: IFlutterViewContainer)

    fun destroyContainerRecord(name: String, uq: String)

    fun onContainerResult(container: IFlutterViewContainer, result: Map<*, *>)

    fun setContainerResult(uniqueId: String, result: Map<*, *>?)

    fun getCurrentTopRecord(): IContainerStatus?

    fun getLastRecord(): IContainerStatus?

    fun findContainerById(uniqueId: String): IFlutterViewContainer?

    fun onShownContainerChanged(old: String, now: String)

    fun hasContainerAppear(): Boolean

}