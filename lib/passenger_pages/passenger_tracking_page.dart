import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transpo_tracky_mobile_app/google_maps/passenger_tracking_map.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';
import 'package:transpo_tracky_mobile_app/widgets/passenger_tracking_page_detail.dart';

import '../helpers/size_config.dart';

class PassengerTrackingPage extends StatefulWidget {
// this is the user's selected trip
  final Trip trip;

  PassengerTrackingPage({@required this.trip});
  @override
  _PassengerTrackingPageState createState() => _PassengerTrackingPageState();
}

class _PassengerTrackingPageState extends State<PassengerTrackingPage> {
  Widget _buildFloatingButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 4.44 * SizeConfig.widthMultiplier,
        vertical: 2.44 * SizeConfig.heightMultiplier,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back, size: 8.26 * SizeConfig.imageSizeMultiplier,),
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
            icon: Icon(Icons.chat, size: 8.26 * SizeConfig.imageSizeMultiplier,),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            PassengerTrackingMap(),
            _buildFloatingButtons(context),
            PassengerTrackingPageDetail(trip: widget.trip),
          ],
        ),
      ),
    );
  }
}
