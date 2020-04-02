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
      bottom: 20.2 * SizeConfig.heightMultiplier,
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
