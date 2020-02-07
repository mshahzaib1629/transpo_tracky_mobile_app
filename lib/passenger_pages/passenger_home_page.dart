import 'package:flutter/material.dart';

import '../size_config.dart';
import '../styling.dart';

class PassengerHomePage extends StatelessWidget {
  Widget _buildMap(BuildContext context) {
    return Container(
      color: Colors.white,
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
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 0.5),
              blurRadius: 15,
            ),
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, -0.5),
              blurRadius: 15,
            ),
          ]),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            color: Theme.of(context).iconTheme.color,
            onPressed: () {},
          ),
          GestureDetector(
            child: Text(
              'Select Your Route',
              style: Theme.of(context).textTheme.body2,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCurrentLocationButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25.0),
      height: 45.0,
      width: 45.0,
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: Icon(
          Icons.location_searching,
          color: Colors.black54,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildGoButton(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 45,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).buttonColor,
            borderRadius:
                BorderRadius.circular(0.78 * SizeConfig.heightMultiplier),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 0.5),
                blurRadius: 15,
              ),
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, -0.5),
                blurRadius: 15,
              ),
            ]),
        child: Center(
            child: Text(
          'LETS GO!',
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    _buildCurrentLocationButton(context),
                    _buildGoButton(context),
                  ],
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
