package cn.missfresh.flutter_hybrid.interfaces

/**
 * Created by sjl
 * on 2019-09-02
 */
interface IContainerLifecycle {

    /**
     * Called when the onContainerCreate of the FlutterViewContainerManager is called
     */
    fun onCreate()

    /**
     * Called when the onContainerAppear of the FlutterViewContainerManager is called
     */
    fun onAppear()

    /**
     * Called when the onContainerDisappear of the FlutterViewContainerManager is called
     */
    fun onDisappear()

    /**
     * Called when the onContainerDestroy of the FlutterViewContainerManager is called
     */
    fun onDestroy()

    /**
     * Return container's containId
     */
    fun containerId(): String

    /**
     * Return the IFlutterViewContainer
     */
    fun getContainer(): IFlutterViewContainer

    /**
     * Return the current lifecycle state of the container
     */
    fun getContainerLifecycleState(): Int
}