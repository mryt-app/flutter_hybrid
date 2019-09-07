package cn.missfresh.flutter_hybrid_example

import io.flutter.app.FlutterApplication

/**
 * Created by sjl
 * on 2019-09-04
 */
class MyApplication : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()

//        FlutterHybridPlugin.instance.init(object : IAppInfo {
//
//            override fun getApplication(): Application {
//                return this@MyApplication
//            }
//
//            override fun isDebug(): Boolean {
//                return true
//            }
//
//            override fun startActivity(context: Context, url: String, requestCode: Int): Boolean {
//                return RouterUtil.openPageByUrl(context, url, requestCode)
//            }
//        })
    }
}