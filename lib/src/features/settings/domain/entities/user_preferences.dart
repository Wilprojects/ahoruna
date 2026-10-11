enum AppThemePreference { system, light, dark }

class UserPreferences {
  const UserPreferences({
    required this.currencyCode,
    required this.languageCode,
    required this.theme,
    required this.notificationsEnabled,
    required this.budgetAlertPercent,
  });

  final String currencyCode;
  final String languageCode;
  final AppThemePreference theme;
  final bool notificationsEnabled;
  final int budgetAlertPercent;

  factory UserPreferences.defaults() {
    return const UserPreferences(
      currencyCode: 'PEN',
      languageCode: 'es',
      theme: AppThemePreference.system,
      notificationsEnabled: true,
      budgetAlertPercent: 80,
    );
  }

  UserPreferences copyWith({
    String? currencyCode,
    String? languageCode,
    AppThemePreference? theme,
    bool? notificationsEnabled,
    int? budgetAlertPercent,
  }) {
    return UserPreferences(
      currencyCode: currencyCode ?? this.currencyCode,
      languageCode: languageCode ?? this.languageCode,
      theme: theme ?? this.theme,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      budgetAlertPercent: budgetAlertPercent ?? this.budgetAlertPercent,
    );
  }
}
