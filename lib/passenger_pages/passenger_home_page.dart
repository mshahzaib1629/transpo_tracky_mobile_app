import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/common_pages/app_drawer.dart';
import 'package:transpo_tracky_mobile_app/passenger_pages/passenger_route_selection_page.dart';
import 'package:transpo_tracky_mobile_app/passenger_pages/passenger_tracking_page.dart';
import 'package:transpo_tracky_mobile_app/providers/enums.dart';
import 'package:transpo_tracky_mobile_app/providers/stop_model.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';
import 'package:transpo_tracky_mobile_app/widgets/passenger_home_page_top_bar.dart';

import '../size_config.dart';
import '../styling.dart';

class PassengerHomePage extends StatefulWidget {
  @override
  _PassengerHomePageState createState() => _PassengerHomePageState();
}

class _PassengerHomePageState extends State<PassengerHomePage> {
  
  Widget _buildMap(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text('Google Map goes here'),
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
    return Consumer<TripProvider>(
      builder: (context, tripConsumer, child) => GestureDetector(
        onTap: () {
          if (tripConsumer.passengerSelectedTrip == null) {
            showDialog(
                context: context,
                child: AlertDialog(
                  content: Text('Select a Route first'),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Okay'))
                  ],
                ));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PassengerTrackingPage(
                          trip: tripConsumer.passengerSelectedTrip,
                        )));
          }
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
                PassengerHomePageTopBar(),
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
