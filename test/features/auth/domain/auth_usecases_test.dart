import 'package:flutter_test/flutter_test.dart';

import 'package:ahoruna/src/features/auth/domain/entities/auth_user.dart';
import 'package:ahoruna/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:ahoruna/src/features/auth/domain/usecases/register_user.dart';
import 'package:ahoruna/src/features/auth/domain/usecases/sign_in.dart';
import 'package:ahoruna/src/features/auth/domain/usecases/sign_out.dart';

void main() {
  group('Auth use cases', () {
    test('signs in through repository', () async {
      final repository = _FakeAuthRepository();

      final useCase = SignIn(repository);

      final user = await useCase(email: 'test@ahoruna.com', password: '123456');

      expect(user.email, 'test@ahoruna.com');

      expect(repository.signedIn, isTrue);
    });

    test('registers a new user', () async {
      final repository = _FakeAuthRepository();

      final useCase = RegisterUser(repository);

      final user = await useCase(
        displayName: 'Usuario Prueba',
        email: 'test@ahoruna.com',
        password: '123456',
      );

      expect(user.displayName, 'Usuario Prueba');
    });

    test('signs out through repository', () async {
      final repository = _FakeAuthRepository(signedIn: true);

      final useCase = SignOut(repository);

      await useCase();

      expect(repository.signedIn, isFalse);
    });
  });
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.signedIn = false});

  bool signedIn;

  AuthUser? _user;

  @override
  Stream<AuthUser?> userChanges() {
    return Stream.value(_user);
  }

  @override
  AuthUser? get currentUser {
    return _user;
  }

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    signedIn = true;

    _user = AuthUser(
      uid: 'test-user',
      email: email,
      displayName: 'Usuario Prueba',
      emailVerified: false,
    );

    return _user!;
  }

  @override
  Future<AuthUser> register({
    required String displayName,
    required String email,
    required String password,
  }) async {
    signedIn = true;

    _user = AuthUser(
      uid: 'test-user',
      email: email,
      displayName: displayName,
      emailVerified: false,
    );

    return _user!;
  }

  @override
  Future<void> sendPasswordReset({required String email}) async {}

  @override
  Future<void> signOut() async {
    signedIn = false;
    _user = null;
  }
}
