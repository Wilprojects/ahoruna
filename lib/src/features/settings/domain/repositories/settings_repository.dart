import 'package:ahoruna/src/features/settings/domain/entities/user_preferences.dart';

abstract interface class SettingsRepository {
  Future<UserPreferences> getPreferences();

  Future<void> updatePreferences(UserPreferences preferences);
}
