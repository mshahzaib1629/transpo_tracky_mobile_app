import 'package:flutter/material.dart';

import '../size_config.dart';
import '../styling.dart';

class PassengerHomePage extends StatelessWidget {
  Widget _buildMap(BuildContext context) {
    return Container(
      color: Colors.black12,
      // height: 32.8125 * SizeConfig.heightMultiplier,
      child: Center(
        child: Text('Google Map goes here'),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
      decoration: BoxDecoration(
          color: Colors.white,
          // border: Border.all(width: 1.0, color: Colors.black26),
          borderRadius: BorderRadius.circular(5.0)),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            color: Colors.black,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              // cursorWidth: ,
              decoration: InputDecoration(
                hintText: 'Select Route',
                border: InputBorder.none,
              ),
              style: TextStyle(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 45,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius:
                BorderRadius.circular(0.78 * SizeConfig.heightMultiplier),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0.0 * SizeConfig.heightMultiplier,
                      0.23 * SizeConfig.heightMultiplier),
                  blurRadius: 1.02 * SizeConfig.heightMultiplier,
                  spreadRadius: 0.2 * SizeConfig.heightMultiplier),
            ]),
        child: Center(
            child: Text(
          'GO',
          style: Theme.of(context).textTheme.button,
        )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          _buildMap(context),
          Padding(
            padding: EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildTopBar(context),
                _buildLoginButton(context),
              ],
            ),
          )
        ],
      )),
    );
  }
}
