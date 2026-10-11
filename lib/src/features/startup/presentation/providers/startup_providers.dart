import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/app/theme/theme_mode_provider.dart';
import 'package:ahoruna/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:ahoruna/src/features/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:ahoruna/src/features/settings/domain/entities/user_preferences.dart';
import 'package:ahoruna/src/features/settings/presentation/providers/settings_dependencies.dart';

enum StartupDestination { onboarding, login, home }

final startupDestinationProvider = FutureProvider<StartupDestination>((
  ref,
) async {
  final onboardingCompleted = await ref.watch(
    onboardingCompletedProvider.future,
  );

  if (!onboardingCompleted) {
    return StartupDestination.onboarding;
  }

  final user = await ref.watch(authStateProvider.future);

  if (user == null) {
    return StartupDestination.login;
  }

  try {
    final getPreferences = ref.read(getUserPreferencesUseCaseProvider);

    final preferences = await getPreferences();

    await ref
        .read(themeModeProvider.notifier)
        .setThemeMode(_toThemeMode(preferences.theme));
  } catch (_) {
    // Una falla al sincronizar preferencias
    // no debe impedir iniciar Ahoruna.
  }

  return StartupDestination.home;
});

ThemeMode _toThemeMode(AppThemePreference preference) {
  switch (preference) {
    case AppThemePreference.light:
      return ThemeMode.light;

    case AppThemePreference.dark:
      return ThemeMode.dark;

    case AppThemePreference.system:
      return ThemeMode.system;
  }
}
