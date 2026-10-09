import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();

  static TextTheme textTheme({
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return TextTheme(
      displaySmall: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.8,
        color: textPrimary,
      ),
      headlineLarge: TextStyle(
        fontSize: 30,
        height: 1.15,
        fontWeight: FontWeight.w800,
        color: textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        height: 1.15,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.w800,
        color: textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      titleSmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 14,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 13,
        height: 1.45,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      bodySmall: TextStyle(
        fontSize: 11,
        height: 1.4,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      ),
      labelLarge: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: textPrimary,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: textSecondary,
      ),
    );
  }
}
