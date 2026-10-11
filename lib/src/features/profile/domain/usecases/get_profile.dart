import 'package:ahoruna/src/features/profile/domain/entities/user_profile.dart';
import 'package:ahoruna/src/features/profile/domain/repositories/profile_repository.dart';

class GetProfile {
  const GetProfile(this._repository);

  final ProfileRepository _repository;

  Future<UserProfile> call() {
    return _repository.getProfile();
  }
}
