import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/app/theme/app_colors.dart';
import 'package:ahoruna/src/app/theme/app_gradients.dart';
import 'package:ahoruna/src/app/theme/theme_mode_provider.dart';
import 'package:ahoruna/src/core/constants/app_constants.dart';
import 'package:ahoruna/src/core/extensions/theme_extensions.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_app_bar.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_bottom_navigation_bar.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_brand_mark.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_button.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_card.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_text_field.dart';
import 'package:ahoruna/src/shared/widgets/empty_view.dart';
import 'package:ahoruna/src/shared/widgets/error_view.dart';
import 'package:ahoruna/src/shared/widgets/loading_view.dart';

enum _PreviewState { loading, empty, error }

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _descriptionController = TextEditingController();

  int _navigationIndex = 0;
  _PreviewState _previewState = _PreviewState.loading;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: const AhorunaAppBar(title: 'Sistema visual'),
      bottomNavigationBar: AhorunaBottomNavigationBar(
        currentIndex: _navigationIndex,
        onTap: (index) {
          setState(() {
            _navigationIndex = index;
          });
        },
      ),
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
                  const SizedBox(height: 12),

                  const AhorunaBrandMark(),

                  const SizedBox(height: 18),

                  Text(
                    AppConstants.appName,
                    style: theme.textTheme.headlineLarge,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    AppConstants.appSlogan,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 28),

                  Text('Apariencia', style: theme.textTheme.titleMedium),

                  const SizedBox(height: 10),

                  _ThemeSelector(
                    selectedMode: themeMode,
                    onChanged: (mode) {
                      ref.read(themeModeProvider.notifier).setThemeMode(mode);
                    },
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Tarjeta financiera',
                    style: theme.textTheme.titleMedium,
                  ),

                  const SizedBox(height: 10),

                  AhorunaCard(
                    gradient: AppGradients.balance,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Balance disponible',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.76),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'S/ 4,280.50',
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(
                              child: _FinancialStat(
                                title: 'Ingresos',
                                value: 'S/ 6,250',
                                icon: Icons.arrow_downward_rounded,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _FinancialStat(
                                title: 'Gastos',
                                value: 'S/ 1,969.50',
                                icon: Icons.arrow_upward_rounded,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text('Botones', style: theme.textTheme.titleMedium),

                  const SizedBox(height: 10),

                  AhorunaButton(
                    label: 'Acción principal',
                    icon: Icons.add_rounded,
                    onPressed: () {
                      _showMessage('Botón principal funcionando.');
                    },
                  ),

                  const SizedBox(height: 10),

                  AhorunaButton(
                    label: 'Acción secundaria',
                    variant: AhorunaButtonVariant.secondary,
                    onPressed: () {
                      _showMessage('Botón secundario funcionando.');
                    },
                  ),

                  const SizedBox(height: 10),

                  AhorunaButton(
                    label: 'Acción suave',
                    variant: AhorunaButtonVariant.soft,
                    onPressed: () {
                      _showMessage('Botón suave funcionando.');
                    },
                  ),

                  const SizedBox(height: 10),

                  AhorunaButton(
                    label: 'Acción de peligro',
                    variant: AhorunaButtonVariant.danger,
                    onPressed: () {
                      _showMessage('Botón de peligro funcionando.');
                    },
                  ),

                  const SizedBox(height: 24),

                  Text('Campos', style: theme.textTheme.titleMedium),

                  const SizedBox(height: 10),

                  AhorunaTextField(
                    label: 'Descripción',
                    hintText: 'Ej. Compra en supermercado',
                    prefixIcon: Icons.edit_note_rounded,
                    controller: _descriptionController,
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Estados de interfaz',
                    style: theme.textTheme.titleMedium,
                  ),

                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _PreviewChip(
                        label: 'Cargando',
                        selected: _previewState == _PreviewState.loading,
                        onTap: () {
                          setState(() {
                            _previewState = _PreviewState.loading;
                          });
                        },
                      ),
                      _PreviewChip(
                        label: 'Vacío',
                        selected: _previewState == _PreviewState.empty,
                        onTap: () {
                          setState(() {
                            _previewState = _PreviewState.empty;
                          });
                        },
                      ),
                      _PreviewChip(
                        label: 'Error',
                        selected: _previewState == _PreviewState.error,
                        onTap: () {
                          setState(() {
                            _previewState = _PreviewState.error;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  AhorunaCard(
                    showShadow: false,
                    child: SizedBox(
                      height: 190,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        child: _buildPreviewState(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  AhorunaCard(
                    showShadow: false,
                    child: Text(
                      'Esta pantalla es temporal. '
                      'Sirve para validar el sistema visual '
                      'antes de construir las pantallas '
                      'funcionales de Ahoruna.',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewState() {
    switch (_previewState) {
      case _PreviewState.loading:
        return const LoadingView(
          key: ValueKey('loading'),
          message: 'Cargando tus finanzas...',
        );

      case _PreviewState.empty:
        return const Center(
          key: ValueKey('empty'),
          child: EmptyView(
            title: 'Sin movimientos',
            message: 'Tus ingresos y gastos aparecerán aquí.',
            icon: Icons.receipt_long_rounded,
          ),
        );

      case _PreviewState.error:
        return Center(
          key: const ValueKey('error'),
          child: ErrorView(
            message: 'No pudimos cargar la información.',
            onRetry: () {
              setState(() {
                _previewState = _PreviewState.loading;
              });
            },
          ),
        );
    }
  }
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector({required this.selectedMode, required this.onChanged});

  final ThemeMode selectedMode;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.ahorunaColors;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surfaceSecondary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ThemeOption(
              label: 'Sistema',
              icon: Icons.settings_brightness_rounded,
              selected: selectedMode == ThemeMode.system,
              onTap: () {
                onChanged(ThemeMode.system);
              },
            ),
          ),
          Expanded(
            child: _ThemeOption(
              label: 'Claro',
              icon: Icons.light_mode_rounded,
              selected: selectedMode == ThemeMode.light,
              onTap: () {
                onChanged(ThemeMode.light);
              },
            ),
          ),
          Expanded(
            child: _ThemeOption(
              label: 'Oscuro',
              icon: Icons.dark_mode_rounded,
              selected: selectedMode == ThemeMode.dark,
              onTap: () {
                onChanged(ThemeMode.dark);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

    return Material(
      color: selected ? theme.colorScheme.surface : Colors.transparent,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          child: Column(
            children: [
              Icon(
                icon,
                size: 19,
                color: selected ? AppColors.primary : colors.textSecondary,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: selected ? AppColors.primary : colors.textSecondary,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewChip extends StatelessWidget {
  const _PreviewChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

    return Material(
      color: selected ? colors.primarySoft : theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? AppColors.primary : colors.border,
            ),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: selected ? AppColors.primary : colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _FinancialStat extends StatelessWidget {
  const _FinancialStat({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(height: 6),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.76),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: theme.textTheme.labelLarge?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
