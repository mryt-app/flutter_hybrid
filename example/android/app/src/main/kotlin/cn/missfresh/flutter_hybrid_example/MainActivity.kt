package cn.missfresh.flutter_hybrid_example

import android.app.Application
import android.content.Context
import android.os.Bundle
import android.view.View
import cn.missfresh.flutter_hybrid.FlutterHybridPlugin
import cn.missfresh.flutter_hybrid.interfaces.IAppInfo
import cn.missfresh.flutter_hybrid_example.util.RouterUtil
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

            override fun isDebug(): Boolean {
                return true
            }

            override fun startActivity(context: Context, url: String, requestCode: Int): Boolean {
                return RouterUtil.openPageByUrl(context, url, requestCode)
            }
        })

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
        when (v?.id) {
            R.id.tv_open_native_activity -> RouterUtil.openPageByUrl(this, RouterUtil.NATIVE_ACTIVITY_URL)
            R.id.tv_open_flutter_activity -> RouterUtil.openPageByUrl(this, RouterUtil.FLUTTER_ACTIVITY_URL)
            R.id.tv_open_flutter_fragment -> RouterUtil.openPageByUrl(this, RouterUtil.FLUTTER_FRAGMENT_ACTIVITY_URL)
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        FlutterHybridPlugin.instance.viewProvider().destroy()
    }
}
