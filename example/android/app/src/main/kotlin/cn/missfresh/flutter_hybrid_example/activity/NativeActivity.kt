package cn.missfresh.flutter_hybrid_example.activity

import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.view.View
import cn.missfresh.flutter_hybrid_example.R
import cn.missfresh.flutter_hybrid_example.util.RouterUtil
import io.flutter.plugins.GeneratedPluginRegistrant
import kotlinx.android.synthetic.main.main_activity.*

/**
 * Created by sjl
 * on 2019-09-01
 */
class NativeActivity : AppCompatActivity(), View.OnClickListener {


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.main_activity)
        initView()

    }

    private fun initView() {
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
}