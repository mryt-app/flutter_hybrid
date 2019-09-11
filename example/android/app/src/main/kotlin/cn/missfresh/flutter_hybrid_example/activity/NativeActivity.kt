package cn.missfresh.flutter_hybrid_example.activity

import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.view.View
import cn.missfresh.flutter_hybrid_example.R
import cn.missfresh.flutter_hybrid_example.util.RouterUtil
import cn.missfresh.flutter_hybrid_example.util.RouterUtil.ACTIVITY_TYPE
import cn.missfresh.flutter_hybrid_example.util.RouterUtil.FRAGMENT_TYPE
import cn.missfresh.flutter_hybrid_example.util.RouterUtil.NATIVE_TYPE
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
        // RouterUtil.PAGE_TYPE 依据业务是否需要赋值，也可将上个页面参数传过来，
        // 正常NativeActivity页面不在包含 Flutter页面，无Flutter页面可不使用上个页面参数
        when (v?.id) {
            R.id.tv_open_native_activity -> {
                params[RouterUtil.PAGE_TYPE] = NATIVE_TYPE
                RouterUtil.openPageByUrl(this, "/counter", params)
            }
            R.id.tv_open_flutter_activity -> {
                params[RouterUtil.PAGE_TYPE] = ACTIVITY_TYPE
                params["color"] = 0xFFFFFF00
                RouterUtil.openPageByUrl(this, "/colorPage", params)
            }
            R.id.tv_open_flutter_fragment -> {
                params[RouterUtil.PAGE_TYPE] = FRAGMENT_TYPE
                RouterUtil.openPageByUrl(this, "/counter", params)
            }
        }
    }


}