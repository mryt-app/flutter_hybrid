package cn.missfresh.flutter_hybrid.interfaces

/**
 * Created by sjl
 * on 2019-09-02
 */
interface IContainerLifecycle {

    fun onCreate()

    fun onAppear()

    fun onDisappear()

    fun onDestroy()

    fun containerId(): String

    fun getContainer(): IFlutterViewContainer

    fun getContainerLifecycleState(): Int
}