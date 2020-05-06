import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transpo_tracky_mobile_app/google_maps/driver_navigation_map.dart';
import 'package:transpo_tracky_mobile_app/widgets/driver_navigation_page_detail.dart';

import '../helpers/size_config.dart';

class DriverNavigationPage extends StatefulWidget {
  @override
  _DriverNavigationPageState createState() => _DriverNavigationPageState();
}

class _DriverNavigationPageState extends State<DriverNavigationPage> {
  
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
            icon: Icon(Icons.arrow_back,
                size: 8.26 * SizeConfig.imageSizeMultiplier),
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
            icon: Icon(Icons.chat,
                size: 8.26 * SizeConfig.imageSizeMultiplier),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              DriverNavigationMap(),
              _buildFloatingButtons(context),
              DriverNavigationPageDetail()
            ],
          ),
        ),
      ),
    );
  }
}
