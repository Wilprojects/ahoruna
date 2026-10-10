import 'package:flutter_test/flutter_test.dart';

import 'package:ahoruna/src/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:ahoruna/src/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:ahoruna/src/features/onboarding/domain/usecases/get_onboarding_status.dart';

void main() {
  group('Onboarding use cases', () {
    test('returns onboarding status from repository', () async {
      final repository = _FakeOnboardingRepository(completed: true);

      final useCase = GetOnboardingStatus(repository);

      final result = await useCase();

      expect(result, isTrue);
    });

    test('marks onboarding as completed', () async {
      final repository = _FakeOnboardingRepository();

      final useCase = CompleteOnboarding(repository);

      await useCase();

      expect(repository.completed, isTrue);
    });
  });
}

class _FakeOnboardingRepository implements OnboardingRepository {
  _FakeOnboardingRepository({this.completed = false});

  bool completed;

  @override
  Future<bool> isCompleted() async {
    return completed;
  }

  @override
  Future<void> complete() async {
    completed = true;
  }
}
