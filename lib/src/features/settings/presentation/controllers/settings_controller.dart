import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/app/theme/theme_mode_provider.dart';
import 'package:ahoruna/src/features/settings/domain/entities/user_preferences.dart';
import 'package:ahoruna/src/features/settings/presentation/providers/settings_dependencies.dart';
import 'package:ahoruna/src/features/settings/presentation/providers/user_preferences_provider.dart';

class SettingsController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> updateCurrency(String currencyCode) {
    return _updatePreferences(
      transform: (current) {
        return current.copyWith(currencyCode: currencyCode);
      },
    );
  }

  Future<void> updateNotifications(bool enabled) {
    return _updatePreferences(
      transform: (current) {
        return current.copyWith(notificationsEnabled: enabled);
      },
    );
  }

  Future<void> updateBudgetAlertPercent(int percent) {
    return _updatePreferences(
      transform: (current) {
        return current.copyWith(budgetAlertPercent: percent);
      },
    );
  }

  Future<void> updateTheme(AppThemePreference preference) {
    return _updatePreferences(
      transform: (current) {
        return current.copyWith(theme: preference);
      },
      localThemeMode: _toThemeMode(preference),
    );
  }

  Future<void> _updatePreferences({
    required UserPreferences Function(UserPreferences current) transform,
    ThemeMode? localThemeMode,
  }) async {
    state = const AsyncLoading();

    try {
      final getPreferences = ref.read(getUserPreferencesUseCaseProvider);

      final current = await getPreferences();

      final updated = transform(current);

      await ref.read(updateUserPreferencesUseCaseProvider)(updated);

      if (localThemeMode != null) {
        await ref.read(themeModeProvider.notifier).setThemeMode(localThemeMode);
      }

      ref.invalidate(userPreferencesProvider);

      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);

      rethrow;
    }
  }

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
}
