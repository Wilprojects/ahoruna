import 'package:flutter/material.dart';

import 'package:ahoruna/src/app/theme/app_colors.dart';

class AppGradients {
  AppGradients._();

  static const LinearGradient balance = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primary,
      AppColors.gradientMiddle,
      AppColors.gradientEnd,
    ],
    stops: [0, 0.58, 1],
  );

  static const LinearGradient primaryButton = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, AppColors.buttonGradientEnd],
  );

  static const LinearGradient brand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, AppColors.gradientEnd],
  );
}
