import 'package:flutter/material.dart';

import 'package:ahoruna/src/app/theme/app_dimensions.dart';
import 'package:ahoruna/src/app/theme/app_shadows.dart';
import 'package:ahoruna/src/core/extensions/theme_extensions.dart';

class AhorunaCard extends StatelessWidget {
  const AhorunaCard({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.gradient,
    this.onTap,
    this.showShadow = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

    final decoration = BoxDecoration(
      color: gradient == null ? theme.colorScheme.surface : null,
      gradient: gradient,
      borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      border: gradient == null ? Border.all(color: colors.border) : null,
      boxShadow: showShadow ? AppShadows.small(theme.brightness) : const [],
    );

    return Container(
      margin: margin,
      decoration: decoration,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
