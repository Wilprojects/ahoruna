import 'package:firebase_core/firebase_core.dart';

import 'package:ahoruna/src/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:ahoruna/src/features/settings/data/models/user_preferences_model.dart';
import 'package:ahoruna/src/features/settings/domain/entities/user_preferences.dart';
import 'package:ahoruna/src/features/settings/domain/failures/settings_failure.dart';
import 'package:ahoruna/src/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._remoteDataSource);

  final SettingsRemoteDataSource _remoteDataSource;

  @override
  Future<UserPreferences> getPreferences() async {
    try {
      return await _remoteDataSource.getPreferences();
    } on StateError {
      throw const SettingsFailure('No existe una sesión activa.');
    } on FirebaseException {
      throw const SettingsFailure('No pudimos cargar tus preferencias.');
    }
  }

  @override
  Future<void> updatePreferences(UserPreferences preferences) async {
    try {
      await _remoteDataSource.updatePreferences(
        UserPreferencesModel.fromEntity(preferences),
      );
    } on StateError {
      throw const SettingsFailure('No existe una sesión activa.');
    } on FirebaseException {
      throw const SettingsFailure('No pudimos guardar tus preferencias.');
    }
  }
}
