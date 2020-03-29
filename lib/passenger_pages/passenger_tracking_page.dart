import 'package:flutter/material.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';
import 'package:transpo_tracky_mobile_app/widgets/passenger_tracking_page_detail.dart';

import '../size_config.dart';

class PassengerTrackingPage extends StatefulWidget {
// this is the user's selected trip
  final Trip trip;

  PassengerTrackingPage({@required this.trip});
  @override
  _PassengerTrackingPageState createState() => _PassengerTrackingPageState();
}

class _PassengerTrackingPageState extends State<PassengerTrackingPage> {
  Widget _buildMap(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text('Google Map goes here'),
      ),
    );
  }

  Widget _buildLocationButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 1.94 * SizeConfig.widthMultiplier),
      height: 7 * SizeConfig.heightMultiplier,
      width: 12.5 * SizeConfig.widthMultiplier,
      child: FloatingActionButton(
        onPressed: () {
          print('hello');
        },
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: Icon(
          Icons.location_searching,
          color: Colors.black54,
          size: 7.78 * SizeConfig.imageSizeMultiplier,
        ),
      ),
    );
  }

  Widget _buildFloatingButtons(BuildContext context) {
    return Positioned(
      top: 0.0,
      left: 0.0,
      right: 0.0,
      bottom: 22.2 * SizeConfig.heightMultiplier,
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 4.44 * SizeConfig.widthMultiplier,
            vertical: 2.5 * SizeConfig.heightMultiplier,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      showDialog(
                          context: context,
                          child: AlertDialog(
                            content: Text('Are you sure to leave?'),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Cancel'),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text('Yes'),
                              ),
                            ],
                          ));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.chat),
                    onPressed: () {},
                  )
                ],
              ),
              _buildLocationButton(context),
            ],
          ),
        ),
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
            _buildFloatingButtons(context),
            PassengerTrackingPageDetail(trip: widget.trip),
          ],
        ),
      ),
    );
  }
}
