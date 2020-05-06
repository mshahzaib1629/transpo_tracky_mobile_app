import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/driver_pages/driver_config_page.dart';
import 'package:transpo_tracky_mobile_app/google_maps/driver_hp_map.dart';
import 'package:transpo_tracky_mobile_app/providers/bus_model.dart';
import 'package:transpo_tracky_mobile_app/providers/driver_model.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_config_model.dart';

import '../helpers/size_config.dart';
import '../common_pages/app_drawer.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({Key key}) : super(key: key);

  @override
  _DriverHomePageState createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  bool _expandConfig = false;

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
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              DriverHomePageMap(),
              DriverConfigurationPage(
                isExpanded: _expandConfig,
              )
            ],
          ),
        ),
      ),
    );
  }
}
