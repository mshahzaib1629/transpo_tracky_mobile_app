import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transpo_tracky_mobile_app/styling.dart';

import '../size_config.dart';
import '../common_pages/app_drawer.dart';

class DriverHomePage extends StatelessWidget {
  const DriverHomePage({Key key}) : super(key: key);

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

  Widget _onClickLocationButton(BuildContext context) {
    // After getting current location of driver
    showModalBottomSheet(
        backgroundColor: Colors.black.withOpacity(0),
        context: context,
        builder: (context) => Container(
              height: MediaQuery.of(context).size.height - (14.06 * SizeConfig.heightMultiplier),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.3 * SizeConfig.imageSizeMultiplier),
                  topRight: Radius.circular(8.3 * SizeConfig.imageSizeMultiplier),
                ),
              ),
              child: Column(
                children: <Widget>[
                  _horizontalLLine(context),
                  Text(
                    'CONFIGURATION',
                    style: Theme.of(context).textTheme.display1.copyWith(letterSpacing: 0.15 * SizeConfig.textMultiplier),
                  ),
                  Divider(
                    thickness: 0.15 * SizeConfig.heightMultiplier,
                  )
                ],
              ),
            ),
        isScrollControlled: true,
        );
  }

  Widget _buildCurrentLocationButton(BuildContext context) {
    return Positioned(
      bottom: 5.46 * SizeConfig.heightMultiplier,
      right: 9.72 * SizeConfig.widthMultiplier,
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
    return Scaffold(
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
          ],
        ),
      ),
    );
  }
}
