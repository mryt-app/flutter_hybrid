import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hybrid/flutter_hybrid.dart';
import 'package:flutter_hybrid_example/page_type.dart';

class FlutterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FlutterPageState();
}

class FlutterPageState extends State<FlutterPage> {
  final Random random = Random();

  void _openCounterPage() {
    FlutterHybrid.sharedInstance.router.openPage('/counter',
        params: {ShowPageTYpe.PAGE_TYPE: ShowPageTYpe.expectedPageType});
  }

  void _openColorPage() {
    int startColor = 0xFF000000;
    int endColor = 0xFFFFFFFF;
    int randomColor = startColor + random.nextInt(endColor - startColor);

    FlutterHybrid.sharedInstance.router.openPage('/colorPage', params: {
      'color': randomColor,
      ShowPageTYpe.PAGE_TYPE: ShowPageTYpe.expectedPageType
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text(
                'Counter',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                ),
              ),
              onPressed: _openCounterPage,
            ),
            RaisedButton(
              child: Text(
                'Color Page',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                ),
              ),
              onPressed: _openColorPage,
            ),
          ],
        ),
      ),
    );
  }
}
