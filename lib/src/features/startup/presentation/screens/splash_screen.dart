import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ahoruna/src/app/router/app_router.dart';
import 'package:ahoruna/src/core/constants/app_constants.dart';
import 'package:ahoruna/src/core/extensions/theme_extensions.dart';
import 'package:ahoruna/src/features/onboarding/presentation/providers/onboarding_providers.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_brand_mark.dart';
import 'package:ahoruna/src/shared/widgets/error_view.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _navigationScheduled = false;

  void _scheduleNavigation(bool onboardingCompleted) {
    if (_navigationScheduled) {
      return;
    }

    _navigationScheduled = true;

    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) {
        return;
      }

      context.go(onboardingCompleted ? AppRoutes.login : AppRoutes.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

    final onboardingStatus = ref.watch(onboardingCompletedProvider);

    ref.listen<AsyncValue<bool>>(onboardingCompletedProvider, (previous, next) {
      next.whenData(_scheduleNavigation);
    });

    return Scaffold(
      body: SafeArea(
        child: onboardingStatus.when(
          data: (_) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AhorunaBrandMark(size: 92),
                  const SizedBox(height: 24),
                  Text(
                    AppConstants.appName,
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 7),
                  Text(
                    AppConstants.appSlogan,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.4),
                  ),
                ],
              ),
            );
          },
          loading: () {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AhorunaBrandMark(size: 92),
                  const SizedBox(height: 24),
                  Text(
                    AppConstants.appName,
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 7),
                  Text(
                    AppConstants.appSlogan,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          },
          error: (error, stackTrace) {
            return Center(
              child: ErrorView(
                message: 'No pudimos iniciar Ahoruna correctamente.',
                onRetry: () {
                  _navigationScheduled = false;

                  ref.invalidate(onboardingCompletedProvider);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
