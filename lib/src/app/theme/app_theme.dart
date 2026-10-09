import 'package:flutter/material.dart';

import 'package:ahoruna/src/app/theme/ahoruna_colors.dart';
import 'package:ahoruna/src/app/theme/app_colors.dart';
import 'package:ahoruna/src/app/theme/app_dimensions.dart';
import 'package:ahoruna/src/app/theme/app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return _buildTheme(
      brightness: Brightness.light,
      background: AppColors.lightBackground,
      surface: AppColors.lightSurface,
      textPrimary: AppColors.lightTextPrimary,
      textSecondary: AppColors.lightTextSecondary,
      border: AppColors.lightBorder,
      customColors: AhorunaColors.light,
    );
  }

  static ThemeData get dark {
    return _buildTheme(
      brightness: Brightness.dark,
      background: AppColors.darkBackground,
      surface: AppColors.darkSurface,
      textPrimary: AppColors.darkTextPrimary,
      textSecondary: AppColors.darkTextSecondary,
      border: AppColors.darkBorder,
      customColors: AhorunaColors.dark,
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color textPrimary,
    required Color textSecondary,
    required Color border,
    required AhorunaColors customColors,
  }) {
    final colorScheme = brightness == Brightness.light
        ? const ColorScheme.light(
            primary: AppColors.primary,
            secondary: AppColors.primarySecondary,
            surface: AppColors.lightSurface,
            error: AppColors.expense,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: AppColors.lightTextPrimary,
            onError: Colors.white,
          )
        : const ColorScheme.dark(
            primary: AppColors.primary,
            secondary: AppColors.primarySecondary,
            surface: AppColors.darkSurface,
            error: AppColors.expense,
            onPrimary: Colors.white,
            onSecondary: Colors.white,
            onSurface: AppColors.darkTextPrimary,
            onError: Colors.white,
          );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      colorScheme: colorScheme,
      textTheme: AppTypography.textTheme(
        textPrimary: textPrimary,
        textSecondary: textSecondary,
      ),
      extensions: <ThemeExtension<dynamic>>[customColors],
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        hintStyle: TextStyle(color: textSecondary),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
          borderSide: const BorderSide(color: AppColors.expense),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
          borderSide: const BorderSide(color: AppColors.expense, width: 1.4),
        ),
      ),
      dividerColor: border,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),
    );
  }
}
