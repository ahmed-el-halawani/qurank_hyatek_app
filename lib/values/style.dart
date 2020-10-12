import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'color.dart';
import 'fonts.dart';

class MyStyle {
  static ThemeData mainTheme() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: MyColors.backGround,
      systemNavigationBarColor: MyColors.backGround,
    ));
    return ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryIconTheme: IconThemeData(color: Color(0xff8688a1)),
        textTheme: TextTheme(
            bodyText2: TextStyle(color: Colors.black87),
            bodyText1: TextStyle(color: Colors.black87)));
  }

  static ThemeData mainTheme2() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: MyColors.backgroundDark,
      systemNavigationBarColor: MyColors.backgroundDark,
    ));
    return ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryIconTheme: IconThemeData(color: Color(0xff8688a1)),
        textTheme: TextTheme(
            bodyText2: TextStyle(color: Colors.black87),
            bodyText1: TextStyle(color: Colors.black87)));
  }

  static TextStyle ayatTextStyle({double fontSize = 20}) {
    return TextStyle(
      fontFamily: Fonts.quran,
      fontSize: fontSize,
    );
  }

  static TextStyle bsmalaTextStyle() => TextStyle(
      color: MyColors.selectedTabColor, fontFamily: Fonts.quran, fontSize: 25);

  static tabTextStyle() {
    return TextStyle(
      color: MyColors.selectedTabColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      fontFamily: "ElMessiri",
    );
  }

  static TextStyle generalTextStyle({double fontSize = 20}) {
    return TextStyle(
      color: Colors.white,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      fontFamily: "ElMessiri",
    );
  }

  static TextStyle textSmall = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 15,
      fontFamily: "ElMessiri");
  static TextStyle textBig = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 20,
    fontFamily: "g3",
  );

  static TextStyle largText = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 50,
    fontFamily: Fonts.elMessiri,
  );
}
