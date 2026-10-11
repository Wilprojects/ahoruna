import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ahoruna/src/app/router/app_routes.dart';
import 'package:ahoruna/src/app/theme/ahoruna_colors.dart';
import 'package:ahoruna/src/app/theme/app_dimensions.dart';
import 'package:ahoruna/src/core/extensions/theme_extensions.dart';
import 'package:ahoruna/src/core/utils/validators.dart';
import 'package:ahoruna/src/features/auth/domain/failures/auth_failure.dart';
import 'package:ahoruna/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_button.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_card.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_text_field.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() {
    return _ForgotPasswordScreenState();
  }
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await ref
          .read(authControllerProvider.notifier)
          .sendPasswordReset(email: _emailController.text);

      if (!mounted) {
        return;
      }

      setState(() {
        _emailSent = true;
      });
    } on AuthFailure catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

    final authController = ref.watch(authControllerProvider);

    final isLoading = authController.isLoading;

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        top: false,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.pageHorizontalPadding),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppDimensions.maxContentWidth,
              ),
              child: _emailSent
                  ? _buildSuccess(theme, colors)
                  : _buildForm(theme, colors, isLoading),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(ThemeData theme, AhorunaColors colors, bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.lock_reset_rounded,
            size: 62,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'Recupera tu contraseña',
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Ingresa tu correo y te enviaremos '
            'instrucciones para recuperar tu acceso.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 28),
          AhorunaTextField(
            label: 'Correo electrónico',
            hintText: 'nombre@correo.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            prefixIcon: Icons.email_outlined,
            validator: Validators.email,
          ),
          const SizedBox(height: 24),
          AhorunaButton(
            label: 'Enviar instrucciones',
            icon: Icons.send_rounded,
            isLoading: isLoading,
            onPressed: isLoading ? null : _submit,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess(ThemeData theme, AhorunaColors colors) {
    return Column(
      children: [
        AhorunaCard(
          child: Column(
            children: [
              Icon(
                Icons.mark_email_read_rounded,
                size: 52,
                color: colors.income,
              ),
              const SizedBox(height: 18),
              Text('Revisa tu correo', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                'Enviamos las instrucciones de recuperación a ${_emailController.text.trim()}.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        AhorunaButton(
          label: 'Volver a iniciar sesión',
          onPressed: () {
            context.go(AppRoutes.login);
          },
        ),
      ],
    );
  }
}
