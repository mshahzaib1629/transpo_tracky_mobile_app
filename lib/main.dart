import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/providers/route_model.dart';
import 'package:transpo_tracky_mobile_app/providers/session_model.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';

import './common_pages/login_page.dart';
import 'helpers/size_config.dart'; 
import 'helpers/styling.dart';
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
            ChangeNotifierProvider.value(
              value: SessionProvider(),
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
