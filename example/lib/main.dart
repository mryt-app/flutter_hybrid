import 'package:flutter/material.dart';
import 'package:flutter_hybrid/flutter_hybrid.dart';
import 'package:flutter_hybrid_example/color_page.dart';
import 'package:flutter_hybrid_example/counter.dart';
import 'package:flutter_hybrid_example/flutter_page.dart';
import 'package:flutter_hybrid_example/flutter_fragment.dart';

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
      '/colorPage': (routeName, params, pageId) => ColorPage(color: Color(params['color']), pageId: pageId),
      '/flutterPage': (routeName, params, _) => FlutterPage(),
      'flutterFragment': (pageName, params, _) => FragmentRouteWidget(params),
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
