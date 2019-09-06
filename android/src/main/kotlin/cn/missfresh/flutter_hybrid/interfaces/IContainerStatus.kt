package cn.missfresh.flutter_hybrid.interfaces

/**
 * Created by sjl
 * on 2019-09-02
 */
interface IContainerStatus {

    fun onCreate()

    fun onAppear()

    fun onDisappear()

    fun onDestroy()

    fun getContainer(): IFlutterViewContainer

    fun containerStatus(): Int

    fun uniqueId(): String

    fun onResult(Result: Map<*, *>)
}