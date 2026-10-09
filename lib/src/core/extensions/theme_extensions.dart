import 'package:flutter/material.dart';

import 'package:ahoruna/src/app/theme/ahoruna_colors.dart';

extension AhorunaThemeExtension on BuildContext {
  AhorunaColors get ahorunaColors {
    final colors = Theme.of(this).extension<AhorunaColors>();

    assert(colors != null, 'AhorunaColors no está registrado en ThemeData.');

    return colors!;
  }
}
