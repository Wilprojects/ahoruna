import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ahoruna/src/app/theme/theme_mode_provider.dart';

void main() {
  test('theme mode starts with system mode', () {
    final container = ProviderContainer();

    addTearDown(container.dispose);

    expect(container.read(themeModeProvider), ThemeMode.system);
  });

  test('theme mode can change to dark mode', () {
    final container = ProviderContainer();

    addTearDown(container.dispose);

    container.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);

    expect(container.read(themeModeProvider), ThemeMode.dark);
  });
}
