import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ahoruna/src/app/router/app_routes.dart';
import 'package:ahoruna/src/core/constants/app_constants.dart';
import 'package:ahoruna/src/core/extensions/theme_extensions.dart';
import 'package:ahoruna/src/features/startup/presentation/providers/startup_providers.dart';
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

  void _scheduleNavigation(StartupDestination destination) {
    if (_navigationScheduled) {
      return;
    }

    _navigationScheduled = true;

    Future<void>.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) {
        return;
      }

      switch (destination) {
        case StartupDestination.onboarding:
          context.go(AppRoutes.onboarding);

        case StartupDestination.login:
          context.go(AppRoutes.login);

        case StartupDestination.home:
          context.go(AppRoutes.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

    final destination = ref.watch(startupDestinationProvider);

    ref.listen(startupDestinationProvider, (previous, next) {
      next.whenData(_scheduleNavigation);
    });

    return Scaffold(
      body: SafeArea(
        child: destination.when(
          data: (_) {
            return _SplashContent(
              theme: theme,
              secondaryTextColor: colors.textSecondary,
              showProgress: true,
            );
          },
          loading: () {
            return _SplashContent(
              theme: theme,
              secondaryTextColor: colors.textSecondary,
            );
          },
          error: (error, stackTrace) {
            return Center(
              child: ErrorView(
                message: 'No pudimos iniciar Ahoruna.',
                onRetry: () {
                  _navigationScheduled = false;

                  ref.invalidate(startupDestinationProvider);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SplashContent extends StatelessWidget {
  const _SplashContent({
    required this.theme,
    required this.secondaryTextColor,
    this.showProgress = false,
  });

  final ThemeData theme;
  final Color secondaryTextColor;
  final bool showProgress;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AhorunaBrandMark(size: 92),
          const SizedBox(height: 24),
          Text(AppConstants.appName, style: theme.textTheme.headlineLarge),
          const SizedBox(height: 7),
          Text(
            AppConstants.appSlogan,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: secondaryTextColor,
            ),
          ),
          if (showProgress) ...[
            const SizedBox(height: 32),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2.4),
            ),
          ],
        ],
      ),
    );
  }
}
