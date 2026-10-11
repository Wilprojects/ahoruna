import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/features/auth/domain/entities/auth_user.dart';
import 'package:ahoruna/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:ahoruna/src/features/auth/presentation/providers/auth_dependencies.dart';

final authStateProvider = StreamProvider<AuthUser?>((ref) {
  return ref.watch(authRepositoryProvider).userChanges();
});

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(
  AuthController.new,
);
