import 'package:firebase_auth/firebase_auth.dart';

abstract interface class AuthRemoteDataSource {
  Stream<User?> userChanges();

  User? get currentUser;

  Future<User> signIn({required String email, required String password});

  Future<User> register({
    required String displayName,
    required String email,
    required String password,
  });

  Future<void> sendPasswordReset({required String email});

  Future<void> signOut();
}

class FirebaseAuthRemoteDataSource implements AuthRemoteDataSource {
  FirebaseAuthRemoteDataSource(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  @override
  Stream<User?> userChanges() {
    return _firebaseAuth.userChanges();
  }

  @override
  User? get currentUser {
    return _firebaseAuth.currentUser;
  }

  @override
  Future<User> signIn({required String email, required String password}) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw StateError('Firebase no devolvió un usuario autenticado.');
    }

    return user;
  }

  @override
  Future<User> register({
    required String displayName,
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw StateError('Firebase no devolvió el usuario creado.');
    }

    await user.updateDisplayName(displayName.trim());

    await user.reload();

    return _firebaseAuth.currentUser ?? user;
  }

  @override
  Future<void> sendPasswordReset({required String email}) async {
    await _firebaseAuth.setLanguageCode('es');

    await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}
