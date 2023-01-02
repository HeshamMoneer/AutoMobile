import 'package:flutter/material.dart';

import 'theme_color.dart';

class AppTheme {
  const AppTheme();
  static ThemeData lightTheme = ThemeData(
      backgroundColor: ThemeColor.background,
      primaryColor: ThemeColor.background,
      cardTheme: CardTheme(color: ThemeColor.background),
      textTheme: TextTheme(bodyText1: TextStyle(color: ThemeColor.black)),
      iconTheme: IconThemeData(color: ThemeColor.iconColor),
      bottomAppBarColor: ThemeColor.background,
      dividerColor: ThemeColor.background,
      appBarTheme: AppBarTheme(color: ThemeColor.lightblack),
      primaryTextTheme:
          TextTheme(bodyText1: TextStyle(color: ThemeColor.titleTextColor)));

  static TextStyle titleStyle = const TextStyle(
      color: Color.fromARGB(255, 33, 33, 33),
      fontSize: 16,
      fontWeight: FontWeight.bold);

  static TextStyle titleStyle2 = const TextStyle(
      color: ThemeColor.titleTextColor,
      fontSize: 16,
      fontWeight: FontWeight.bold);
  static TextStyle subTitleStyle =
      const TextStyle(color: ThemeColor.white, fontSize: 12);
  static TextStyle bidButtonTextStyle = const TextStyle(
      color: ThemeColor.white, fontSize: 16, fontWeight: FontWeight.bold);
  static TextStyle bidButtonInactiveTextStyle = const TextStyle(
      color: ThemeColor.darkgrey, fontSize: 16, fontWeight: FontWeight.bold);
  static TextStyle h1Style =
      const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static TextStyle h2Style = const TextStyle(fontSize: 22);
  static TextStyle h3Style = const TextStyle(fontSize: 20);
  static TextStyle h4Style = const TextStyle(fontSize: 18);
  static TextStyle h5Style = const TextStyle(fontSize: 16);
  static TextStyle h6Style = const TextStyle(fontSize: 14);
  static var buttonStyleBlack = ElevatedButton.styleFrom(
      backgroundColor: ThemeColor.lightblack,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ));
  static var buttonStyleWhite = ElevatedButton.styleFrom(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ));

  static List<BoxShadow> shadow = <BoxShadow>[
    BoxShadow(color: Color(0xfff8f8f8), blurRadius: 10, spreadRadius: 15),
  ];

  static EdgeInsets padding =
      const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
  static EdgeInsets hPadding = const EdgeInsets.symmetric(
    horizontal: 10,
  );

  static double fullWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double fullHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
