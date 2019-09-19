# 简介

Flutter混合开发框架，可以方便地在iOS、Android原生应用中集成Flutter页面，实现思路与FlutterBoost一样，但代码更清晰和规范。

与FlutterBoost一样，主要解决混合栈管理问题。类似于在Native中嵌入H5页面，将页面资源化，通过`routeName`来标识一个页面，方便兼容各种路由跳转方案。

在一款成熟的App中接入Flutter至少需要解决几个问题：

- 保证Flutter页面和原生页面用户体验一致
- 保证页面生命周期完整性，相关事件统计不受影响
- 资源占用和性能问题

想了解具体的实现思路和原理，可以看[如何实现Flutter混合开发框架 - FlutterBoost深度解析](https://www.yuque.com/ia8upe/lha6g7/aisx2z#2c913e87)。FlutterHybrid在实现思路上与FlutterBoost完全一致，但由于FlutterBoost代码比较烂（新版对代码做了比较大的重构，比之前好一些），同时为了深入理解Flutter，因此重新实现了一遍。

# 集成

## 环境要求

- flutter版本：^1.5.4

## 在Flutter项目中添加依赖

FlutterHybrid是一个Flutter Plugin，添加方式与其它Flutter库一样。

```yaml
flutter_hybrid: ^0.0.2
```

或者直接依赖github项目，由于pub的发布不一定及时，建议直接依赖github项目：

```yaml
flutter_hybrid:
  git: git@github.com:mryt-app/flutter_hybrid.git
  ref: 0.0.2
```

## Dart代码集成

注册页面构造器，启动FlutterHybrid，将`MaterialApp`的`builder`替换为`FlutterHybrid.transitionBuilder()`。

```dart
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    FlutterHybrid.sharedInstance.registerPageBuilders({
      '/counter': (routeName, params, pageId) => CounterPage(pageId: pageId),
      '/colorPage': (routeName, params, pageId) => ColorPage(
          color: Color(params != null ? params['color'] : Colors.green.value),
          pageId: pageId),
      '/flutterPage': (routeName, params, _) => FlutterPage(),
    });
    FlutterHybrid.sharedInstance.startRun();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: FlutterHybrid.transitionBuilder(),
      home: Container(),
    );
  }
}
```

## iOS集成

将`FlutterAppDelegate`作为`AppDelegate`的父类：

```objective-c
#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>

@interface AppDelegate : FlutterAppDelegate
@end
```

实现`FLHRouter`协议，并用相应的实例启动FlutterHybrid。

```objective-c
[FLHFlutterHybrid.sharedInstance startFlutterWithRouter:[Router sharedInstance]];
```

`FLHRouter`协议很简单，只有打开和关闭页面：

```objective-c
@protocol FLHRouter <NSObject>

- (void)openPage:(NSString *)route
          params:(nullable NSDictionary *)params
        animated:(BOOL)animated
      completion:(nullable void (^)(BOOL finished))completion;

- (void)closePage:(NSString *)pageId
           params:(nullable NSDictionary *)params
         animated:(BOOL)animated
       completion:(nullable void (^)(BOOL finished))completion;

@end
```

## Android集成

在`AndroidManifest.xml`文件中，将application替换为`io.flutter.app.FlutterApplication`。

```xml
<application
        android:name="io.flutter.app.FlutterApplication"
        android:icon="@mipmap/ic_launcher"
        android:label="flutter_hybrid_example">
```

`io.flutter.app.FlutterApplication`是一个`android.app.Application`的子类，在`onCreate`方法中调用了`FlutterMain.startInitialization(this)`，一般情况下直接使用它即可。如果需要附加功能，可以继承它，或者在自定义类中实现`FlutterApplication`的逻辑。

在`MainActivity`中初始化FlutterHybrid，`MainActivity`需要继承`FlutterActivity`：

```kotlin
class MainActivity : FlutterActivity(), View.OnClickListener {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Init FlutterHybrid
        FlutterHybridPlugin.instance.init(object : IAppInfo {

            override fun getApplication(): Application {
                return application
            }

            override fun startActivity(context: Context?, routeName: String, params: Map<*, *>?): Boolean {
                return RouterUtil.openPageByUrl(context ?: this@MainActivity, routeName, params)
            }

            override fun isDebug(): Boolean {
                // The return value depends on whether it is a Debug package.
                return true
            }
        })

        setContentView(R.layout.main_activity)
        initView()
        // Register Flutter plugins
        GeneratedPluginRegistrant.registerWith(this)
    }
}
```

# 基本用法

## Native页面打开Flutter页面

### 在iOS中打开Flutter页面

iOS目前提供了两个ViewController：

- FLHFlutterContainerViewController：`FlutterViewController`作为其`childViewController`，多个页面共用一个`FlutterViewController`，通过截屏的方式解决页面切换时的页面空白和内容过渡问题。对应于FlutterBoost的0.0.42版本。
- FLHFlutterHybridViewController：`FlutterViewController`的子类，每个页面即一个`FlutterViewController`。对应于FlutterBoost的最新版本。

**注意：由于`FlutterViewController`生命周期会改变Flutter的状态，而两种Controller的生命周期逻辑不同，因此两种Controller在一个App中不能混合使用。**

```objective-c
FLHFlutterContainerViewController *flutterVC = [[FLHFlutterContainerViewController alloc] initWithRoute:route params:params];
[self.navigationController pushViewController:flutterVC animated:animated];
```

或者：

```objective-c
FLHFlutterHybridViewController *flutterVC = [[FLHFlutterHybridViewController alloc] initWithRoute:route params:params];
[self.navigationController pushViewController:flutterVC animated:animated];
```

`route`即Dart中注册的页面名称，`params`是要传递的页面参数。

### 在Android中打开Flutter页面

目前Android提供了Activity和Fragment两种使用方式。

```kotlin
context?.let {
            val intent = Intent(context, FHFlutterActivity::class.java)
            intent.putExtra(Messager.ROUTE_NAME, routeName)
            if (params != null && params.isNotEmpty()) {
                intent.putExtra(Messager.PARAMS, params as Serializable)
            }
            it.startActivity(intent)
        }
```

或者：

```kotlin
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
    
    override fun onBackPressed() {
        FlutterHybridPlugin.instance.getContainerManager().onBackPressed(mFragment as IFlutterViewContainer)
    }
}
```

### 在Dart中打开或关闭页面

所有的路由管理都有Native端负责，Dart端打开、关闭页面都是通过Channel调用Native端功能。

```dart
// 打开页面
FlutterHybrid.sharedInstance.router.openPage('/counter',
                      params: {
                        ShowPageTYpe.PAGE_TYPE: ShowPageTYpe.expectedPageType
                      });

// 关闭页面
FlutterHybrid.sharedInstance.router.closePage(pageId, params);

// 可以直接调用Navigator.pop关闭页面
Navigator.pop(context);
```

在Dart端，所有的页面都在`Navigator`中，因此可以直接调用`Navigator.pop`关闭页面，在`Navigator`子类中对`pop`做了处理，可以自动处理Flutter页面的pop和原生页面的关闭。

