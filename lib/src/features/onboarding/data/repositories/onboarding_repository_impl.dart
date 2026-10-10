import 'package:ahoruna/src/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:ahoruna/src/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  const OnboardingRepositoryImpl(this._localDataSource);

  final OnboardingLocalDataSource _localDataSource;

  @override
  Future<bool> isCompleted() {
    return _localDataSource.isCompleted();
  }

  @override
  Future<void> complete() {
    return _localDataSource.complete();
  }
}
