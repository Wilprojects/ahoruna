import 'package:ahoruna/src/features/settings/domain/entities/user_preferences.dart';

class UserPreferencesModel extends UserPreferences {
  const UserPreferencesModel({
    required super.currencyCode,
    required super.languageCode,
    required super.theme,
    required super.notificationsEnabled,
    required super.budgetAlertPercent,
  });

  factory UserPreferencesModel.defaults() {
    return const UserPreferencesModel(
      currencyCode: 'PEN',
      languageCode: 'es',
      theme: AppThemePreference.system,
      notificationsEnabled: true,
      budgetAlertPercent: 80,
    );
  }

  factory UserPreferencesModel.fromMap(Map<String, dynamic>? data) {
    final alertValue = data?['budgetAlertPercent'];

    return UserPreferencesModel(
      currencyCode: data?['currency'] as String? ?? 'PEN',
      languageCode: data?['language'] as String? ?? 'es',
      theme: _parseTheme(data?['theme'] as String?),
      notificationsEnabled: data?['notificationsEnabled'] as bool? ?? true,
      budgetAlertPercent: alertValue is num ? alertValue.toInt() : 80,
    );
  }

  factory UserPreferencesModel.fromEntity(UserPreferences preferences) {
    return UserPreferencesModel(
      currencyCode: preferences.currencyCode,
      languageCode: preferences.languageCode,
      theme: preferences.theme,
      notificationsEnabled: preferences.notificationsEnabled,
      budgetAlertPercent: preferences.budgetAlertPercent,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'currency': currencyCode,
      'language': languageCode,
      'theme': theme.name,
      'notificationsEnabled': notificationsEnabled,
      'budgetAlertPercent': budgetAlertPercent,
    };
  }

  static AppThemePreference _parseTheme(String? value) {
    switch (value) {
      case 'light':
        return AppThemePreference.light;

      case 'dark':
        return AppThemePreference.dark;

      case 'system':
      default:
        return AppThemePreference.system;
    }
  }
}
