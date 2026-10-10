import 'package:ahoruna/src/features/onboarding/domain/repositories/onboarding_repository.dart';

class CompleteOnboarding {
  const CompleteOnboarding(this._repository);

  final OnboardingRepository _repository;

  Future<void> call() {
    return _repository.complete();
  }
}
