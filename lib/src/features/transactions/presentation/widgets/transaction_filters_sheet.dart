import 'package:flutter/material.dart';

import 'package:ahoruna/src/app/theme/app_dimensions.dart';
import 'package:ahoruna/src/core/extensions/theme_extensions.dart';
import 'package:ahoruna/src/features/categories/domain/entities/finance_category.dart';
import 'package:ahoruna/src/features/transactions/domain/entities/transaction_filter.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_button.dart';

class TransactionFiltersSheet
    extends StatefulWidget {
  const TransactionFiltersSheet({
    required this.currentFilter,
    required this.categories,
    super.key,
  });

  final TransactionFilter currentFilter;
  final List<FinanceCategory> categories;

  @override
  State<TransactionFiltersSheet>
  createState() {
    return _TransactionFiltersSheetState();
  }
}

class _TransactionFiltersSheetState
    extends State<TransactionFiltersSheet> {
  static const String _allCategories =
      '__all_categories__';

  late TransactionTypeFilter _type;
  late String? _categoryId;
  late DateTime? _dateFrom;
  late DateTime? _dateTo;

  @override
  void initState() {
    super.initState();

    _type = widget.currentFilter.type;
    _categoryId =
        widget.currentFilter.categoryId;
    _dateFrom =
        widget.currentFilter.dateFrom;
    _dateTo =
        widget.currentFilter.dateTo;
  }

  List<FinanceCategory>
  get _availableCategories {
    return widget.categories.where(
          (category) {
        switch (_type) {
          case TransactionTypeFilter.all:
            return true;

          case TransactionTypeFilter.expense:
            return category.type ==
                CategoryType.expense ||
                category.type ==
                    CategoryType.both;

          case TransactionTypeFilter.income:
            return category.type ==
                CategoryType.income ||
                category.type ==
                    CategoryType.both;
        }
      },
    ).toList();
  }

  void _changeType(
      TransactionTypeFilter type,
      ) {
    setState(() {
      _type = type;

      if (_categoryId == null) {
        return;
      }

      final categoryStillAvailable =
      widget.categories.any(
            (category) {
          if (category.id != _categoryId) {
            return false;
          }

          switch (_type) {
            case TransactionTypeFilter.all:
              return true;

            case TransactionTypeFilter.expense:
              return category.type ==
                  CategoryType.expense ||
                  category.type ==
                      CategoryType.both;

            case TransactionTypeFilter.income:
              return category.type ==
                  CategoryType.income ||
                  category.type ==
                      CategoryType.both;
          }
        },
      );

      if (!categoryStillAvailable) {
        _categoryId = null;
      }
    });
  }

  void _setCurrentMonth() {
    final now = DateTime.now();

    setState(() {
      _dateFrom = DateTime(
        now.year,
        now.month,
        1,
      );

      _dateTo = DateTime(
        now.year,
        now.month,
        now.day,
      );
    });
  }

  void _setLast30Days() {
    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    setState(() {
      _dateFrom = today.subtract(
        const Duration(days: 29),
      );

      _dateTo = today;
    });
  }

  Future<void> _pickCustomRange() async {
    final now = DateTime.now();

    final today = DateTime(
      now.year,
      now.month,
      now.day,
    );

    DateTimeRange? initialRange;

    if (_dateFrom != null &&
        _dateTo != null) {
      initialRange = DateTimeRange(
        start: _dateFrom!,
        end: _dateTo!,
      );
    }

    final selected =
    await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: today,
      initialDateRange: initialRange,
      helpText:
      'Selecciona el período',
      cancelText: 'Cancelar',
      confirmText: 'Aplicar',
      saveText: 'Aplicar',
    );

    if (selected == null ||
        !mounted) {
      return;
    }

    setState(() {
      _dateFrom = selected.start;
      _dateTo = selected.end;
    });
  }

  void _clearDateRange() {
    setState(() {
      _dateFrom = null;
      _dateTo = null;
    });
  }

  void _resetAdvancedFilters() {
    setState(() {
      _type =
          TransactionTypeFilter.all;

      _categoryId = null;
      _dateFrom = null;
      _dateTo = null;
    });
  }

  void _apply() {
    Navigator.of(context).pop(
      TransactionFilter(
        query:
        widget.currentFilter.query,
        type: _type,
        categoryId: _categoryId,
        dateFrom: _dateFrom,
        dateTo: _dateTo,
      ),
    );
  }

  String _formatDate(
      DateTime date,
      ) {
    final day =
    date.day.toString().padLeft(
      2,
      '0',
    );

    final month =
    date.month.toString().padLeft(
      2,
      '0',
    );

    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

    final availableCategories =
        _availableCategories;

    final selectedDropdownValue =
        _categoryId ?? _allCategories;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppDimensions.pageHorizontalPadding,
          AppDimensions.spaceLg,
          AppDimensions.pageHorizontalPadding,
          AppDimensions.space2Xl +
              MediaQuery.viewInsetsOf(context)
                  .bottom,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Filtrar movimientos',
                    style: theme
                        .textTheme
                        .titleLarge,
                  ),
                ),
                IconButton(
                  tooltip: 'Cerrar',
                  onPressed: () {
                    Navigator.of(context)
                        .pop();
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: AppDimensions.spaceXl,
            ),
            Text(
              'Tipo',
              style:
              theme.textTheme.titleSmall,
            ),
            const SizedBox(
              height: AppDimensions.spaceSm,
            ),
            SegmentedButton<
                TransactionTypeFilter>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                  value:
                  TransactionTypeFilter
                      .all,
                  label: Text('Todos'),
                ),
                ButtonSegment(
                  value:
                  TransactionTypeFilter
                      .expense,
                  label: Text('Gastos'),
                ),
                ButtonSegment(
                  value:
                  TransactionTypeFilter
                      .income,
                  label: Text('Ingresos'),
                ),
              ],
              selected: {
                _type,
              },
              onSelectionChanged:
                  (selection) {
                _changeType(
                  selection.first,
                );
              },
            ),
            const SizedBox(
              height: AppDimensions.space2Xl,
            ),
            Text(
              'Categoría',
              style:
              theme.textTheme.titleSmall,
            ),
            const SizedBox(
              height: AppDimensions.spaceSm,
            ),
            DropdownButtonFormField<String>(
              key: ValueKey(
                '${_type.name}-'
                    '$selectedDropdownValue',
              ),
              initialValue:
              selectedDropdownValue,
              decoration:
              const InputDecoration(
                prefixIcon: Icon(
                  Icons.category_outlined,
                ),
              ),
              items: [
                const DropdownMenuItem(
                  value: _allCategories,
                  child: Text(
                    'Todas las categorías',
                  ),
                ),
                ...availableCategories.map(
                      (category) {
                    return DropdownMenuItem(
                      value: category.id,
                      child: Text(
                        category.name,
                      ),
                    );
                  },
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _categoryId =
                  value ==
                      _allCategories
                      ? null
                      : value;
                });
              },
            ),
            const SizedBox(
              height: AppDimensions.space2Xl,
            ),
            Text(
              'Período',
              style:
              theme.textTheme.titleSmall,
            ),
            const SizedBox(
              height: AppDimensions.spaceSm,
            ),
            Wrap(
              spacing:
              AppDimensions.spaceSm,
              runSpacing:
              AppDimensions.spaceSm,
              children: [
                OutlinedButton(
                  onPressed:
                  _setCurrentMonth,
                  child: const Text(
                    'Este mes',
                  ),
                ),
                OutlinedButton(
                  onPressed:
                  _setLast30Days,
                  child: const Text(
                    'Últimos 30 días',
                  ),
                ),
                OutlinedButton.icon(
                  onPressed:
                  _pickCustomRange,
                  icon: const Icon(
                    Icons.date_range_outlined,
                  ),
                  label: const Text(
                    'Elegir rango',
                  ),
                ),
              ],
            ),
            if (_dateFrom != null ||
                _dateTo != null) ...[
              const SizedBox(
                height:
                AppDimensions.spaceMd,
              ),
              Container(
                padding:
                const EdgeInsets.all(
                  AppDimensions.spaceMd,
                ),
                decoration: BoxDecoration(
                  color:
                  colors.surfaceSecondary,
                  borderRadius:
                  BorderRadius.circular(
                    AppDimensions
                        .radiusSmall,
                  ),
                  border: Border.all(
                    color: colors.border,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.event_outlined,
                      color:
                      theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _dateFrom != null &&
                            _dateTo != null
                            ? '${_formatDate(_dateFrom!)}'
                            ' - '
                            '${_formatDate(_dateTo!)}'
                            : 'Período seleccionado',
                        style: theme
                            .textTheme
                            .bodySmall,
                      ),
                    ),
                    IconButton(
                      tooltip:
                      'Quitar período',
                      onPressed:
                      _clearDateRange,
                      icon: const Icon(
                        Icons.close_rounded,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(
              height: AppDimensions.space3Xl,
            ),
            AhorunaButton(
              label: 'Aplicar filtros',
              icon:
              Icons.filter_alt_outlined,
              onPressed: _apply,
            ),
            const SizedBox(
              height: AppDimensions.spaceMd,
            ),
            AhorunaButton(
              label:
              'Restablecer filtros',
              variant:
              AhorunaButtonVariant.secondary,
              icon:
              Icons.restart_alt_rounded,
              onPressed:
              _resetAdvancedFilters,
            ),
          ],
        ),
      ),
    );
  }
}