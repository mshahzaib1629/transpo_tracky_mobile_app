import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:transpo_tracky_mobile_app/styling.dart';

import '../size_config.dart';
import 'driver_app_drawer.dart';

class DriverHomePage extends StatelessWidget {
  const DriverHomePage({Key key}) : super(key: key);

  Widget _topBar(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          // mainAxisAlignment: MainAxisAlignment.,
          children: <Widget>[
            Icon(Icons.menu, color: AppTheme.iconThemeWithDarkBackground.color),
            SizedBox(
              width: 4.17 * SizeConfig.widthMultiplier,
            ),
            Row(
              children: <Widget>[
                Text(
                  '02-02-2020',
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(color: Colors.white),
                ),
                SizedBox(
                  width: 1.67 * SizeConfig.widthMultiplier,
                ),
                Text(
                  '|',
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(color: Colors.white),
                ),
                SizedBox(
                  width: 1.67 * SizeConfig.widthMultiplier,
                ),
                Text(
                  '10:30 AM',
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(color: Colors.white),
                ),
              ],
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 2.2 * SizeConfig.widthMultiplier,
            vertical: 2.2 * SizeConfig.heightMultiplier,
          ),
          child: Text(
            'PICK UP MODE',
            style:
                Theme.of(context).textTheme.title.copyWith(color: Colors.white),
          ),
        )
      ],
    );
  }

  Widget _configurationButton(BuildContext context) {
    return Container(
      height: 120.0,
      width: 120.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).buttonColor,
      ),
      child: Center(
        child: Icon(
          Icons.settings,
          color: Colors.black54,
          size: 90.0,
        ),
      ),
    );
  }

  Widget _goButton(BuildContext context) {
    return Container(
      height: 120.0,
      width: 120.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).buttonColor,
      ),
      child: Center(
        child: Text(
          'GO',
          style: TextStyle(color: Colors.black54, fontSize: 30.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DriverAppDrawer(),
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: 5.56 * SizeConfig.widthMultiplier,
              vertical: 5.68 * SizeConfig.heightMultiplier),
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              _topBar(context),
              Expanded(
                  child: Center(
                child: Container(
                  height: 46.8 * SizeConfig.heightMultiplier,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _configurationButton(context),
                      SizedBox(
                        height: 7 * SizeConfig.heightMultiplier,
                      ),
                      _goButton(context),
                    ],
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
