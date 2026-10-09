import 'package:flutter/material.dart';

import 'package:ahoruna/src/app/theme/app_colors.dart';

@immutable
class AhorunaColors extends ThemeExtension<AhorunaColors> {
  const AhorunaColors({
    required this.income,
    required this.expense,
    required this.warning,
    required this.surfaceSecondary,
    required this.textSecondary,
    required this.border,
    required this.primarySoft,
  });

  final Color income;
  final Color expense;
  final Color warning;
  final Color surfaceSecondary;
  final Color textSecondary;
  final Color border;
  final Color primarySoft;

  static const AhorunaColors light = AhorunaColors(
    income: AppColors.income,
    expense: AppColors.expense,
    warning: AppColors.warning,
    surfaceSecondary: AppColors.lightSurfaceSecondary,
    textSecondary: AppColors.lightTextSecondary,
    border: AppColors.lightBorder,
    primarySoft: AppColors.lightPrimarySoft,
  );

  static const AhorunaColors dark = AhorunaColors(
    income: AppColors.income,
    expense: AppColors.expense,
    warning: AppColors.warning,
    surfaceSecondary: AppColors.darkSurfaceSecondary,
    textSecondary: AppColors.darkTextSecondary,
    border: AppColors.darkBorder,
    primarySoft: AppColors.darkPrimarySoft,
  );

  @override
  AhorunaColors copyWith({
    Color? income,
    Color? expense,
    Color? warning,
    Color? surfaceSecondary,
    Color? textSecondary,
    Color? border,
    Color? primarySoft,
  }) {
    return AhorunaColors(
      income: income ?? this.income,
      expense: expense ?? this.expense,
      warning: warning ?? this.warning,
      surfaceSecondary: surfaceSecondary ?? this.surfaceSecondary,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
      primarySoft: primarySoft ?? this.primarySoft,
    );
  }

  @override
  AhorunaColors lerp(covariant AhorunaColors? other, double t) {
    if (other == null) {
      return this;
    }

    return AhorunaColors(
      income: Color.lerp(income, other.income, t)!,
      expense: Color.lerp(expense, other.expense, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      surfaceSecondary: Color.lerp(
        surfaceSecondary,
        other.surfaceSecondary,
        t,
      )!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      primarySoft: Color.lerp(primarySoft, other.primarySoft, t)!,
    );
  }
}
