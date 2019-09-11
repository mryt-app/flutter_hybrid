import 'package:flutter/material.dart';
import 'package:flutter_hybrid/flutter_hybrid.dart';
import 'package:flutter_hybrid_example/color_page.dart';
import 'package:flutter_hybrid_example/counter.dart';
import 'package:flutter_hybrid_example/flutter_page.dart';
import 'package:flutter_hybrid/support/logger.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    FlutterHybrid.sharedInstance.registerPageBuilders({
      '/counter': (routeName, params, pageId) => CounterPage(pageId: pageId),
      '/colorPage': (routeName, params, pageId) =>
          ColorPage(color: Color(params != null ? params['color'] : Colors.green.value), pageId: pageId),
      '/flutterPage': (routeName, params, _) => FlutterPage(),
    });
    FlutterHybrid.sharedInstance.startRun();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: FlutterHybrid.transitionBuilder(),
      home: Container(),
    );
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    Logger.error("didChangeAppLifecycleState state :$state");
  }


}
