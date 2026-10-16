import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ahoruna/src/app/theme/app_dimensions.dart';
import 'package:ahoruna/src/core/extensions/theme_extensions.dart';
import 'package:ahoruna/src/core/utils/validators.dart';
import 'package:ahoruna/src/features/budgets/domain/entities/budget.dart';
import 'package:ahoruna/src/features/budgets/domain/failures/budget_failure.dart';
import 'package:ahoruna/src/features/budgets/domain/utils/budget_period_utils.dart';
import 'package:ahoruna/src/features/budgets/presentation/providers/budgets_providers.dart';
import 'package:ahoruna/src/features/budgets/presentation/utils/budget_visuals.dart';
import 'package:ahoruna/src/features/categories/domain/entities/finance_category.dart';
import 'package:ahoruna/src/features/categories/presentation/providers/categories_providers.dart';
import 'package:ahoruna/src/features/settings/presentation/providers/user_preferences_provider.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_app_bar.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_button.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_card.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_text_field.dart';
import 'package:ahoruna/src/shared/widgets/error_view.dart';
import 'package:ahoruna/src/shared/widgets/loading_view.dart';

class BudgetFormScreen extends ConsumerWidget {
  const BudgetFormScreen({this.budgetId, this.period, super.key});

  final String? budgetId;
  final String? period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (budgetId != null) {
      return _EditBudgetLoader(budgetId: budgetId!);
    }

    final resolvedPeriod = period ?? BudgetPeriodUtils.fromDate(DateTime.now());

    return _CreateBudgetLoader(period: resolvedPeriod);
  }
}

class _CreateBudgetLoader extends ConsumerWidget {
  const _CreateBudgetLoader({required this.period});

  final String period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(userPreferencesProvider);

    final categories = ref.watch(categoriesProvider);

    final budgets = ref.watch(budgetsForPeriodProvider(period));

    if (preferences.isLoading || categories.isLoading || budgets.isLoading) {
      return const Scaffold(
        body: LoadingView(message: 'Preparando presupuesto...'),
      );
    }

    if (preferences.hasError || categories.hasError || budgets.hasError) {
      return const Scaffold(
        body: Center(
          child: ErrorView(message: 'No pudimos preparar el presupuesto.'),
        ),
      );
    }

    return _BudgetEditorScaffold(
      period: period,
      currency: preferences.requireValue.currencyCode,
      defaultAlertPercent: preferences.requireValue.budgetAlertPercent,
      categories: categories.requireValue,
      existingBudgets: budgets.requireValue,
    );
  }
}

class _EditBudgetLoader extends ConsumerWidget {
  const _EditBudgetLoader({required this.budgetId});

  final String budgetId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budget = ref.watch(budgetByIdProvider(budgetId));

    return budget.when(
      loading: () {
        return const Scaffold(
          body: LoadingView(message: 'Cargando presupuesto...'),
        );
      },
      error: (error, stackTrace) {
        return const Scaffold(
          body: Center(
            child: ErrorView(message: 'No pudimos cargar el presupuesto.'),
          ),
        );
      },
      data: (value) {
        final categories = ref.watch(categoriesProvider);

        final budgets = ref.watch(budgetsForPeriodProvider(value.period));

        if (categories.isLoading || budgets.isLoading) {
          return const Scaffold(
            body: LoadingView(message: 'Preparando presupuesto...'),
          );
        }

        if (categories.hasError || budgets.hasError) {
          return const Scaffold(
            body: Center(
              child: ErrorView(message: 'No pudimos preparar el presupuesto.'),
            ),
          );
        }

        return _BudgetEditorScaffold(
          budget: value,
          period: value.period,
          currency: value.currency,
          defaultAlertPercent: value.alertPercent,
          categories: categories.requireValue,
          existingBudgets: budgets.requireValue,
        );
      },
    );
  }
}

class _BudgetEditorScaffold extends StatelessWidget {
  const _BudgetEditorScaffold({
    required this.period,
    required this.currency,
    required this.defaultAlertPercent,
    required this.categories,
    required this.existingBudgets,
    this.budget,
  });

  final Budget? budget;
  final String period;
  final String currency;
  final int defaultAlertPercent;

  final List<FinanceCategory> categories;

  final List<Budget> existingBudgets;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AhorunaAppBar(
        title: budget == null ? 'Nuevo presupuesto' : 'Editar presupuesto',
        showBackButton: true,
      ),
      body: _BudgetEditor(
        budget: budget,
        period: period,
        currency: currency,
        defaultAlertPercent: defaultAlertPercent,
        categories: categories,
        existingBudgets: existingBudgets,
      ),
    );
  }
}

class _BudgetEditor extends ConsumerStatefulWidget {
  const _BudgetEditor({
    required this.period,
    required this.currency,
    required this.defaultAlertPercent,
    required this.categories,
    required this.existingBudgets,
    this.budget,
  });

  final Budget? budget;
  final String period;
  final String currency;
  final int defaultAlertPercent;

  final List<FinanceCategory> categories;

  final List<Budget> existingBudgets;

  @override
  ConsumerState<_BudgetEditor> createState() {
    return _BudgetEditorState();
  }
}

class _BudgetEditorState extends ConsumerState<_BudgetEditor> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _limitController;

  String? _categoryId;
  late int _alertPercent;

  bool get _isEditing => widget.budget != null;

  @override
  void initState() {
    super.initState();

    _categoryId = widget.budget?.categoryId;

    _alertPercent = widget.budget?.alertPercent ?? widget.defaultAlertPercent;

    _limitController = TextEditingController(
      text: widget.budget == null
          ? ''
          : widget.budget!.limitAmount.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  List<FinanceCategory> get _availableCategories {
    return widget.categories.where((category) {
      if (!category.isActive) {
        return false;
      }

      if (category.type == CategoryType.income) {
        return false;
      }

      final hasAnotherBudget = widget.existingBudgets.any((budget) {
        if (budget.id == widget.budget?.id) {
          return false;
        }

        return budget.categoryId == category.id &&
            budget.currency.toUpperCase() == widget.currency.toUpperCase();
      });

      return !hasAnotherBudget;
    }).toList();
  }

  double _parseLimit() {
    return double.parse(_limitController.text.trim().replaceAll(',', '.'));
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final categoryId = _categoryId;

    if (categoryId == null) {
      _showError('Selecciona una categoría.');

      return;
    }

    try {
      final controller = ref.read(budgetsControllerProvider.notifier);

      if (_isEditing) {
        await controller.updateBudget(
          budgetId: widget.budget!.id,
          categoryId: categoryId,
          limitAmount: _parseLimit(),
          alertPercent: _alertPercent,
        );
      } else {
        await controller.createBudget(
          categoryId: categoryId,
          limitAmount: _parseLimit(),
          currency: widget.currency,
          period: widget.period,
          alertPercent: _alertPercent,
        );
      }

      if (!mounted) {
        return;
      }

      context.pop();
    } on BudgetFailure catch (error) {
      if (!mounted) {
        return;
      }

      _showError(error.message);
    }
  }

  Future<void> _delete() async {
    final budget = widget.budget;

    if (budget == null) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar presupuesto'),
          content: const Text(
            '¿Deseas eliminar este presupuesto? '
            'Los movimientos asociados no se eliminarán.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    try {
      await ref
          .read(budgetsControllerProvider.notifier)
          .deleteBudget(budget.id);

      if (!mounted) {
        return;
      }

      context.pop();
    } on BudgetFailure catch (error) {
      if (!mounted) {
        return;
      }

      _showError(error.message);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

    final controller = ref.watch(budgetsControllerProvider);

    final isLoading = controller.isLoading;

    final categories = _availableCategories;

    final selectedExists = categories.any(
      (category) => category.id == _categoryId,
    );

    final selectedCategoryId = selectedExists ? _categoryId : null;

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
                  AhorunaCard(
                    showShadow: false,
                    child: Column(
                      children: [
                        _InfoRow(
                          icon: Icons.calendar_month_outlined,
                          title: 'Período',
                          value: BudgetVisuals.monthLabel(widget.period),
                        ),
                        Divider(height: 28, color: colors.border),
                        _InfoRow(
                          icon: Icons.payments_outlined,
                          title: 'Moneda',
                          value: widget.currency,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  DropdownButtonFormField<String>(
                    initialValue: selectedCategoryId,
                    decoration: const InputDecoration(
                      labelText: 'Categoría',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    items: categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Selecciona una categoría.';
                      }

                      return null;
                    },
                    onChanged: isLoading
                        ? null
                        : (value) {
                            setState(() {
                              _categoryId = value;
                            });
                          },
                  ),
                  const SizedBox(height: 16),
                  AhorunaTextField(
                    label: 'Límite mensual',
                    hintText: '0.00',
                    controller: _limitController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.done,
                    prefixIcon: Icons.account_balance_wallet_outlined,
                    validator: Validators.budgetLimitAmount,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Avisarme al alcanzar',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<int>(
                    initialValue: _alertPercent,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.notifications_active_outlined),
                    ),
                    items: const [
                      DropdownMenuItem(value: 50, child: Text('50%')),
                      DropdownMenuItem(value: 60, child: Text('60%')),
                      DropdownMenuItem(value: 70, child: Text('70%')),
                      DropdownMenuItem(value: 80, child: Text('80%')),
                      DropdownMenuItem(value: 90, child: Text('90%')),
                      DropdownMenuItem(value: 100, child: Text('100%')),
                    ],
                    onChanged: isLoading
                        ? null
                        : (value) {
                            if (value == null) {
                              return;
                            }

                            setState(() {
                              _alertPercent = value;
                            });
                          },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Este porcentaje controla la alerta '
                    'visual del presupuesto.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 28),
                  AhorunaButton(
                    label: _isEditing ? 'Guardar cambios' : 'Crear presupuesto',
                    icon: _isEditing ? Icons.save_outlined : Icons.add_rounded,
                    isLoading: isLoading,
                    onPressed: isLoading ? null : _save,
                  ),
                  if (_isEditing) ...[
                    const SizedBox(height: 16),
                    AhorunaButton(
                      label: 'Eliminar presupuesto',
                      icon: Icons.delete_outline_rounded,
                      variant: AhorunaButtonVariant.danger,
                      isLoading: isLoading,
                      onPressed: isLoading ? null : _delete,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //final colors = context.ahorunaColors;

    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(child: Text(title, style: theme.textTheme.bodyMedium)),
        Text(value, style: theme.textTheme.labelLarge),
      ],
    );
  }
}
