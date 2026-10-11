import 'package:firebase_core/firebase_core.dart';

import 'package:ahoruna/src/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:ahoruna/src/features/profile/domain/entities/user_profile.dart';
import 'package:ahoruna/src/features/profile/domain/failures/profile_failure.dart';
import 'package:ahoruna/src/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<UserProfile> getProfile() async {
    try {
      return await _remoteDataSource.getProfile();
    } on StateError {
      throw const ProfileFailure('No existe una sesión activa.');
    } on FirebaseException {
      throw const ProfileFailure('No pudimos cargar tu perfil.');
    }
  }

  @override
  Future<void> updateDisplayName({required String displayName}) async {
    try {
      await _remoteDataSource.updateDisplayName(displayName: displayName);
    } on StateError {
      throw const ProfileFailure('No existe una sesión activa.');
    } on FirebaseException {
      throw const ProfileFailure('No pudimos actualizar tu perfil.');
    }
  }
}
