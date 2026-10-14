import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ahoruna/src/app/theme/app_dimensions.dart';
import 'package:ahoruna/src/core/extensions/theme_extensions.dart';
import 'package:ahoruna/src/core/utils/validators.dart';
import 'package:ahoruna/src/features/categories/domain/entities/finance_category.dart';
import 'package:ahoruna/src/features/categories/presentation/providers/categories_providers.dart';
import 'package:ahoruna/src/features/transactions/domain/entities/finance_transaction.dart';
import 'package:ahoruna/src/features/transactions/domain/failures/transaction_failure.dart';
import 'package:ahoruna/src/features/transactions/presentation/providers/transactions_providers.dart';
import 'package:ahoruna/src/features/transactions/presentation/utils/transaction_visuals.dart';
import 'package:ahoruna/src/features/settings/presentation/providers/user_preferences_provider.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_app_bar.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_button.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_card.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_text_field.dart';
import 'package:ahoruna/src/shared/widgets/error_view.dart';
import 'package:ahoruna/src/shared/widgets/loading_view.dart';

class TransactionFormScreen extends ConsumerWidget {
  const TransactionFormScreen({this.transactionId, super.key});

  final String? transactionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = transactionId != null;

    return Scaffold(
      appBar: AhorunaAppBar(
        title: isEditing ? 'Editar movimiento' : 'Nuevo movimiento',
        showBackButton: true,
      ),
      body: isEditing
          ? ref
                .watch(transactionByIdProvider(transactionId!))
                .when(
                  loading: () {
                    return const LoadingView(message: 'Cargando movimiento...');
                  },
                  error: (error, stackTrace) {
                    return Center(
                      child: ErrorView(
                        message: 'No pudimos cargar el movimiento.',
                        onRetry: () {
                          ref.invalidate(
                            transactionByIdProvider(transactionId!),
                          );
                        },
                      ),
                    );
                  },
                  data: (transaction) {
                    return _TransactionEditor(
                      key: ValueKey(transaction.id),
                      transaction: transaction,
                      currencyCode: transaction.currency,
                    );
                  },
                )
          : const _CreateTransactionLoader(),
    );
  }
}

class _CreateTransactionLoader extends ConsumerWidget {
  const _CreateTransactionLoader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(userPreferencesProvider);

    return preferences.when(
      loading: () {
        return const LoadingView(message: 'Preparando movimiento...');
      },
      error: (error, stackTrace) {
        return Center(
          child: ErrorView(
            message: 'No pudimos cargar tu moneda.',
            onRetry: () {
              ref.invalidate(userPreferencesProvider);
            },
          ),
        );
      },
      data: (value) {
        return _TransactionEditor(currencyCode: value.currencyCode);
      },
    );
  }
}

class _TransactionEditor extends ConsumerStatefulWidget {
  const _TransactionEditor({
    required this.currencyCode,
    this.transaction,
    super.key,
  });

  final String currencyCode;
  final FinanceTransaction? transaction;

  @override
  ConsumerState<_TransactionEditor> createState() {
    return _TransactionEditorState();
  }
}

class _TransactionEditorState extends ConsumerState<_TransactionEditor> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _amountController;

  late final TextEditingController _descriptionController;

  late final TextEditingController _noteController;

  late TransactionType _type;
  late DateTime _date;

  String? _categoryId;

  bool get _isEditing => widget.transaction != null;

  @override
  void initState() {
    super.initState();

    final transaction = widget.transaction;

    _amountController = TextEditingController(
      text: transaction == null ? '' : transaction.amount.toStringAsFixed(2),
    );

    _descriptionController = TextEditingController(
      text: transaction?.description ?? '',
    );

    _noteController = TextEditingController(text: transaction?.note ?? '');

    _type = transaction?.type ?? TransactionType.expense;

    _categoryId = transaction?.categoryId;

    _date = transaction?.date ?? DateTime.now();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _noteController.dispose();

    super.dispose();
  }

  double _parseAmount() {
    final normalized = _amountController.text.trim().replaceAll(',', '.');

    return double.parse(normalized);
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final selected = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: today,
    );

    if (selected == null || !mounted) {
      return;
    }

    setState(() {
      _date = selected;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final categoryId = _categoryId;

    if (categoryId == null) {
      return;
    }

    try {
      final controller = ref.read(transactionsControllerProvider.notifier);

      if (_isEditing) {
        await controller.updateTransaction(
          transactionId: widget.transaction!.id,
          type: _type,
          amount: _parseAmount(),
          currency: widget.currencyCode,
          description: _descriptionController.text,
          categoryId: categoryId,
          date: _date,
          note: _noteController.text,
        );
      } else {
        await controller.createTransaction(
          type: _type,
          amount: _parseAmount(),
          currency: widget.currencyCode,
          description: _descriptionController.text,
          categoryId: categoryId,
          date: _date,
          note: _noteController.text,
        );
      }

      if (!mounted) {
        return;
      }

      context.pop();
    } on TransactionFailure catch (error) {
      if (!mounted) {
        return;
      }

      _showError(error.message);
    }
  }

  Future<void> _delete() async {
    final transaction = widget.transaction;

    if (transaction == null) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar movimiento'),
          content: Text(
            '¿Deseas eliminar '
            '"${transaction.description}"? '
            'Esta acción no se puede deshacer.',
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
          .read(transactionsControllerProvider.notifier)
          .deleteTransaction(transaction.id);

      if (!mounted) {
        return;
      }

      context.pop();
    } on TransactionFailure catch (error) {
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

  bool _categorySupportsType(FinanceCategory category) {
    switch (_type) {
      case TransactionType.expense:
        return category.type == CategoryType.expense ||
            category.type == CategoryType.both;

      case TransactionType.income:
        return category.type == CategoryType.income ||
            category.type == CategoryType.both;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);

    final controller = ref.watch(transactionsControllerProvider);

    final isLoading = controller.isLoading;

    return categories.when(
      loading: () {
        return const LoadingView(message: 'Cargando categorías...');
      },
      error: (error, stackTrace) {
        return Center(
          child: ErrorView(
            message: 'No pudimos cargar las categorías.',
            onRetry: () {
              ref.invalidate(categoriesProvider);
            },
          ),
        );
      },
      data: (values) {
        return _buildForm(context, values, isLoading);
      },
    );
  }

  Widget _buildForm(
    BuildContext context,
    List<FinanceCategory> categories,
    bool isLoading,
  ) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

    final availableCategories = categories
        .where(_categorySupportsType)
        .toList();

    final selectedCategoryExists = availableCategories.any(
      (category) => category.id == _categoryId,
    );

    final selectedCategoryId = selectedCategoryExists ? _categoryId : null;

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
                  Text('Tipo de movimiento', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 10),
                  SegmentedButton<TransactionType>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(
                        value: TransactionType.expense,
                        icon: Icon(Icons.arrow_upward_rounded),
                        label: Text('Gasto'),
                      ),
                      ButtonSegment(
                        value: TransactionType.income,
                        icon: Icon(Icons.arrow_downward_rounded),
                        label: Text('Ingreso'),
                      ),
                    ],
                    selected: {_type},
                    onSelectionChanged: isLoading
                        ? null
                        : (selection) {
                            setState(() {
                              _type = selection.first;

                              _categoryId = null;
                            });
                          },
                  ),
                  const SizedBox(height: 24),
                  AhorunaTextField(
                    label: 'Monto',
                    hintText: '0.00',
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.payments_outlined,
                    validator: Validators.transactionAmount,
                  ),
                  const SizedBox(height: 16),
                  AhorunaCard(
                    showShadow: false,
                    child: Row(
                      children: [
                        const Icon(Icons.currency_exchange_rounded),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Moneda del movimiento',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                        Text(
                          widget.currencyCode,
                          style: theme.textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  AhorunaTextField(
                    label: 'Descripción',
                    hintText: 'Ej. Cena',
                    controller: _descriptionController,
                    textInputAction: TextInputAction.next,
                    prefixIcon: Icons.description_outlined,
                    validator: Validators.transactionDescription,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    key: ValueKey(_type),
                    initialValue: selectedCategoryId,
                    decoration: const InputDecoration(
                      labelText: 'Categoría',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    items: availableCategories.map((category) {
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
                  AhorunaCard(
                    showShadow: false,
                    onTap: isLoading ? null : _selectDate,
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Fecha', style: theme.textTheme.labelMedium),
                              const SizedBox(height: 3),
                              Text(TransactionVisuals.formatDate(_date)),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: colors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _noteController,
                    maxLines: 3,
                    validator: Validators.transactionNote,
                    decoration: const InputDecoration(
                      labelText: 'Nota opcional',
                      hintText: 'Agrega algún detalle adicional',
                      prefixIcon: Icon(Icons.notes_rounded),
                    ),
                  ),
                  const SizedBox(height: 28),
                  AhorunaButton(
                    label: _isEditing
                        ? 'Guardar cambios'
                        : 'Registrar movimiento',
                    icon: _isEditing ? Icons.save_outlined : Icons.add_rounded,
                    isLoading: isLoading,
                    onPressed: isLoading ? null : _save,
                  ),
                  if (_isEditing) ...[
                    const SizedBox(height: 16),
                    AhorunaButton(
                      label: 'Eliminar movimiento',
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
