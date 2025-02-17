import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: Color(0xFFB5EAD7), // Vert pastel
      secondary: Color(0xFFFFDAC1), // Pêche pastel
      surface: Colors.white, // Utilisation de `surface` au lieu de `background`
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onSurface: Colors.black,
    ),
    scaffoldBackgroundColor: Color(0xFFF7F7F7),
    textTheme: TextTheme(
      headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
    ),
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF7895CB), // Bleu pastel foncé
      secondary: Color(0xFFFFB6B9), // Rose pastel
      surface: Color(0xFF222831), // Remplacement de `background` par `surface`
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: Color(0xFF1A1A2E),
    textTheme: TextTheme(
      headlineLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
    ),
    useMaterial3: true,
  );
}
