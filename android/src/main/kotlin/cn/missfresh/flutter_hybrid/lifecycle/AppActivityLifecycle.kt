package cn.missfresh.flutter_hybrid.lifecycle

import android.app.Activity
import android.app.Application
import android.os.Bundle
import cn.missfresh.flutter_hybrid.FlutterHybridPlugin
import java.lang.ref.WeakReference

/**
 * Created by sjl
 * on 2019-09-12
 */
class AppActivityLifecycle : Application.ActivityLifecycleCallbacks {

    override fun onActivityCreated(activity: Activity?, savedInstanceState: Bundle?) {

    }

    override fun onActivityStarted(activity: Activity?) {
        activity?.let {
            FlutterHybridPlugin.instance.currentActivityWeek = WeakReference(it)
        }
    }

    override fun onActivityResumed(activity: Activity?) {
        activity?.let {
            FlutterHybridPlugin.instance.currentActivityWeek = WeakReference(it)
        }
    }

    override fun onActivityPaused(activity: Activity?) {

    }

    override fun onActivityStopped(activity: Activity?) {
        activity?.let {
            if (FlutterHybridPlugin.instance.getCurrentActivity() == it) {
                FlutterHybridPlugin.instance.currentActivityWeek?.clear()
                FlutterHybridPlugin.instance.currentActivityWeek = null
            }
        }
    }

    override fun onActivityDestroyed(activity: Activity?) {
        activity?.let {
            if (FlutterHybridPlugin.instance.getCurrentActivity() == it) {
                FlutterHybridPlugin.instance.currentActivityWeek?.clear()
                FlutterHybridPlugin.instance.currentActivityWeek = null
            }
        }
    }

    override fun onActivitySaveInstanceState(activity: Activity?, outState: Bundle?) {

    }
}