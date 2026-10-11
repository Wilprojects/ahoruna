import 'package:ahoruna/src/features/auth/domain/repositories/auth_repository.dart';

class SendPasswordReset {
  const SendPasswordReset(this._repository);

  final AuthRepository _repository;

  Future<void> call({required String email}) {
    return _repository.sendPasswordReset(email: email);
  }
}
