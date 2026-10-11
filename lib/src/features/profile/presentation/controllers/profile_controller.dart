import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:ahoruna/src/features/profile/presentation/providers/profile_dependencies.dart';
import 'package:ahoruna/src/features/profile/presentation/providers/profile_provider.dart';

class ProfileController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> updateDisplayName({required String displayName}) async {
    state = const AsyncLoading();

    try {
      await ref.read(updateDisplayNameUseCaseProvider)(
        displayName: displayName,
      );

      ref.invalidate(profileProvider);
      ref.invalidate(authStateProvider);

      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);

      rethrow;
    }
  }
}
