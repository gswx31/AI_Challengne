import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryYellow = Color(0xFFFFC000);
  static const Color accentPurple = Color(0xFF6A4CFF);

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryYellow,
    colorScheme: ColorScheme.fromSeed(seedColor: primaryYellow),
    scaffoldBackgroundColor: const Color(0xFFF8F8F8),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
      centerTitle: true,
    ),
  );
}
