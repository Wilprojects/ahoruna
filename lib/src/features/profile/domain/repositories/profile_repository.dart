import 'package:ahoruna/src/features/profile/domain/entities/user_profile.dart';

abstract interface class ProfileRepository {
  Future<UserProfile> getProfile();

  Future<void> updateDisplayName({required String displayName});
}
