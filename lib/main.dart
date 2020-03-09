import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/common_pages/last_trips_page.dart';
import 'package:transpo_tracky_mobile_app/driver_pages/driver_home_page.dart';
import 'package:transpo_tracky_mobile_app/driver_pages/driver_navigation_page.dart';
import 'package:transpo_tracky_mobile_app/providers/bus_model.dart';
import 'package:transpo_tracky_mobile_app/providers/driver_model.dart';
import 'package:transpo_tracky_mobile_app/providers/route_model.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';
import 'package:transpo_tracky_mobile_app/size_config.dart';

import './login_page.dart';
import 'styling.dart';

void main(List<String> args) {
  // debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return LayoutBuilder(
      builder: (context, constraints) =>
          OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: TripProvider(),
            ),
            ChangeNotifierProvider.value(
              value: RouteProvider(),
            ),
          ],
          child: MaterialApp(
            home: LoginPage(),
            theme: AppTheme.lightTheme,
          ),
        );
      }),
    );
  }
}
