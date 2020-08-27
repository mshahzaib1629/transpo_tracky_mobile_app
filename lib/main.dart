import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:transpo_tracky_mobile_app/driver_pages/driver_broadcast_screen.dart';
import 'package:transpo_tracky_mobile_app/driver_pages/driver_rest_page.dart';
import 'package:transpo_tracky_mobile_app/helpers/enums.dart';
import 'package:transpo_tracky_mobile_app/passenger_pages/passenger_home_page.dart';
import 'package:transpo_tracky_mobile_app/providers/auth.dart';
import 'package:transpo_tracky_mobile_app/providers/broadcast_model.dart';
import 'package:transpo_tracky_mobile_app/providers/route_model.dart';
import 'package:transpo_tracky_mobile_app/providers/session_model.dart';
import 'package:transpo_tracky_mobile_app/providers/trip_model.dart';

import './common_pages/login_page.dart';
import 'driver_pages/driver_home_page.dart';
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
              value: Auth(),
            ),
            ChangeNotifierProxyProvider<Auth, TripProvider>(
              update: (context, auth, trip) => TripProvider(
                token: auth.token,
                currentUser: auth.currentUser,
                userType: auth.loginMode,
              ),
              create: (context) => TripProvider(),
            ),
            ChangeNotifierProvider.value(
              value: RouteProvider(),
            ),
            ChangeNotifierProvider.value(
              value: SessionProvider(),
            ),
            ChangeNotifierProxyProvider<Auth, BroadCastProvider>(
              update: (context, auth, broadcast) => BroadCastProvider(),
              create: (context) => BroadCastProvider(),
            )
          ],
          child: Consumer<Auth>(
            builder: (context, auth, _) => MaterialApp(
              home: auth.isAuth
                  ? (auth.loginMode == LoginMode.Driver
                      ? DriverHomePage()
                      : PassengerHomePage())
                  : LoginPage(),
              theme: AppTheme.lightTheme,
            ),
          ),
        );
      }),
    );
  }
}
