import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/driver_pages/driver_config_page.dart';
import 'package:transpo_tracky_mobile_app/providers/bus_model.dart';
import 'package:transpo_tracky_mobile_app/providers/driver_model.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_config_model.dart';
import 'package:transpo_tracky_mobile_app/styling.dart';

import '../size_config.dart';
import '../common_pages/app_drawer.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({Key key}) : super(key: key);

  @override
  _DriverHomePageState createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  bool _expandConfig = true;

  Widget _buildMap(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text('Google Map goes here'),
      ),
    );
  }

  Widget _horizontalLLine(BuildContext context) => Container(
        margin:
            EdgeInsets.symmetric(vertical: 2.82 * SizeConfig.widthMultiplier),
        width: 16.87 * SizeConfig.widthMultiplier,
        height: 0.56 * SizeConfig.heightMultiplier,
        color: Theme.of(context).accentColor,
      );

  void _onClickLocationButton(BuildContext context) {
    // After getting current location of driver
    setState(() {
      _expandConfig = true;
    });
  }

  Widget _buildCurrentLocationButton(BuildContext context) {
    return Positioned(
      bottom: 13.76 * SizeConfig.heightMultiplier,
      right: 6.72 * SizeConfig.widthMultiplier,
      child: Container(
        height: 7 * SizeConfig.heightMultiplier,
        width: 12.5 * SizeConfig.widthMultiplier,
        child: FloatingActionButton(
          onPressed: () {
            _onClickLocationButton(context);
          },
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: Icon(
            Icons.location_searching,
            color: Colors.black54,
            size: 7.78 * SizeConfig.imageSizeMultiplier,
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
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              _buildMap(context),
              _buildCurrentLocationButton(context),
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
