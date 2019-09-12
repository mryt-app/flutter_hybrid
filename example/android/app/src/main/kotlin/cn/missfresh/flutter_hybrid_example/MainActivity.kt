package cn.missfresh.flutter_hybrid_example

import android.app.Application
import android.content.Context
import android.os.Bundle
import android.view.View
import cn.missfresh.flutter_hybrid.FlutterHybridPlugin
import cn.missfresh.flutter_hybrid.interfaces.IAppInfo
import cn.missfresh.flutter_hybrid_example.util.RouterUtil
import cn.missfresh.flutter_hybrid_example.util.RouterUtil.NATIVE_TYPE
import cn.missfresh.flutter_hybrid_example.util.RouterUtil.PAGE_TYPE
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import kotlinx.android.synthetic.main.main_activity.*

class MainActivity : FlutterActivity(), View.OnClickListener {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        FlutterHybridPlugin.instance.init(object : IAppInfo {

            override fun getApplication(): Application {
                return application
            }

            override fun startActivity(context: Context?, routeName: String, params: Map<*, *>?): Boolean {
                return RouterUtil.openPageByUrl(this@MainActivity, routeName, params)
            }

            override fun isDebug(): Boolean {
                return true
            }
        })

        FlutterHybridPlugin.instance.isUseCanPop = true

        setContentView(R.layout.main_activity)
        initView()
        GeneratedPluginRegistrant.registerWith(this)
    }

    private fun initView() {
        tv_title.text = "MainActivity"
        tv_open_native_activity.setOnClickListener(this)
        tv_open_flutter_activity.setOnClickListener(this)
        tv_open_flutter_fragment.setOnClickListener(this)
    }

    override fun onClick(v: View?) {
        var params = hashMapOf<String, Any>()
        when (v?.id) {
            R.id.tv_open_native_activity -> {
                params[PAGE_TYPE] = NATIVE_TYPE
                RouterUtil.openPageByUrl(this, "", params)
            }
            R.id.tv_open_flutter_activity -> {
                RouterUtil.openPageByUrl(this, "/counter", params)
            }
            R.id.tv_open_flutter_fragment -> {
                params["color"] = 0xffff0000
                RouterUtil.openPageByUrl(this, "/colorPage", params)
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        FlutterHybridPlugin.instance.getViewProvider().destroy()
    }
}
