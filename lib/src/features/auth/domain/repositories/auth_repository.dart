import 'package:ahoruna/src/features/auth/domain/entities/auth_user.dart';

abstract interface class AuthRepository {
  Stream<AuthUser?> userChanges();

  AuthUser? get currentUser;

  Future<AuthUser> signIn({required String email, required String password});

  Future<AuthUser> register({
    required String displayName,
    required String email,
    required String password,
  });

  Future<void> sendPasswordReset({required String email});

  Future<void> signOut();
}
