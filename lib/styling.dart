import 'package:flutter/material.dart';
import './size_config.dart';

class AppTheme {
  AppTheme();
  static const Color primaryColor = Color(0xFF344a32);
  static const Color appBackgroundColor = Color(0xFFf2f2f2);
  static const Color indicatorColor = Color(0xFFD8ECF1);
  static const Color unSelectedBackgroundColor = Color(0xFFE7EBEE);
  static const Color subTitleTextColor = Color(0xFF9F988F);
  static const Color accentColor = Color(0xFF659759);
  static const Color buttonColorDefalut = Color(0xFFF0F55F);

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: AppTheme.appBackgroundColor,
    appBarTheme: AppBarTheme(color: accentColor),
    accentColor: accentColor,
    brightness: Brightness.light,
    textTheme: lightTextTheme,
    buttonColor: buttonColorDefalut,
    iconTheme: lightIconTheme,
    indicatorColor: indicatorColor,
  );

  static final IconThemeData lightIconTheme = IconThemeData(
      color: Colors.grey, size: 8.89 * SizeConfig.imageSizeMultiplier);

  static final IconThemeData iconThemeWithDarkBackground =
      lightIconTheme.copyWith(color: Colors.white);

  static final TextTheme lightTextTheme = TextTheme(
    title: _titleLight,
    subtitle: _subTitleLight,
    button: _buttonLight,
    display1: _largeTextLight,
    display2: _flatButtonTextLight,
    display3: _cardTextLight,
    body1: _defaultTextLight,
    body2: _selectedTextLight,
  );

  static final TextStyle _titleLight = TextStyle(
    color: Colors.black,
    fontSize: 3.5 * SizeConfig.textMultiplier,
  );

  static final TextStyle _subTitleLight = TextStyle(
    color: subTitleTextColor,
    fontSize: 2 * SizeConfig.textMultiplier,
    height: 1.5,
  );

  static final TextStyle _buttonLight = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 2 * SizeConfig.textMultiplier,
      letterSpacing: 0.6);

  static final TextStyle _largeTextLight = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 3.0 * SizeConfig.textMultiplier,
  );

  static final TextStyle _flatButtonTextLight = TextStyle(
    color: Colors.white,
    fontSize: 2.0 * SizeConfig.textMultiplier,
  );

  static final TextStyle _cardTextLight = TextStyle(
    color: Colors.black54,
    fontSize: 2.5 * SizeConfig.textMultiplier,
  );
  static final TextStyle _defaultTextLight = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 2 * SizeConfig.textMultiplier,
  );

  static final TextStyle _selectedTextLight = TextStyle(
    color: Color(0xFF3EBACE),
    fontSize: 2 * SizeConfig.textMultiplier,
  );
}
