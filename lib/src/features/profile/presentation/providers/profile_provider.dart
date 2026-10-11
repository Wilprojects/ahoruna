import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:ahoruna/src/features/profile/domain/entities/user_profile.dart';
import 'package:ahoruna/src/features/profile/domain/failures/profile_failure.dart';
import 'package:ahoruna/src/features/profile/presentation/providers/profile_dependencies.dart';

final profileProvider = FutureProvider<UserProfile>((ref) async {
  final authUser = await ref.watch(authStateProvider.future);

  if (authUser == null) {
    throw const ProfileFailure('No existe una sesión activa.');
  }

  final getProfile = ref.watch(getProfileUseCaseProvider);

  return getProfile();
});
