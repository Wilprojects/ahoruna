import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/features/auth/presentation/providers/auth_dependencies.dart';

class AuthController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> signIn({required String email, required String password}) {
    return _execute(() async {
      await ref.read(signInUseCaseProvider)(email: email, password: password);
    });
  }

  Future<void> register({
    required String displayName,
    required String email,
    required String password,
  }) {
    return _execute(() async {
      await ref.read(registerUserUseCaseProvider)(
        displayName: displayName,
        email: email,
        password: password,
      );
    });
  }

  Future<void> sendPasswordReset({required String email}) {
    return _execute(() async {
      await ref.read(sendPasswordResetUseCaseProvider)(email: email);
    });
  }

  Future<void> signOut() {
    return _execute(() async {
      await ref.read(signOutUseCaseProvider)();
    });
  }

  Future<void> _execute(Future<void> Function() action) async {
    state = const AsyncLoading();

    try {
      await action();

      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);

      rethrow;
    }
  }
}
