import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/core/providers/shared_preferences_provider.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const String _themeModeKey = 'theme_mode';

  @override
  ThemeMode build() {
    unawaited(_loadThemeMode());

    return ThemeMode.system;
  }

  Future<void> _loadThemeMode() async {
    try {
      final preferences = ref.read(sharedPreferencesAsyncProvider);

      final storedValue = await preferences.getString(_themeModeKey);

      if (storedValue == null) {
        return;
      }

      state = _themeModeFromString(storedValue);
    } catch (_) {
      // Si no puede recuperarse la preferencia local,
      // Ahoruna conserva ThemeMode.system.
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;

    try {
      final preferences = ref.read(sharedPreferencesAsyncProvider);

      await preferences.setString(_themeModeKey, _themeModeToString(mode));
    } catch (_) {
      // El cambio visual puede mantenerse durante la sesión
      // aunque falle excepcionalmente la persistencia local.
    }
  }

  ThemeMode _themeModeFromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;

      case 'dark':
        return ThemeMode.dark;

      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';

      case ThemeMode.dark:
        return 'dark';

      case ThemeMode.system:
        return 'system';
    }
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
