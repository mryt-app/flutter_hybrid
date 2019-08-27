import 'package:flutter/material.dart';
import 'package:flutter_hybrid/flutter_hybrid.dart';
import 'package:flutter_hybrid_example/color_page.dart';
import 'package:flutter_hybrid_example/counter.dart';

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
      '/counter': (routeName, params, _) => CounterPage(),
      '/colorPage': (routeName, params, _) => ColorPage(color: Color(params['color'])),
    });
    FlutterHybrid.sharedInstance
      .pageCoordinator.showStartPageIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: FlutterHybrid.transitionBuilder(),
      home: Container(),
    );
  }
}
