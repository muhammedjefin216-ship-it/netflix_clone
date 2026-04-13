import 'package:flutter/material.dart';

class AppTheme {
  static const Color netflixRed     = Color(0xFFE50914);
  static const Color netflixDarkRed = Color(0xFFB20710);
  static const Color background     = Color(0xFF141414);
  static const Color surfaceColor   = Color(0xFF1F1F1F);
  static const Color cardColor      = Color(0xFF2A2A2A);
  static const Color textPrimary    = Color(0xFFFFFFFF);
  static const Color textSecondary  = Color(0xFFB3B3B3);
  static const Color textMuted      = Color(0xFF808080);
  static const Color dividerColor   = Color(0xFF333333);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: netflixRed,
      colorScheme:  ColorScheme.dark(
        primary: netflixRed,
        secondary: netflixRed,
        surface: surfaceColor,
        background: background,
        error: Colors.redAccent,
      ),
      appBarTheme:  AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
      textTheme:  TextTheme(
        displayLarge:   TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        displayMedium:  TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        displaySmall:   TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        headlineLarge:  TextStyle(color: textPrimary, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        headlineSmall:  TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        titleLarge:     TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
        titleMedium:    TextStyle(color: textPrimary),
        titleSmall:     TextStyle(color: textSecondary),
        bodyLarge:      TextStyle(color: textPrimary),
        bodyMedium:     TextStyle(color: textSecondary),
        bodySmall:      TextStyle(color: textMuted),
        labelLarge:     TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide.none,
        ),
        hintStyle:  TextStyle(color: textMuted),
        prefixIconColor: textMuted,
        contentPadding:  EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      bottomNavigationBarTheme:  BottomNavigationBarThemeData(
        backgroundColor: background,
        selectedItemColor: textPrimary,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      iconTheme:  IconThemeData(color: textPrimary),
      dividerTheme:  DividerThemeData(
        color: dividerColor,
        thickness: 0.5,
      ),
    );
  }
}