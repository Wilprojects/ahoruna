import 'package:flutter_test/flutter_test.dart';

import 'package:ahoruna/src/features/settings/domain/entities/user_preferences.dart';

void main() {
  group('UserPreferences', () {
    test(
      'creates expected defaults',
          () {
        final preferences =
        UserPreferences.defaults();

        expect(
          preferences.currencyCode,
          'PEN',
        );

        expect(
          preferences.languageCode,
          'es',
        );

        expect(
          preferences.theme,
          AppThemePreference.system,
        );

        expect(
          preferences.notificationsEnabled,
          isTrue,
        );

        expect(
          preferences.budgetAlertPercent,
          80,
        );
      },
    );

    test(
      'copyWith updates only selected values',
          () {
        final preferences =
        UserPreferences.defaults();

        final updated =
        preferences.copyWith(
          currencyCode: 'USD',
          budgetAlertPercent: 90,
        );

        expect(
          updated.currencyCode,
          'USD',
        );

        expect(
          updated.budgetAlertPercent,
          90,
        );

        expect(
          updated.theme,
          AppThemePreference.system,
        );
      },
    );
  });
}