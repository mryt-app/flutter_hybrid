package cn.missfresh.flutter_hybrid

/**
 * Created by sjl
 * on 2019-09-02
 */
enum class ContainerLifecycleEnum(val status: Int) {
    STATE_UN_KNOW(0),
    STATE_CREATED(1),
    STATE_APPEAR(2),
    STATE_DISAPPEAR(3),
    STATE_DESTROYED(4)
}