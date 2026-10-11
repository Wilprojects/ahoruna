import 'package:ahoruna/src/features/settings/domain/entities/user_preferences.dart';
import 'package:ahoruna/src/features/settings/domain/repositories/settings_repository.dart';

class GetUserPreferences {
  const GetUserPreferences(this._repository);

  final SettingsRepository _repository;

  Future<UserPreferences> call() {
    return _repository.getPreferences();
  }
}
