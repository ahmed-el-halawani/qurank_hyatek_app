import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran/values/style.dart';

enum themeSelectKey { classicTheme, modernTheme }

class ConstProvider extends ChangeNotifier {
  ConstProvider._();

  static ConstProvider instance = ConstProvider._();

  themeSelectKey themeState = themeSelectKey.classicTheme;
  ThemeData theme = MyStyle.mainTheme2();

  changeTheme(themeSelectKey key) {
    if (key == themeSelectKey.classicTheme) {
      theme = MyStyle.mainTheme2();
    } else {
      theme = MyStyle.mainTheme();
    }
    themeState = key;
    notifyListeners();
  }
}
