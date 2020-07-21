import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/driver_pages/driver_config_page.dart';
import 'package:transpo_tracky_mobile_app/driver_pages/driver_navigation_page.dart';
import 'package:transpo_tracky_mobile_app/google_maps/driver_hp_map.dart';
import 'package:transpo_tracky_mobile_app/helpers/constants.dart';
import 'package:transpo_tracky_mobile_app/providers/bus_model.dart';
import 'package:transpo_tracky_mobile_app/providers/driver_model.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_config_model.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';

import '../helpers/size_config.dart';
import '../common_pages/app_drawer.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({Key key}) : super(key: key);

  @override
  _DriverHomePageState createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  bool _expandConfig = false;
  bool _onTripStatus = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 500))
        .then((value) => _checkIfOnTrip());
  }

  void _onClickLocationButton() async {
    try {
      LocationData userLocation = await Location().getLocation();
      print(
          'latitude: ${userLocation.latitude} \nlongitude: ${userLocation.longitude}');
      // After getting current location of driver
      // setState(() {
      //   _expandConfig = true;
      // });
    } catch (error) {
      return;
    }
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sure to Leave?'),
        content: Text('You are going to exit the app!'),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Exit'),
          ),
        ],
      ),
    );
  }

  Future<void> _checkIfOnTrip() async {
    try {
      bool status = await Provider.of<TripProvider>(context, listen: false)
          .checkIfOnTrip(Constants.dummyDriver.id);
      if (status) _showOnTripDialog();
    } catch (error) {
      print(error);
    }
  }

  void _showOnTripDialog() async {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Welcome Captain!'),
              content: Text('You are already on a trip\nJoin now?'),
              actions: [
                FlatButton(
                    onPressed: () {
                      setState(() {
                        _onTripStatus = true;
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Not Now')),
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DriverNavigationPage()));
                    },
                    child: Text('Sure'))
              ],
            ));
  }

  Widget _buildJoinButton(context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 4.17 * SizeConfig.widthMultiplier,
          vertical: 3.9 * SizeConfig.heightMultiplier,
        ),
        child: GestureDetector(
          onTap: () {
            setState(() {
              _onTripStatus = false;
            });
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DriverNavigationPage(),
              ),
            );
          },
          child: Container(
            height: 7.03 * SizeConfig.heightMultiplier,
            // width: double.infinity,
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
              'Join Now',
              style: Theme.of(context).textTheme.button,
            )),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: BusProvider(),
        ),
        ChangeNotifierProvider.value(
          value: DriverProvider(),
        ),
        ChangeNotifierProvider.value(
          value: TripConfigProvider(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Good Morning!'),
        ),
        drawer: AppDrawer(),
        backgroundColor: Theme.of(context).primaryColor,
        body: WillPopScope(
          onWillPop: _onBackPressed,
          child: SafeArea(
            child: Stack(
              children: <Widget>[
                DriverHomePageMap(),
                _onTripStatus == true
                    ? _buildJoinButton(context)
                    : DriverConfigurationPage(
                        isExpanded: _expandConfig,
                        checkIfOnTrip: _checkIfOnTrip
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
