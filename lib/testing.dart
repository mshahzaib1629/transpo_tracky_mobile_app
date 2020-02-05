import 'package:flutter/material.dart';
import './size_config.dart';
import './styling.dart';

class Testing extends StatelessWidget {
  const Testing({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text('Font Testing'),),
        body: SafeArea(child: ListView(
          children: <Widget>[
            Card(
              child: Text('data'),
            )
          ],
        )),
      ),
    );
  }
}
