import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Settings'),),
      body: SafeArea(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(child: Text('Settings Goes Here'))
        ],
      )),
    );
  }
}