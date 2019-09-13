package cn.missfresh.flutter_hybrid.interfaces

import io.flutter.plugin.common.PluginRegistry

/**
 * Created by sjl
 * on 2019-09-02
 */
interface IContainerManager {

    /**
     * Called when activity or fragment is onCreate.
     */
    fun onContainerCreate(container: IFlutterViewContainer): PluginRegistry

    /**
     * Called when activity is onPostResume or fragment is onResume.
     */
    fun onContainerAppear(container: IFlutterViewContainer)

    /**
     * Called when activity or fragment is onPause.
     */
    fun onContainerDisappear(container: IFlutterViewContainer)

    /**
     * Called when activity or fragment is onDestroy.
     */
    fun onContainerDestroy(container: IFlutterViewContainer)

    /**
     * Called when the activity has detected the user's press of the back key.
     * @see android.app.Activity.onBackPressed
     */
    fun onBackPressed(container: IFlutterViewContainer)

    /**
     * Called when activity or fragment is closed.
     */
    fun destroyContainer(name: String, containerId: String)

    /**
     * Return the lifecycle state of the current container.
     */
    fun getCurrentLifecycleState(): IContainerLifecycle?

    /**
     * Return the lifecycle state of the last container.
     */
    fun getLastContainerLifecycle(): IContainerLifecycle?

    /**
     * Called when the page display status changes.
     */
    fun onShownContainerChanged(old: String, now: String)

    /**
     * Return whether the current container's lifecycle state is ContainerLifecycleEnum.STATE_APPEAR.
     */
    fun hasContainerAppear(): Boolean
}