import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/features/auth/presentation/providers/auth_dependencies.dart';
import 'package:ahoruna/src/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:ahoruna/src/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:ahoruna/src/features/profile/domain/repositories/profile_repository.dart';
import 'package:ahoruna/src/features/profile/domain/usecases/get_profile.dart';
import 'package:ahoruna/src/features/profile/domain/usecases/update_display_name.dart';

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((
  ref,
) {
  return FirebaseProfileRemoteDataSource(
    ref.watch(firebaseAuthProvider),
    ref.watch(firebaseFirestoreProvider),
  );
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(ref.watch(profileRemoteDataSourceProvider));
});

final getProfileUseCaseProvider = Provider<GetProfile>((ref) {
  return GetProfile(ref.watch(profileRepositoryProvider));
});

final updateDisplayNameUseCaseProvider = Provider<UpdateDisplayName>((ref) {
  return UpdateDisplayName(ref.watch(profileRepositoryProvider));
});
