import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/features/auth/presentation/providers/auth_dependencies.dart';
import 'package:ahoruna/src/features/settings/data/datasources/settings_remote_data_source.dart';
import 'package:ahoruna/src/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:ahoruna/src/features/settings/domain/repositories/settings_repository.dart';
import 'package:ahoruna/src/features/settings/domain/usecases/get_user_preferences.dart';
import 'package:ahoruna/src/features/settings/domain/usecases/update_user_preferences.dart';

final settingsRemoteDataSourceProvider = Provider<SettingsRemoteDataSource>((
  ref,
) {
  return FirestoreSettingsRemoteDataSource(
    ref.watch(firebaseAuthProvider),
    ref.watch(firebaseFirestoreProvider),
  );
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(ref.watch(settingsRemoteDataSourceProvider));
});

final getUserPreferencesUseCaseProvider = Provider<GetUserPreferences>((ref) {
  return GetUserPreferences(ref.watch(settingsRepositoryProvider));
});

final updateUserPreferencesUseCaseProvider = Provider<UpdateUserPreferences>((
  ref,
) {
  return UpdateUserPreferences(ref.watch(settingsRepositoryProvider));
});
