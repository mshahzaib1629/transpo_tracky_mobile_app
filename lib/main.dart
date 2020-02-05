import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transpo_tracky_mobile_app/driver_pages/route_detail_page.dart';
import 'package:transpo_tracky_mobile_app/driver_pages/view_all_routes_page.dart';
import 'package:transpo_tracky_mobile_app/size_config.dart';
import 'package:transpo_tracky_mobile_app/testing.dart';

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
      builder: (context, constraints) => OrientationBuilder(
        builder: (context, orientation) { 
          SizeConfig().init(constraints, orientation);
          return MaterialApp(
          home: Testing(),
          theme: AppTheme.lightTheme,
        );
        }
      ),
    );
  }
}
