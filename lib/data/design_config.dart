import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light = ThemeData(
    scaffoldBackgroundColor: Colors.white, 
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFF27F0D),
      primary: const Color(0xFFF27F0D),
      secondary: const Color(0xFFFFCC9A),
      onSecondary: Color.fromARGB(255, 255, 226, 196),
      onPrimary: Colors.white,
    ),
    fontFamily: 'Inter',
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(fontSize: 16),
    ),
  );
}
