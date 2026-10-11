import 'package:firebase_auth/firebase_auth.dart';

import 'package:ahoruna/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ahoruna/src/features/auth/data/datasources/user_profile_remote_data_source.dart';
import 'package:ahoruna/src/features/auth/data/mappers/firebase_user_mapper.dart';
import 'package:ahoruna/src/features/auth/domain/entities/auth_user.dart';
import 'package:ahoruna/src/features/auth/domain/failures/auth_failure.dart';
import 'package:ahoruna/src/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._authDataSource, this._profileDataSource);

  final AuthRemoteDataSource _authDataSource;
  final UserProfileRemoteDataSource _profileDataSource;

  @override
  Stream<AuthUser?> userChanges() {
    return _authDataSource.userChanges().map((user) => user?.toDomain());
  }

  @override
  AuthUser? get currentUser {
    return _authDataSource.currentUser?.toDomain();
  }

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _authDataSource.signIn(
        email: email,
        password: password,
      );

      try {
        await _profileDataSource.ensureProfile(user: user);
      } on FirebaseException {
        await _authDataSource.signOut();

        throw const AuthFailure(
          'Iniciaste sesión, pero no pudimos preparar '
          'tu perfil. Inténtalo nuevamente.',
        );
      }

      return user.toDomain();
    } on AuthFailure {
      rethrow;
    } on FirebaseAuthException catch (error) {
      throw _mapAuthException(error);
    } catch (_) {
      throw const AuthFailure(
        'No pudimos iniciar sesión. Inténtalo nuevamente.',
      );
    }
  }

  @override
  Future<AuthUser> register({
    required String displayName,
    required String email,
    required String password,
  }) async {
    try {
      final user = await _authDataSource.register(
        displayName: displayName,
        email: email,
        password: password,
      );

      try {
        await _profileDataSource.createProfile(
          user: user,
          displayName: displayName,
        );
      } on FirebaseException {
        await _authDataSource.signOut();

        throw const AuthFailure(
          'La cuenta fue creada, pero no pudimos '
          'preparar tu perfil. Intenta iniciar sesión.',
        );
      }

      return user.toDomain();
    } on AuthFailure {
      rethrow;
    } on FirebaseAuthException catch (error) {
      throw _mapAuthException(error);
    } catch (_) {
      throw const AuthFailure(
        'No pudimos crear tu cuenta. '
        'Inténtalo nuevamente.',
      );
    }
  }

  @override
  Future<void> sendPasswordReset({required String email}) async {
    try {
      await _authDataSource.sendPasswordReset(email: email);
    } on FirebaseAuthException catch (error) {
      throw _mapAuthException(error);
    } catch (_) {
      throw const AuthFailure('No pudimos enviar el correo de recuperación.');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _authDataSource.signOut();
    } catch (_) {
      throw const AuthFailure('No pudimos cerrar la sesión.');
    }
  }

  AuthFailure _mapAuthException(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return const AuthFailure(
          'El correo electrónico no es válido.',
          code: 'invalid-email',
        );

      case 'invalid-credential':
      case 'user-not-found':
      case 'wrong-password':
        return const AuthFailure(
          'Correo o contraseña incorrectos.',
          code: 'invalid-credential',
        );

      case 'email-already-in-use':
        return const AuthFailure(
          'Ya existe una cuenta con este correo.',
          code: 'email-already-in-use',
        );

      case 'weak-password':
        return const AuthFailure(
          'La contraseña es demasiado débil.',
          code: 'weak-password',
        );

      case 'user-disabled':
        return const AuthFailure(
          'Esta cuenta se encuentra deshabilitada.',
          code: 'user-disabled',
        );

      case 'too-many-requests':
        return const AuthFailure(
          'Se realizaron demasiados intentos. '
          'Inténtalo más tarde.',
          code: 'too-many-requests',
        );

      case 'network-request-failed':
        return const AuthFailure(
          'No pudimos conectarnos. '
          'Comprueba tu conexión a internet.',
          code: 'network-request-failed',
        );

      default:
        return AuthFailure(
          error.message ?? 'Ocurrió un problema de autenticación.',
          code: error.code,
        );
    }
  }
}
