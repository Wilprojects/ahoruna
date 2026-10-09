import 'package:flutter/material.dart';

import 'package:ahoruna/src/shared/widgets/ahoruna_button.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({required this.message, super.key, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 46,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 12),
          Text('Algo salió mal', style: theme.textTheme.titleMedium),
          const SizedBox(height: 5),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 18),
            AhorunaButton(
              label: 'Reintentar',
              expand: false,
              variant: AhorunaButtonVariant.secondary,
              onPressed: onRetry,
            ),
          ],
        ],
      ),
    );
  }
}
