<p align="center">
  <a href="README_CN.md">中文文档</a>
</p>

# Introduction

A flutter plugin for hybrid app, helps you integrate Flutter pages into iOS or Android app, influenced by [flutter_boost](https://github.com/alibaba/flutter_boost).

The plugin's core role is hybrid page stack management, syncs lifecycles of native pages with flutter pages. Like H5 in app, all hybrid pages are identified by URI, compatible with various route solutions.

As a tool for hybrid page stack management, it must:

- ensures consistent user experience of hybrid pages, it should be same as native pages.
- ensures integrity of page's lifecycle,  doesn't break page lifecycle related event tracks.
- memory usage, performance, stability...

# Integration

## Requirements

- flutter ^1.5.4

## Add dependency to Flutter Module

`flutter_hybrid` is a normal Flutter plugin:

```yaml
flutter_hybrid: ^0.0.2
```

Or uses the github directly:

```yaml
flutter_hybrid:
  git: git@github.com:mryt-app/flutter_hybrid.git
  ref: 0.0.2
```

## Integration in Dart

At first, register page builders, and replaces the `builder` of `MaterialApp` with `FlutterHybrid.transitionBuilder()`, then runs the `flutter_hybrid`.  

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

## Integration in iOS host app

First, your `AppDelegate` should inherites from `FlutterAppDelegate`, as normal Flutter app.

```objective-c
#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>

@interface AppDelegate : FlutterAppDelegate
@end
```

Then, creates a router class, which should implements `FLHRouter`,  `flutter_hybrid` will asks it to deal with routing. Uses it to start running:

```objective-c
[FLHFlutterHybrid.sharedInstance startFlutterWithRouter:[Router sharedInstance]];
```

`FLHRouter` is very simple, open and close page:

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

## Integration in Android host app

Uses `io.flutter.app.FlutterApplication` as your application:

```xml
<application
        android:name="io.flutter.app.FlutterApplication"
        android:icon="@mipmap/ic_launcher"
        android:label="flutter_hybrid_example">
```

`io.flutter.app.FlutterApplication` is an `android.app.Application` that calls `FlutterMain.startInitialization(this);` in its `onCreate` method. In most cases you can leave this as-is, but if you want to provide additional functionalities, it is fine to subclass or reimplement FlutterApplication.

Init `flutter_hybrid` in `MainActivity`, it shoulds inherite from `FlutterActivity`:

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

# Basic usage

## Open a Flutter page in iOS native page

There are two ViewControllers:

- FLHFlutterContainerViewController: Add sole  `FlutterViewController` as its `childViewController`, snapshots to avoid empty page on transition.
- FLHFlutterHybridViewController: Subclass of  `FlutterViewController`.

> Warning: Two types of viewController couldn't be used in an app, you should always use one type.

```objective-c
FLHFlutterContainerViewController *flutterVC = [[FLHFlutterContainerViewController alloc] initWithRoute:route params:params];
[self.navigationController pushViewController:flutterVC animated:animated];
```

Or:

```objective-c
FLHFlutterHybridViewController *flutterVC = [[FLHFlutterHybridViewController alloc] initWithRoute:route params:params];
[self.navigationController pushViewController:flutterVC animated:animated];
```

`route` is the page name registered in Dart, `params` is parameters needed to create flutter page.

## Open a Flutter page in Android native page

Activity:

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

Fragment：

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

## Open or close hybrid page in Dart

```dart
// Open page
FlutterHybrid.sharedInstance.router.openPage('/counter',
                      params: {
                        ShowPageTYpe.PAGE_TYPE: ShowPageTYpe.expectedPageType
                      });

// Close page
FlutterHybrid.sharedInstance.router.closePage(pageId, params);

// You can call Navigator.pop to close flutter or hybrid page directly.
Navigator.pop(context);
```

All hybrid flutter pages are managed by custom `Navigator`, it pops Flutter route or closes page by calling native.