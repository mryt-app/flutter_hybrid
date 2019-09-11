package cn.missfresh.flutter_hybrid_example.activity

import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.view.View
import cn.missfresh.flutter_hybrid_example.R
import cn.missfresh.flutter_hybrid_example.util.RouterUtil
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
        var params = hashMapOf<String, Any>()
        when (v?.id) {
            R.id.tv_open_native_activity -> {
                params[RouterUtil.PAGE_TYPE] = 2
                RouterUtil.openPageByUrl(this, "/counter", params)
            }
            R.id.tv_open_flutter_activity -> {
                params[RouterUtil.PAGE_TYPE] = 1
                params["color"] = 0xFFFFFF00
                RouterUtil.openPageByUrl(this, "/colorPage", params)
            }
            R.id.tv_open_flutter_fragment -> {
                params[RouterUtil.PAGE_TYPE] = 0
                RouterUtil.openPageByUrl(this, "/counter", params)
            }
        }
    }


}