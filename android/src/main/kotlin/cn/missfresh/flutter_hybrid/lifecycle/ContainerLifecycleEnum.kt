package cn.missfresh.flutter_hybrid.lifecycle

/**
 * Created by sjl
 * on 2019-09-02
 */
enum class ContainerLifecycleEnum(val lifecycleState: Int) {
    STATE_UN_KNOW(0),
    STATE_CREATED(1), // onCreate
    STATE_APPEAR(2), // onAppear
    STATE_DISAPPEAR(3), // onDisappear
    STATE_DESTROYED(4) // onDestroy
}