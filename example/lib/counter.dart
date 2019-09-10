import 'package:flutter/material.dart';
import 'package:flutter_hybrid/flutter_hybrid.dart';
import 'package:flutter_hybrid_example/color_page.dart';

class CounterPage extends StatefulWidget {
  final String pageId;
  CounterPage({Key key, this.pageId}) : super(key: key);

  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have tapped the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            FlatButton(
                child: Text(
                  'Open page in native',
                  style: TextStyle(
                    color: Colors.black87, 
                    fontSize: 20
                  ),
                ),
                onPressed: () {
                  FlutterHybrid.sharedInstance.router.openPage('/colorPage', params: { 'color': 0xFFFFFF00 });
                },
              ),
              FlatButton(
                child: Text(
                  'Open page in Flutter',
                  style: TextStyle(
                    color: Colors.black87, 
                    fontSize: 20
                  ),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ColorPage(color: Colors.green)));
                },
              ),
              FlatButton(
                child: Text(
                  'Go Back',
                  style: TextStyle(
                    color: Colors.black87, 
                    fontSize: 20
                  ),
                ),
                onPressed: () {
                  if (widget.pageId != null) {
                    FlutterHybrid.sharedInstance.router.closePage(widget.pageId);
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
