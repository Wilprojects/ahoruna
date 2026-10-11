import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ahoruna/src/features/auth/data/datasources/user_profile_remote_data_source.dart';
import 'package:ahoruna/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:ahoruna/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:ahoruna/src/features/auth/domain/usecases/register_user.dart';
import 'package:ahoruna/src/features/auth/domain/usecases/send_password_reset.dart';
import 'package:ahoruna/src/features/auth/domain/usecases/sign_in.dart';
import 'package:ahoruna/src/features/auth/domain/usecases/sign_out.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return FirebaseAuthRemoteDataSource(ref.watch(firebaseAuthProvider));
});

final userProfileRemoteDataSourceProvider =
    Provider<UserProfileRemoteDataSource>((ref) {
      return FirestoreUserProfileRemoteDataSource(
        ref.watch(firebaseFirestoreProvider),
      );
    });

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(userProfileRemoteDataSourceProvider),
  );
});

final signInUseCaseProvider = Provider<SignIn>((ref) {
  return SignIn(ref.watch(authRepositoryProvider));
});

final registerUserUseCaseProvider = Provider<RegisterUser>((ref) {
  return RegisterUser(ref.watch(authRepositoryProvider));
});

final sendPasswordResetUseCaseProvider = Provider<SendPasswordReset>((ref) {
  return SendPasswordReset(ref.watch(authRepositoryProvider));
});

final signOutUseCaseProvider = Provider<SignOut>((ref) {
  return SignOut(ref.watch(authRepositoryProvider));
});
