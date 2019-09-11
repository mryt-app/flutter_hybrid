package cn.missfresh.flutter_hybrid_example.activity

import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.view.Window
import cn.missfresh.flutter_hybrid.FlutterHybridPlugin
import cn.missfresh.flutter_hybrid_example.R
import cn.missfresh.flutter_hybrid_example.fragment.FlutterFragment

/**
 * Created by sjl
 * on 2019-09-01
 */
class FlutterFragmentActivity : AppCompatActivity() {

    private var mFragment: FlutterFragment? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        supportRequestWindowFeature(Window.FEATURE_NO_TITLE)
        super.onCreate(savedInstanceState)

        setContentView(R.layout.flutter_fragment)

        mFragment = FlutterFragment.instance("hello world")

        mFragment?.let {
            supportFragmentManager
                    .beginTransaction()
                    .replace(R.id.fragment_stub, mFragment!!)
                    .commit()
        }
    }


    override fun onBackPressed() {
        var containerStatus = FlutterHybridPlugin
                .instance.containerManager().getCurrentStatus()

        if (containerStatus == null) {
            containerStatus = FlutterHybridPlugin.instance
                    .containerManager().getLastContainerStatus()
        }
        containerStatus?.getContainer()?.let {
            FlutterHybridPlugin.instance.containerManager().onBackPressed(it)
        }
    }
}