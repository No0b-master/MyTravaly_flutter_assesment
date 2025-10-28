import 'package:flutter/material.dart';

import '../custom_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: CustomColors.primary,
    scaffoldBackgroundColor: CustomColors.lightBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: CustomColors.primary,
      foregroundColor: CustomColors.white,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: CustomColors.accent,
    ),
    colorScheme: const ColorScheme.light(
      primary: CustomColors.primary,
      secondary: CustomColors.accent,
      surface: CustomColors.white,
      onPrimary: CustomColors.white,
      onSurface: CustomColors.darkText,
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        color: CustomColors.darkText,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: TextStyle(
        color: CustomColors.darkText,
        fontSize: 16,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColors.primary,
        foregroundColor: CustomColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: CustomColors.primary,
    scaffoldBackgroundColor: CustomColors.darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: CustomColors.primary,
      foregroundColor: CustomColors.white,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: CustomColors.warning,
    ),
    colorScheme: const ColorScheme.dark(
      primary: CustomColors.primary,
      secondary: CustomColors.secondary,
      surface: CustomColors.darkBackground,
      onPrimary: CustomColors.white,
      onSurface: CustomColors.lightText,
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        color: CustomColors.lightText,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: TextStyle(
        color: CustomColors.lightText,
        fontSize: 16,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: CustomColors.accent,
        foregroundColor: CustomColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );
}
