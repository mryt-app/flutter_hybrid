package cn.missfresh.flutter_hybrid_example.activity

import cn.missfresh.flutter_hybrid.containers.FHFlutterActivity
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.GeneratedPluginRegistrant

/**
 * Created by sjl
 * on 2019-09-01
 */
class FlutterActivity : FHFlutterActivity() {

    override fun onRegisterPlugins(registry: PluginRegistry) {
        GeneratedPluginRegistrant.registerWith(registry)
    }
}