import 'package:flutter/material.dart';

final ValueNotifier<ThemeMode> themeModeNotifier =
    ValueNotifier<ThemeMode>(ThemeMode.light);

class Constants {
  static String appName = "Flutter Travel";

  // Modern Design System Color Palette (Inspired by Reference Mockups)
  static const Color brandBlue = Color(0xFF1E60FF); // Vibrant Royal Blue
  static const Color brandBlueSoft = Color(0xFFEEF4FF); // Soft Blue Tint
  static const Color brandBlueDark = Color(0xFF1548C7);
  static const Color accentGold = Color(0xFFF59E0B); // Rating Stars & Accents
  static const Color badgeColor = Color(0xFFEF4444);

  // Light Mode Colors
  static const Color lightBG = Color(0xFFF8F9FD);
  static const Color lightCard = Colors.white;
  static const Color textDark = Color(0xFF0F172A);
  static const Color textSubtle = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Dark Mode Colors
  static const Color darkBG = Color(0xFF0B1120);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkCardSoft = Color(0xFF243248);
  static const Color textLight = Color(0xFFF8FAFC);
  static const Color darkBorder = Color(0xFF334155);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: brandBlue,
    scaffoldBackgroundColor: lightBG,
    colorScheme: const ColorScheme.light(
      primary: brandBlue,
      onPrimary: Colors.white,
      secondary: brandBlue,
      surface: lightBG,
    ),
    cardColor: lightCard,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: brandBlue,
      selectionColor: brandBlueSoft,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: lightBG,
      iconTheme: IconThemeData(color: textDark),
      titleTextStyle: TextStyle(
        color: textDark,
        fontSize: 18.0,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.2,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: brandBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: brandBlue,
    scaffoldBackgroundColor: darkBG,
    colorScheme: const ColorScheme.dark(
      primary: brandBlue,
      onPrimary: Colors.white,
      secondary: brandBlue,
      surface: darkBG,
    ),
    cardColor: darkCard,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: brandBlue,
      selectionColor: darkCardSoft,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: darkBG,
      iconTheme: IconThemeData(color: textLight),
      titleTextStyle: TextStyle(
        color: textLight,
        fontSize: 18.0,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.2,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: brandBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    ),
  );
}
