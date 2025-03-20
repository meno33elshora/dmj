import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeApp {
  ThemeApp._internal();
  static final ThemeApp _instance = ThemeApp._internal();
  static ThemeApp get instance => _instance;
  factory ThemeApp() => _instance;

  late ThemeApp _themeService;
  static ThemeApp get themeType => _instance._themeService;

  //! Light Theme
  ThemeData lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          )));
}
