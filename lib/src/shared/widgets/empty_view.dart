import 'package:flutter/material.dart';

import 'package:ahoruna/src/core/extensions/theme_extensions.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({
    required this.title,
    required this.message,
    super.key,
    this.icon = Icons.inbox_rounded,
  });

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: colors.surfaceSecondary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, size: 30, color: colors.textSecondary),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 5),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
