import 'package:flutter/material.dart';
import 'package:transpo_tracky_mobile_app/helpers/size_config.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Image(
          image: AssetImage('assets/logo_files/portrait.png'),
          width: 61.1 * SizeConfig.widthMultiplier,
          height: 34.4 * SizeConfig.heightMultiplier,
        ),
      ),
    );
  }
}
