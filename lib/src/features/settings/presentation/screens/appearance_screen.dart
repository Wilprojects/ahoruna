import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/app/theme/app_colors.dart';
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

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(userPreferencesProvider);

    final controller = ref.watch(settingsControllerProvider);

    final isLoading = controller.isLoading;

    return Scaffold(
      appBar: const AhorunaAppBar(title: 'Apariencia', showBackButton: true),
      body: preferences.when(
        loading: () {
          return const LoadingView(message: 'Cargando apariencia...');
        },
        error: (error, stackTrace) {
          return Center(
            child: ErrorView(
              message: 'No pudimos cargar la apariencia.',
              onRetry: () {
                ref.invalidate(userPreferencesProvider);
              },
            ),
          );
        },
        data: (value) {
          return ListView(
            padding: const EdgeInsets.all(AppDimensions.pageHorizontalPadding),
            children: [
              Text(
                'Elige cómo quieres ver Ahoruna.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              _ThemeOption(
                title: 'Sistema',
                description: 'Usa la apariencia configurada en tu dispositivo.',
                icon: Icons.settings_brightness_rounded,
                selected: value.theme == AppThemePreference.system,
                onTap: isLoading
                    ? null
                    : () {
                        _changeTheme(context, ref, AppThemePreference.system);
                      },
              ),
              const SizedBox(height: 10),
              _ThemeOption(
                title: 'Claro',
                description: 'Mantiene Ahoruna siempre en modo claro.',
                icon: Icons.light_mode_rounded,
                selected: value.theme == AppThemePreference.light,
                onTap: isLoading
                    ? null
                    : () {
                        _changeTheme(context, ref, AppThemePreference.light);
                      },
              ),
              const SizedBox(height: 10),
              _ThemeOption(
                title: 'Oscuro',
                description: 'Mantiene Ahoruna siempre en modo oscuro.',
                icon: Icons.dark_mode_rounded,
                selected: value.theme == AppThemePreference.dark,
                onTap: isLoading
                    ? null
                    : () {
                        _changeTheme(context, ref, AppThemePreference.dark);
                      },
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _changeTheme(
    BuildContext context,
    WidgetRef ref,
    AppThemePreference preference,
  ) async {
    try {
      await ref
          .read(settingsControllerProvider.notifier)
          .updateTheme(preference);
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

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.title,
    required this.description,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String description;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

    return AhorunaCard(
      showShadow: false,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.primarySoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.labelLarge),
                const SizedBox(height: 3),
                Text(description, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          if (selected)
            const Icon(Icons.check_circle_rounded, color: AppColors.primary),
        ],
      ),
    );
  }
}
