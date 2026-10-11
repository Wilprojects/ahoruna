import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ahoruna/src/app/router/app_routes.dart';
import 'package:ahoruna/src/app/theme/app_dimensions.dart';
import 'package:ahoruna/src/core/extensions/theme_extensions.dart';
import 'package:ahoruna/src/features/auth/domain/failures/auth_failure.dart';
import 'package:ahoruna/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_app_bar.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_button.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_card.dart';
import 'package:ahoruna/src/shared/widgets/error_view.dart';
import 'package:ahoruna/src/shared/widgets/loading_view.dart';

class SecurityScreen extends ConsumerWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    final controller = ref.watch(authControllerProvider);

    final isLoading = controller.isLoading;

    return Scaffold(
      appBar: const AhorunaAppBar(title: 'Seguridad', showBackButton: true),
      body: authState.when(
        loading: () {
          return const LoadingView(message: 'Cargando información...');
        },
        error: (error, stackTrace) {
          return const Center(
            child: ErrorView(
              message: 'No pudimos cargar la información de seguridad.',
            ),
          );
        },
        data: (user) {
          if (user == null) {
            return const Center(
              child: ErrorView(message: 'No existe una sesión activa.'),
            );
          }

          final email = user.email ?? '';

          return SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.all(
                AppDimensions.pageHorizontalPadding,
              ),
              children: [
                AhorunaCard(
                  showShadow: false,
                  child: Row(
                    children: [
                      const Icon(Icons.email_outlined),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Correo de acceso',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              email,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Contraseña',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  'Ahoruna no almacena tu contraseña. '
                  'Puedes solicitar un enlace seguro '
                  'para cambiarla.',
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: context.ahorunaColors.textSecondary),
                ),
                const SizedBox(height: 16),
                AhorunaButton(
                  label: 'Enviar enlace para cambiar contraseña',
                  icon: Icons.lock_reset_rounded,
                  variant: AhorunaButtonVariant.secondary,
                  isLoading: isLoading,
                  onPressed: isLoading || email.isEmpty
                      ? null
                      : () async {
                          try {
                            await ref
                                .read(authControllerProvider.notifier)
                                .sendPasswordReset(email: email);

                            if (!context.mounted) {
                              return;
                            }

                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Te enviamos un correo para cambiar tu contraseña.',
                                  ),
                                ),
                              );
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
                const SizedBox(height: 32),
                AhorunaButton(
                  label: 'Cerrar sesión',
                  icon: Icons.logout_rounded,
                  variant: AhorunaButtonVariant.danger,
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

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error.message)),
                            );
                          }
                        },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
