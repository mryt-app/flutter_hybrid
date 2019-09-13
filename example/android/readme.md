# Integration with Android code.

## First of all，initialization。

 * Add \<application Android:name="io.flutter.app.FlutterApplication"> in AndroidManifest.xml，
 
 OR,
 
  create a new XXXApplicition to extends io.flutter.app.FlutterApplication, then add \<application Android:name=".XXXApplicition"> in AndroidManifest.xml

 * Init FlutterHybrid in MainActivity, MainActivity needs to  extends FlutterActivity。
 
 
Examples are as follows：



    class MainActivity : FlutterActivity(), View.OnClickListener {

      override fun onCreate(savedInstanceState: Bundle?) {
          super.onCreate(savedInstanceState)
          setContentView(R.layout.main_activity)

          FlutterHybridPlugin.instance.init(object : IAppInfo {

            override fun getApplication(): Application {
                return application
            }

            override fun startActivity(context: Context?, routeName: String, params: Map<*, *>?): Boolean {
                return RouterUtil.openPageByUrl(context ?: this@MainActivity, routeName, params)
            }

            override fun isDebug(): Boolean {
                // The return value depends on whether it is a Debug package.
                return false
            }
        })

        FlutterHybridPlugin.instance.isUseCanPop = false

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
          // Must be called
          FlutterHybridPlugin.instance.getViewProvider().destroy()
      }
    }
    
    /**
     * RouterUtil is an example of specific route-hopping encapsulation. 
     * It can be modified according to its own business conditions.
     */ 
    object RouterUtil {
	
	    const val PAGE_TYPE = "page_type"
	    const val FRAGMENT_TYPE = 0
	    const val ACTIVITY_TYPE = 1
	    const val NATIVE_TYPE = 2
	
	    fun openPageByUrl(context: Context, routeName: String, params: Map<*, *>?): Boolean {
	        try {
	            if (context == null) {
	                return false
	            }
	
	            var type = FRAGMENT_TYPE
	            /**
	             * PAGE_TYPE can not be passed in the Dart code, here
	             * unified processing,simplify the use of parameters
	             */
	            if (params != null && params.isNotEmpty()) {
	                if (params.containsKey(PAGE_TYPE)) {
	                    type = params[PAGE_TYPE] as Int
	                }
	            }
	
	            when (type) {
	                FRAGMENT_TYPE -> {
	                    val intent = Intent(context, FlutterFragmentActivity::class.java)
	                    startActivity(context, intent, routeName, params)
	                }
	                ACTIVITY_TYPE -> {
	                    val intent = Intent(context, FHFlutterActivity::class.java)
	                    startActivity(context, intent, routeName, params)
	                }
	                NATIVE_TYPE -> {
	                    /**
	                     * Open the native page, use the url and params, the business party
	                     * needs to call the existing routing processing method according to
	                     * its own routing rules to open the business party's own realized or
	                     * newly created page.
	                     */
	                    val intent = Intent(context, NativeActivity::class.java)
	                    startActivity(context, intent, routeName, params)
	                }
	            }
	            return true
	        } catch (t: Throwable) {
	            return false
	        }
	    }
	
	    private fun startActivity(context: Context, intent: Intent, routeName: String, params: Map<*, *>?) {
	        context?.let {
	            val intent = Intent(context, FHFlutterActivity::class.java)
	
	            intent.putExtra(Messager.ROUTE_NAME, routeName)
	            if (params != null && params.isNotEmpty()) {
	                intent.putExtra(Messager.PARAMS, params as Serializable)
	            }
	            it.startActivity(intent)
	        }
	    }
	}

    
## Second, load the page

You can choose to load the Flutter page in the Activity, or you can load the Flutter page in the Fragment.

### Load Flutter page example in Activity。

Add \<activity android:name="cn.missfresh.flutter_hybrid.containers.FHFlutterActivity"/> to AndroidManifest.xml。 Then you can load a Flutter page in the Activity by using the code below.


    val intent = Intent(context, FHFlutterActivity::class.java)
    startActivity(context, intent, routeName, params)

    //Please refer to the startActivity method of RouterUtil in Demo.
    private fun startActivity(context: Context, intent: Intent, 
             routeName: String, params: Map<*, *>?) {
        context?.let {
            intent.putExtra(Messager.ROUTE_NAME, routeName)
            if (params != null && params.isNotEmpty()) {
                intent.putExtra(Messager.PARAMS, params as Serializable)
            }
            it.startActivity(intent)
        }
    }
    
    
Similar can be inherited from FHFlutterActivity with XXXActivity, and then used after declaring the XXXActivity in AndroidManifest.xml.

### Load Flutter page example Fragment。
   
先创建XXXActivity继承自AppCompatActivity或者Activity，然后在AndroidManifest.xml中声明该XXXActivity。

	class FlutterFragmentActivity : AppCompatActivity() {
	
	    private lateinit var mFragment: FHFlutterFragment
	
	    override fun onCreate(savedInstanceState: Bundle?) {
	        super.onCreate(savedInstanceState)
	        setContentView(R.layout.flutter_fragment)
	
	        mFragment = FHFlutterFragment.instance()
	
	        supportFragmentManager
	                .beginTransaction()
	                .replace(R.id.fragment_container, mFragment)
	                .commit()
	    }
	    
	    //The onBackPressed method must be overridden, otherwise the back key is abnormal in this case.
	    override fun onBackPressed() {
	        FlutterHybridPlugin.instance.getContainerManager().onBackPressed(mFragment as IFlutterViewContainer)
	    }
	}
	
	// flutter_fragment.xml
	<?xml version="1.0" encoding="utf-8"?>
		<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
		    android:layout_width="match_parent"
		    android:layout_height="match_parent"
		    android:background="@android:color/white"
		    android:orientation="vertical">
		
		    <FrameLayout
		        android:id="@+id/fragment_container"
		        android:layout_width="match_parent"
		        android:layout_height="0dp"
		        android:layout_weight="1" />
		
		</LinearLayout>
		
For a complete example, please refer to the Android demo.




