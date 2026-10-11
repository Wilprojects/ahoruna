import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ahoruna/src/app/router/app_routes.dart';
import 'package:ahoruna/src/app/theme/app_dimensions.dart';
import 'package:ahoruna/src/core/extensions/theme_extensions.dart';
import 'package:ahoruna/src/features/settings/domain/entities/user_preferences.dart';
import 'package:ahoruna/src/features/settings/domain/failures/settings_failure.dart';
import 'package:ahoruna/src/features/settings/presentation/providers/settings_providers.dart';
import 'package:ahoruna/src/features/settings/presentation/providers/user_preferences_provider.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_app_bar.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_card.dart';
import 'package:ahoruna/src/shared/widgets/error_view.dart';
import 'package:ahoruna/src/shared/widgets/loading_view.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(userPreferencesProvider);

    final controller = ref.watch(settingsControllerProvider);

    final isLoading = controller.isLoading;

    return Scaffold(
      appBar: const AhorunaAppBar(title: 'Configuración', showBackButton: true),
      body: preferences.when(
        loading: () {
          return const LoadingView(message: 'Cargando configuración...');
        },
        error: (error, stackTrace) {
          return Center(
            child: ErrorView(
              message: 'No pudimos cargar tu configuración.',
              onRetry: () {
                ref.invalidate(userPreferencesProvider);
              },
            ),
          );
        },
        data: (value) {
          return _SettingsContent(preferences: value, isLoading: isLoading);
        },
      ),
    );
  }
}

class _SettingsContent extends ConsumerWidget {
  const _SettingsContent({required this.preferences, required this.isLoading});

  final UserPreferences preferences;
  final bool isLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

    return SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.all(AppDimensions.pageHorizontalPadding),
        children: [
          Text('General', style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          AhorunaCard(
            showShadow: false,
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.payments_outlined),
                    const SizedBox(width: 12),
                    const Expanded(child: Text('Moneda')),
                    DropdownButton<String>(
                      value: preferences.currencyCode,
                      underline: const SizedBox.shrink(),
                      items: const [
                        DropdownMenuItem(value: 'PEN', child: Text('PEN')),
                        DropdownMenuItem(value: 'USD', child: Text('USD')),
                        DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                      ],
                      onChanged: isLoading
                          ? null
                          : (value) {
                              if (value == null) {
                                return;
                              }

                              _runSettingsAction(context, () {
                                return ref
                                    .read(settingsControllerProvider.notifier)
                                    .updateCurrency(value);
                              });
                            },
                    ),
                  ],
                ),
                Divider(height: 32, color: colors.border),
                const Row(
                  children: [
                    Icon(Icons.language_outlined),
                    SizedBox(width: 12),
                    Expanded(child: Text('Idioma')),
                    Text('Español'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Notificaciones', style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          AhorunaCard(
            showShadow: false,
            child: SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: const Text('Notificaciones'),
              subtitle: const Text('Recibe avisos importantes de Ahoruna.'),
              value: preferences.notificationsEnabled,
              onChanged: isLoading
                  ? null
                  : (value) {
                      _runSettingsAction(context, () {
                        return ref
                            .read(settingsControllerProvider.notifier)
                            .updateNotifications(value);
                      });
                    },
              secondary: const Icon(Icons.notifications_outlined),
            ),
          ),
          const SizedBox(height: 24),
          Text('Presupuestos', style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          AhorunaCard(
            showShadow: false,
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded),
                const SizedBox(width: 12),
                const Expanded(child: Text('Alerta al alcanzar')),
                DropdownButton<int>(
                  value: preferences.budgetAlertPercent,
                  underline: const SizedBox.shrink(),
                  items: const [
                    DropdownMenuItem(value: 50, child: Text('50%')),
                    DropdownMenuItem(value: 60, child: Text('60%')),
                    DropdownMenuItem(value: 70, child: Text('70%')),
                    DropdownMenuItem(value: 80, child: Text('80%')),
                    DropdownMenuItem(value: 90, child: Text('90%')),
                    DropdownMenuItem(value: 100, child: Text('100%')),
                  ],
                  onChanged: isLoading
                      ? null
                      : (value) {
                          if (value == null) {
                            return;
                          }

                          _runSettingsAction(context, () {
                            return ref
                                .read(settingsControllerProvider.notifier)
                                .updateBudgetAlertPercent(value);
                          });
                        },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Cuenta y aplicación', style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          AhorunaCard(
            showShadow: false,
            onTap: () {
              context.push(AppRoutes.appearance);
            },
            child: const _NavigationRow(
              icon: Icons.palette_outlined,
              title: 'Apariencia',
              subtitle: 'Tema claro, oscuro o del sistema',
            ),
          ),
          const SizedBox(height: 10),
          AhorunaCard(
            showShadow: false,
            onTap: () {
              context.push(AppRoutes.security);
            },
            child: const _NavigationRow(
              icon: Icons.security_outlined,
              title: 'Seguridad',
              subtitle: 'Contraseña y sesión',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _runSettingsAction(
    BuildContext context,
    Future<void> Function() action,
  ) async {
    try {
      await action();
    } on SettingsFailure catch (error) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(error.message)));
    }
  }
}

class _NavigationRow extends StatelessWidget {
  const _NavigationRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.labelLarge),
              const SizedBox(height: 3),
              Text(subtitle, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
        Icon(Icons.chevron_right_rounded, color: colors.textSecondary),
      ],
    );
  }
}
