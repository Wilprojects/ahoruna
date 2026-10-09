import 'package:flutter/material.dart';

import 'package:ahoruna/src/app/theme/app_colors.dart';
import 'package:ahoruna/src/core/constants/app_constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  AppConstants.appName,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppConstants.appSlogan,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                  ),
                ),
                const SizedBox(height: 32),
                const _StatusCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 420),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        children: [
          Icon(Icons.check_circle_rounded, color: AppColors.income, size: 32),
          SizedBox(height: 12),
          Text('Base del proyecto configurada', textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
