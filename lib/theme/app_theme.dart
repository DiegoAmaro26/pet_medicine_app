import 'package:flutter/material.dart';

class AppTheme {
  /// 🎨 COLORES PRINCIPALES
  static const Color primaryColor = Color(0xFF3B82C4); // azul del logo
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color textPrimary = Color(0xFF0F172A);

  /// 🌞 TEMA CLARO
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,

    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),

    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      background: backgroundColor,
    ),

    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: textPrimary,
      ),
    ),

    listTileTheme: const ListTileThemeData(
      iconColor: primaryColor,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}
