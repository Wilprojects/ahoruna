import 'package:ahoruna/src/features/profile/domain/repositories/profile_repository.dart';

class UpdateDisplayName {
  const UpdateDisplayName(this._repository);

  final ProfileRepository _repository;

  Future<void> call({required String displayName}) {
    return _repository.updateDisplayName(displayName: displayName);
  }
}
