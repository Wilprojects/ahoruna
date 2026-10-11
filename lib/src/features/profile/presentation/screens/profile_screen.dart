import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ahoruna/src/app/router/app_routes.dart';
import 'package:ahoruna/src/app/theme/app_colors.dart';
import 'package:ahoruna/src/app/theme/app_dimensions.dart';
import 'package:ahoruna/src/core/extensions/theme_extensions.dart';
import 'package:ahoruna/src/core/utils/validators.dart';
import 'package:ahoruna/src/features/profile/domain/entities/user_profile.dart';
import 'package:ahoruna/src/features/profile/domain/failures/profile_failure.dart';
import 'package:ahoruna/src/features/profile/presentation/providers/profile_provider.dart';
import 'package:ahoruna/src/features/profile/presentation/providers/profile_providers.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_app_bar.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_button.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_card.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_text_field.dart';
import 'package:ahoruna/src/shared/widgets/error_view.dart';
import 'package:ahoruna/src/shared/widgets/loading_view.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return Scaffold(
      appBar: AhorunaAppBar(
        title: 'Perfil',
        showBackButton: true,
        actions: [
          IconButton(
            tooltip: 'Configuración',
            onPressed: () {
              context.push(AppRoutes.settings);
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: profile.when(
        loading: () {
          return const LoadingView(message: 'Cargando tu perfil...');
        },
        error: (error, stackTrace) {
          return Center(
            child: ErrorView(
              message: 'No pudimos cargar tu perfil.',
              onRetry: () {
                ref.invalidate(profileProvider);
              },
            ),
          );
        },
        data: (value) {
          return _ProfileForm(key: ValueKey(value.displayName), profile: value);
        },
      ),
    );
  }
}

class _ProfileForm extends ConsumerStatefulWidget {
  const _ProfileForm({required this.profile, super.key});

  final UserProfile profile;

  @override
  ConsumerState<_ProfileForm> createState() {
    return _ProfileFormState();
  }
}

class _ProfileFormState extends ConsumerState<_ProfileForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.profile.displayName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      await ref
          .read(profileControllerProvider.notifier)
          .updateDisplayName(displayName: _nameController.text);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Perfil actualizado correctamente.')),
        );
    } on ProfileFailure catch (error) {
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

    final controller = ref.watch(profileControllerProvider);

    final isLoading = controller.isLoading;

    final initial = widget.profile.displayName.isNotEmpty
        ? widget.profile.displayName.substring(0, 1).toUpperCase()
        : 'A';

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.pageHorizontalPadding),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppDimensions.maxContentWidth,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: CircleAvatar(
                      radius: 42,
                      backgroundColor: colors.primarySoft,
                      child: Text(
                        initial,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.profile.displayName,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.profile.email,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 28),
                  AhorunaTextField(
                    label: 'Nombre',
                    hintText: 'Tu nombre',
                    controller: _nameController,
                    prefixIcon: Icons.person_outline_rounded,
                    validator: Validators.name,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 16),
                  AhorunaCard(
                    showShadow: false,
                    child: Row(
                      children: [
                        Icon(Icons.email_outlined, color: colors.textSecondary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Correo electrónico',
                                style: theme.textTheme.labelMedium,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                widget.profile.email,
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  AhorunaButton(
                    label: 'Guardar cambios',
                    icon: Icons.save_outlined,
                    isLoading: isLoading,
                    onPressed: isLoading ? null : _save,
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
