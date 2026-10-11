import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ahoruna/src/app/router/app_routes.dart';
import 'package:ahoruna/src/app/theme/app_dimensions.dart';
import 'package:ahoruna/src/app/theme/app_gradients.dart';
import 'package:ahoruna/src/core/extensions/theme_extensions.dart';
import 'package:ahoruna/src/features/auth/domain/failures/auth_failure.dart';
import 'package:ahoruna/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_app_bar.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_button.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

    final authState = ref.watch(authStateProvider);

    final user = authState.when(
      data: (value) => value,
      loading: () => null,
      error: (error, stackTrace) => null,
    );

    final displayName = user?.displayName?.trim();

    final firstName = displayName != null && displayName.isNotEmpty
        ? displayName.split(RegExp(r'\s+')).first
        : null;

    final authController = ref.watch(authControllerProvider);

    final isLoading = authController.isLoading;

    return Scaffold(
      appBar: AhorunaAppBar(
        title: 'Ahoruna',
        actions: [
          IconButton(
            tooltip: 'Perfil',
            onPressed: () {
              context.push(AppRoutes.profile);
            },
            icon: const Icon(Icons.person_outline_rounded),
          ),
          IconButton(
            tooltip: 'Configuración',
            onPressed: () {
              context.push(AppRoutes.settings);
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.pageHorizontalPadding,
            AppDimensions.spaceMd,
            AppDimensions.pageHorizontalPadding,
            AppDimensions.space3Xl,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppDimensions.maxContentWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    firstName == null ? 'Hola 👋' : 'Hola, $firstName 👋',
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppDimensions.spaceXs),
                  Text(
                    'Tus finanzas, más simples.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space2Xl),
                  AhorunaCard(
                    gradient: AppGradients.balance,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Balance disponible',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spaceXs),
                        Text(
                          'S/ 0.00',
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.space2Xl),
                        Text(
                          'Tus datos financieros aparecerán '
                          'aquí en las próximas fases.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceXl),
                  AhorunaCard(
                    showShadow: false,
                    child: Column(
                      children: [
                        Icon(
                          Icons.route_rounded,
                          size: 36,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: AppDimensions.spaceMd),
                        Text(
                          'Navegación inicial lista',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Splash, onboarding y acceso '
                          'inicial ya se encuentran conectados.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space2Xl),
                  AhorunaButton(
                    label: 'Cerrar sesión',
                    variant: AhorunaButtonVariant.secondary,
                    icon: Icons.logout_rounded,
                    isLoading: isLoading,
                    onPressed: isLoading
                        ? null
                        : () async {
                            try {
                              await ref
                                  .read(authControllerProvider.notifier)
                                  .signOut();

                              if (!context.mounted) {
                                return;
                              }

                              context.go(AppRoutes.login);
                            } on AuthFailure catch (error) {
                              if (!context.mounted) {
                                return;
                              }

                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(content: Text(error.message)),
                                );
                            }
                          },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
