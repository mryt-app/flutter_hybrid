import 'package:flutter/material.dart';
import 'package:flutter_hybrid/flutter_hybrid.dart';

class FragmentRouteWidget extends StatelessWidget {
  final Map params;

  FragmentRouteWidget(this.params);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('flutter_boost_example'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 80.0),
            child: Text(
              "flutter fragment",
              style: TextStyle(fontSize: 28.0, color: Colors.blue),
            ),
            alignment: AlignmentDirectional.center,
          ),
          Container(
            margin: const EdgeInsets.only(top: 32.0),
            child: Text(
              params['tag'] ?? '',
              style: TextStyle(fontSize: 28.0, color: Colors.red),
            ),
            alignment: AlignmentDirectional.center,
          ),
          Expanded(child: Container()),
          InkWell(
            child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                color: Colors.yellow,
                child: Text(
                  'open native activity',
                  style: TextStyle(fontSize: 22.0, color: Colors.black),
                )),
            onTap: () => FlutterHybrid.sharedInstance.router
                .openPage('eg://nativeActivity', params: {}),
          ),
          InkWell(
            child: Container(
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.all(8.0),
                color: Colors.yellow,
                child: Text(
                  'open flutter activity',
                  style: TextStyle(fontSize: 22.0, color: Colors.black),
                )),
            onTap: () => FlutterHybrid.sharedInstance.router
                .openPage('eg://flutterActivity', params: {}),
          ),
          InkWell(
              child: Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 80.0),
                  color: Colors.yellow,
                  child: Text(
                    'open flutter fragment',
                    style: TextStyle(fontSize: 22.0, color: Colors.black),
                  )),
              onTap: () => FlutterHybrid.sharedInstance.router
                  .openPage('eg://flutterFragmentActivity', params: {}))
        ],
      ),
    );
  }
}
