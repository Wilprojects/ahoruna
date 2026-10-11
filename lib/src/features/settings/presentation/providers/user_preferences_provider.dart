import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:ahoruna/src/features/settings/domain/entities/user_preferences.dart';
import 'package:ahoruna/src/features/settings/domain/failures/settings_failure.dart';
import 'package:ahoruna/src/features/settings/presentation/providers/settings_dependencies.dart';

final userPreferencesProvider = FutureProvider<UserPreferences>((ref) async {
  final authUser = await ref.watch(authStateProvider.future);

  if (authUser == null) {
    throw const SettingsFailure('No existe una sesión activa.');
  }

  final getPreferences = ref.watch(getUserPreferencesUseCaseProvider);

  return getPreferences();
});
