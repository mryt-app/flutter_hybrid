import 'package:flutter/material.dart';
import 'package:flutter_hybrid/flutter_hybrid.dart';
import 'package:flutter_hybrid/support/logger.dart';
import 'package:flutter_hybrid_example/color_page.dart';
import 'package:flutter_hybrid_example/page_type.dart';

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
                style: TextStyle(color: Colors.black87, fontSize: 20),
              ),
              onPressed: () {
                FlutterHybrid.sharedInstance.router
                    .openPage('/colorPage', params: {
                  'color': Colors.red[200].value,
                  ShowPageTYpe.PAGE_TYPE: ShowPageTYpe.expectedPageType
                });
              },
            ),
            FlatButton(
              child: Text(
                'Open page in Flutter',
                style: TextStyle(color: Colors.black87, fontSize: 20),
              ),
              onPressed: () {
                Logger.error("CounterPage onPressed");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ColorPage(color: Colors.green)));
              },
            ),
            FlatButton(
              child: Text(
                'Go Back',
                style: TextStyle(color: Colors.black87, fontSize: 20),
              ),
              onPressed: () {
                Navigator.pop(context);
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
