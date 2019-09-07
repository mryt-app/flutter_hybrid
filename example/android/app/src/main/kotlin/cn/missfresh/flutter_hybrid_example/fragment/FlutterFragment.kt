package cn.missfresh.flutter_hybrid_example.fragment

import android.os.Bundle
import cn.missfresh.flutter_hybrid.containers.FHFlutterFragment
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.HashMap

/**
 * Created by sjl
 * on 2019-09-01
 */
class FlutterFragment : FHFlutterFragment() {

    companion object {

        fun instance(tag: String): FlutterFragment {
            val fragment = FlutterFragment()
            fragment.setTabTag(tag)
            return fragment
        }
    }


    fun setTabTag(tag: String) {
        val args = Bundle()
        args.putString("tag", tag)
        arguments = args
    }

    override fun getContainerName(): String {
        return "flutterFragment"
        //return "/flutterPage"
    }

    override fun getContainerParams(): Map<String, Any> {
        val params = HashMap<String, String>()
        arguments?.let {
            params["tag"] = it.getString("tag")
        }
        return params
    }

    override fun destroyContainerView() {

    }

    override fun onRegisterPlugins(registry: PluginRegistry) {
        GeneratedPluginRegistrant.registerWith(registry)
    }

}