import 'package:flutter/material.dart';

Color darken(Color color, double amount) {
  final hsl = HSLColor.fromColor(color);
  final darkened = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  return darkened.toColor();
}

ThemeData buildAppTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF1F7A8C),
      primary: const Color(0xFF1565C0),
      secondary: const Color(0xFF2E7D32),
      surface: const Color(0xFFF8FBFF),
    ),
    scaffoldBackgroundColor: const Color(0xFFF4F8FC),
    useMaterial3: true,
    textTheme: const TextTheme(
      headlineMedium: TextStyle(fontWeight: FontWeight.w800),
      titleLarge: TextStyle(fontWeight: FontWeight.w800),
      titleMedium: TextStyle(fontWeight: FontWeight.w700),
      bodyLarge: TextStyle(height: 1.45),
      bodyMedium: TextStyle(height: 1.45),
    ),
  );
}
