package cn.missfresh.flutter_hybrid.containers

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Color
import android.os.Handler
import android.os.Looper
import android.os.Message
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.ImageView
import cn.missfresh.flutter_hybrid.FlutterHybridPlugin
import cn.missfresh.flutter_hybrid.Logger
import cn.missfresh.flutter_hybrid.view.FHFlutterView

/**
 * Created by sjl
 * on 2019-09-02
 */
abstract class FlutterViewStub(context: Context) : FrameLayout(context) {

    private var mBitmap: Bitmap? = null
    private lateinit var mSnapshot: ImageView
    private var mStub: FrameLayout = FrameLayout(context)
    private var mCover: View? = null

    private val mHandler: Handler = ViewStatusHandler(Looper.getMainLooper())

    protected abstract val getFHFlutterView: FHFlutterView

    init {
        mStub.setBackgroundColor(Color.WHITE)
        addView(mStub, LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT))

        mSnapshot = ImageView(context)
        mSnapshot.scaleType = ImageView.ScaleType.FIT_CENTER
        mSnapshot.layoutParams = LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT)
        mCover = initFlutterCoverView()
        addView(mCover, LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT))
    }

    fun onContainerAppear() {
        Logger.d("onContainerAppear")

        if (FlutterHybridPlugin.instance.isFirstLoad) {
            FlutterHybridPlugin.instance.isFirstLoad = false
            mHandler.postDelayed({
                refresh()
                removeCover()
            }, 1000)
        } else {
            refresh()
            removeCover()
        }
    }

    private fun refresh() {
        if (mSnapshot.parent === this@FlutterViewStub) {
            removeView(mSnapshot)
            mSnapshot.setImageBitmap(null)
            mBitmap?.let {
                if (!it.isRecycled) {
                    it.recycle()
                    mBitmap = null
                }
            }
        }
        getFHFlutterView.requestFocus()
        getFHFlutterView.invalidate()
    }

    private fun removeCover() {
        mCover?.let {
            removeView(it)
        }
    }

    fun onContainerDisappear() {

    }

    fun snapshot() {
        if (mStub.childCount <= 0 || mSnapshot.parent != null)
            return

        val fhFlutterView = mStub.getChildAt(0) as FHFlutterView
        mBitmap = fhFlutterView?.bitmap
        mBitmap?.let {
            if (!it.isRecycled) {
                mSnapshot.setImageBitmap(it)
                addView(mSnapshot)
            }
        }
    }

    protected fun initFlutterCoverView(): View {
        val initCover = View(context)
        initCover.setBackgroundColor(Color.WHITE)
        return initCover
    }

    fun attachFlutterView(flutterView: FHFlutterView) {
        if (flutterView.parent !== mStub) {
            mHandler.removeMessages(ViewStatusHandler.MSG_DETACH)

            Logger.d("attachFlutterView")

            flutterView.parent?.let {
                (it as ViewGroup).removeView(flutterView)
            }

            mStub.addView(flutterView, LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT))
        }
    }


    fun detachFlutterView() {
        if (mStub?.childCount <= 0) {
            return
        }

        val fhFlutterView = mStub.getChildAt(0) as FHFlutterView

        if (mSnapshot.parent == null) {
            mBitmap = fhFlutterView?.bitmap
            mBitmap?.let {
                if (!it.isRecycled) {
                    mSnapshot.setImageBitmap(it)
                    Logger.d("snapshot view")
                    addView(mSnapshot)
                }
            }
        }

        val msg = Message()
        msg.what = ViewStatusHandler.MSG_DETACH
        msg.obj = Runnable {
            fhFlutterView?.parent?.let {
                if (it == mStub) {
                    Logger.d("detachFlutterView")
                    mStub.removeView(fhFlutterView)
                }
            }
        }
        mHandler.sendMessageDelayed(msg, 18)
    }

    fun removeViews() {
        removeAllViews()
        mSnapshot?.setImageBitmap(null)
        recycleBitmap()
    }

    private fun recycleBitmap() {
        mBitmap?.let {
            if (!it.isRecycled) {
                it.recycle()
                mBitmap = null
            }
        }
    }

    class ViewStatusHandler internal constructor(looper: Looper) : Handler(looper) {

        companion object {
            const val MSG_DETACH = 180081
        }

        override fun handleMessage(msg: Message) {
            super.handleMessage(msg)
            if (msg.obj is Runnable) {
                (msg.obj as Runnable).run()
            }
        }
    }
}