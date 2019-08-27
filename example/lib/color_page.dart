import 'package:flutter/material.dart';

class ColorPage extends StatelessWidget {
  final Color color;
  ColorPage({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: color,
        child: Center(
          child: Text(
            'Colored page', 
            textDirection: TextDirection.ltr,
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
      ),
    );
  }
}