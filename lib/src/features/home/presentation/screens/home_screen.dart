import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ahoruna/src/app/router/app_router.dart';
import 'package:ahoruna/src/app/theme/app_gradients.dart';
import 'package:ahoruna/src/core/extensions/theme_extensions.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_app_bar.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_button.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

    return Scaffold(
      appBar: const AhorunaAppBar(title: 'Ahoruna'),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Hola 👋', style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 5),
                  Text(
                    'Tus finanzas, más simples.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
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
                        const SizedBox(height: 5),
                        Text(
                          'S/ 0.00',
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 22),
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
                  const SizedBox(height: 20),
                  AhorunaCard(
                    showShadow: false,
                    child: Column(
                      children: [
                        Icon(
                          Icons.route_rounded,
                          size: 36,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 12),
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
                  const SizedBox(height: 24),
                  AhorunaButton(
                    label: 'Cerrar sesión',
                    variant: AhorunaButtonVariant.secondary,
                    icon: Icons.logout_rounded,
                    onPressed: () {
                      context.go(AppRoutes.login);
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
