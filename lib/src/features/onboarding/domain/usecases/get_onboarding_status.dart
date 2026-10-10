import 'package:ahoruna/src/features/onboarding/domain/repositories/onboarding_repository.dart';

class GetOnboardingStatus {
  const GetOnboardingStatus(this._repository);

  final OnboardingRepository _repository;

  Future<bool> call() {
    return _repository.isCompleted();
  }
}
