import 'package:flutter/material.dart';

import 'package:ahoruna/src/app/theme/app_colors.dart';
import 'package:ahoruna/src/app/theme/app_dimensions.dart';
import 'package:ahoruna/src/app/theme/app_gradients.dart';
import 'package:ahoruna/src/app/theme/app_shadows.dart';
import 'package:ahoruna/src/core/extensions/theme_extensions.dart';

enum AhorunaButtonVariant { primary, secondary, soft, danger }

class AhorunaButton extends StatelessWidget {
  const AhorunaButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.variant = AhorunaButtonVariant.primary,
    this.isLoading = false,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AhorunaButtonVariant variant;
  final bool isLoading;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final colors = context.ahorunaColors;
    final theme = Theme.of(context);

    final enabled = onPressed != null && !isLoading;

    Color foregroundColor;
    Color? backgroundColor;
    Color? borderColor;
    Gradient? gradient;
    List<BoxShadow> boxShadow = const [];

    switch (variant) {
      case AhorunaButtonVariant.primary:
        foregroundColor = Colors.white;
        gradient = AppGradients.primaryButton;
        boxShadow = enabled ? AppShadows.primary : const [];

      case AhorunaButtonVariant.secondary:
        foregroundColor = theme.colorScheme.onSurface;
        backgroundColor = theme.colorScheme.surface;
        borderColor = colors.border;

      case AhorunaButtonVariant.soft:
        foregroundColor = AppColors.primary;
        backgroundColor = colors.primarySoft;

      case AhorunaButtonVariant.danger:
        foregroundColor = colors.expense;
        backgroundColor = colors.expense.withValues(alpha: 0.12);
    }

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: enabled ? 1 : 0.55,
      child: Container(
        width: expand ? double.infinity : null,
        decoration: BoxDecoration(
          color: backgroundColor,
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
          border: borderColor == null ? null : Border.all(color: borderColor),
          boxShadow: boxShadow,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: AppDimensions.buttonHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: isLoading
                      ? SizedBox(
                          width: 21,
                          height: 21,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              foregroundColor,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisSize: expand
                              ? MainAxisSize.max
                              : MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (icon != null) ...[
                              Icon(icon, size: 19, color: foregroundColor),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              label,
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: foregroundColor,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
