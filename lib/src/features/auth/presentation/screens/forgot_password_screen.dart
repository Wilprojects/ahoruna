import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ahoruna/src/app/router/app_router.dart';
import 'package:ahoruna/src/app/theme/app_dimensions.dart';
import 'package:ahoruna/src/core/extensions/theme_extensions.dart';
import 'package:ahoruna/src/core/utils/validators.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_button.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_card.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_text_field.dart';
import 'package:ahoruna/src/app/theme/ahoruna_colors.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() {
    return _ForgotPasswordScreenState();
  }
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _emailSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

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
                  : _buildForm(theme, colors),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(ThemeData theme, AhorunaColors colors) {
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
            onPressed: _submit,
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
                'Enviamos las instrucciones de recuperación '
                'a ${_emailController.text.trim()}.',
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
