import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ahoruna/src/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:ahoruna/src/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:ahoruna/src/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:ahoruna/src/features/onboarding/domain/usecases/complete_onboarding.dart';
import 'package:ahoruna/src/features/onboarding/domain/usecases/get_onboarding_status.dart';

final sharedPreferencesAsyncProvider = Provider<SharedPreferencesAsync>((ref) {
  return SharedPreferencesAsync();
});

final onboardingLocalDataSourceProvider = Provider<OnboardingLocalDataSource>((
  ref,
) {
  return OnboardingLocalDataSourceImpl(
    ref.watch(sharedPreferencesAsyncProvider),
  );
});

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepositoryImpl(ref.watch(onboardingLocalDataSourceProvider));
});

final getOnboardingStatusProvider = Provider<GetOnboardingStatus>((ref) {
  return GetOnboardingStatus(ref.watch(onboardingRepositoryProvider));
});

final completeOnboardingUseCaseProvider = Provider<CompleteOnboarding>((ref) {
  return CompleteOnboarding(ref.watch(onboardingRepositoryProvider));
});

final onboardingCompletedProvider = FutureProvider<bool>((ref) async {
  final getOnboardingStatus = ref.watch(getOnboardingStatusProvider);

  return getOnboardingStatus();
});
