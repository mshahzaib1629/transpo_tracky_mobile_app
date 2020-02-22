import 'package:flutter/material.dart';
import 'package:transpo_tracky_mobile_app/common_pages/app_drawer.dart';
import 'package:transpo_tracky_mobile_app/passenger_pages/passenger_route_selection_page.dart';
import 'package:transpo_tracky_mobile_app/passenger_pages/passenger_tracking_page.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';

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
      height: 8.59 * SizeConfig.heightMultiplier,
      decoration: BoxDecoration(
          color: Colors.white,
          // border: Border.all(
          // width: 0.28 * SizeConfig.widthMultiplier,
          // color: Colors.black12,
          // ),
          borderRadius:
              BorderRadius.circular(2.78 * SizeConfig.imageSizeMultiplier),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 0.078 * SizeConfig.heightMultiplier),
              blurRadius: 4.17 * SizeConfig.imageSizeMultiplier,
            ),
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, -0.078 * SizeConfig.heightMultiplier),
              blurRadius: 4.17 * SizeConfig.imageSizeMultiplier,
            ),
          ]),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            color: Theme.of(context).iconTheme.color,
            onPressed: () {},
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PassengerRouteSelectionPage()));
              },
              child: Text(
                'Select Your Route',
                style: Theme.of(context)
                    .textTheme
                    .body2
                    .copyWith(fontWeight: FontWeight.normal),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCurrentLocationButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.9 * SizeConfig.heightMultiplier),
      height: 7.03 * SizeConfig.heightMultiplier,
      width: 12.5 * SizeConfig.widthMultiplier,
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: Icon(
          Icons.location_searching,
          color: Colors.black54,
          size: 7.78 * SizeConfig.imageSizeMultiplier,
        ),
      ),
    );
  }

  Widget _buildGoButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => PassengerTrackingPage(trip: dummy_selected_trip,)));
      },
      child: Container(
        height: 7.03 * SizeConfig.heightMultiplier,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).buttonColor,
            borderRadius:
                BorderRadius.circular(2.38 * SizeConfig.heightMultiplier),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 0.078 * SizeConfig.heightMultiplier),
                blurRadius: 4.17 * SizeConfig.imageSizeMultiplier,
              ),
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, -0.078 * SizeConfig.heightMultiplier),
                blurRadius: 4.17 * SizeConfig.imageSizeMultiplier,
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
      drawer: AppDrawer(),
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          _buildMap(context),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.5 * SizeConfig.widthMultiplier,
              vertical: 3.45 * SizeConfig.heightMultiplier,
            ),
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
