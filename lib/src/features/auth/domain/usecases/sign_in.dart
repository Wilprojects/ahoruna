import 'package:ahoruna/src/features/auth/domain/entities/auth_user.dart';
import 'package:ahoruna/src/features/auth/domain/repositories/auth_repository.dart';

class SignIn {
  const SignIn(this._repository);

  final AuthRepository _repository;

  Future<AuthUser> call({required String email, required String password}) {
    return _repository.signIn(email: email, password: password);
  }
}
