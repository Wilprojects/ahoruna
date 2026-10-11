import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:ahoruna/src/features/onboarding/presentation/providers/onboarding_providers.dart';

enum StartupDestination { onboarding, login, home }

final startupDestinationProvider = FutureProvider<StartupDestination>((
  ref,
) async {
  final onboardingCompleted = await ref.watch(
    onboardingCompletedProvider.future,
  );

  if (!onboardingCompleted) {
    return StartupDestination.onboarding;
  }

  final user = await ref.watch(authStateProvider.future);

  if (user == null) {
    return StartupDestination.login;
  }

  return StartupDestination.home;
});
