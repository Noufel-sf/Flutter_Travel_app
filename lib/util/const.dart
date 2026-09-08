import 'package:flutter/material.dart';

final ValueNotifier<ThemeMode> themeModeNotifier =
    ValueNotifier<ThemeMode>(ThemeMode.light);

class Constants {
  static String appName = "Flutter Travel";

  // Colors for theme
  static const Color lightPrimary = Color(0xfffcfcff);
  static const Color darkPrimary = Colors.black;
  static const Color lightAccent = Color(0xFF263238);
  static const Color darkAccent = Colors.white;
  static const Color lightBG = Color(0xfffcfcff);
  static const Color darkBG = Colors.black;
  static const Color badgeColor = Colors.red;

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: lightPrimary,
    scaffoldBackgroundColor: lightBG,
    colorScheme: const ColorScheme.light(
      primary: lightPrimary,
      secondary: lightAccent,
      surface: lightBG,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: lightAccent,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: lightBG,
      iconTheme: IconThemeData(color: Colors.black87),
      titleTextStyle: TextStyle(
        color: darkBG,
        fontSize: 18.0,
        fontWeight: FontWeight.w800,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkPrimary,
    scaffoldBackgroundColor: darkBG,
    colorScheme: const ColorScheme.dark(
      primary: darkPrimary,
      secondary: darkAccent,
      surface: darkBG,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: darkAccent,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: darkBG,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: lightBG,
        fontSize: 18.0,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}
