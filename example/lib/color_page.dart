import 'package:flutter/material.dart';
import 'package:flutter_hybrid/flutter_hybrid.dart';
import 'package:flutter_hybrid_example/counter.dart';

class ColorPage extends StatelessWidget {
  final Color color;
  final String pageId;

  ColorPage({Key key, this.color, this.pageId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: color,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text(
                  'Open page in native',
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 20
                  ),
                ),
                onPressed: () {
                  FlutterHybrid.sharedInstance.router.openPage('/counter');
                },
              ),
              FlatButton(
                child: Text(
                  'Open page in Flutter',
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 20
                  ),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => CounterPage()));
                },
              ),
              FlatButton(
                child: Text(
                  'Go Back',
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: 20
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
