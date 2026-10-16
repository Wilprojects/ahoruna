import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ahoruna/src/app/router/app_routes.dart';
import 'package:ahoruna/src/app/theme/app_dimensions.dart';
import 'package:ahoruna/src/core/extensions/theme_extensions.dart';
import 'package:ahoruna/src/features/categories/domain/entities/finance_category.dart';
import 'package:ahoruna/src/features/categories/presentation/providers/categories_providers.dart';
import 'package:ahoruna/src/features/transactions/domain/entities/finance_transaction.dart';
import 'package:ahoruna/src/features/transactions/domain/entities/transaction_filter.dart';
import 'package:ahoruna/src/features/transactions/presentation/providers/transactions_providers.dart';
import 'package:ahoruna/src/features/transactions/presentation/utils/transaction_visuals.dart';
import 'package:ahoruna/src/features/transactions/presentation/widgets/transaction_filters_sheet.dart';
import 'package:ahoruna/src/features/transactions/presentation/widgets/transaction_tile.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_app_bar.dart';
import 'package:ahoruna/src/shared/widgets/error_view.dart';
import 'package:ahoruna/src/shared/widgets/loading_view.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() {
    return _TransactionsScreenState();
  }
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();

    final filter = ref.read(transactionFilterProvider);

    _searchController = TextEditingController(text: filter.query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openFilters(List<FinanceCategory> categories) async {
    final currentFilter = ref.read(transactionFilterProvider);

    final result = await showModalBottomSheet<TransactionFilter>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return TransactionFiltersSheet(
          currentFilter: currentFilter,
          categories: categories,
        );
      },
    );

    if (result == null || !mounted) {
      return;
    }

    ref.read(transactionFilterProvider.notifier).applyAdvancedFilters(result);
  }

  void _clearAllFilters() {
    _searchController.clear();

    ref.read(transactionFilterProvider.notifier).clearAll();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTransactions = ref.watch(filteredTransactionsProvider);

    final categories = ref.watch(categoriesProvider);

    final filter = ref.watch(transactionFilterProvider);

    final categoryValues = categories.when(
      data: (values) => values,
      loading: () => const <FinanceCategory>[],
      error: (error, stackTrace) => const <FinanceCategory>[],
    );

    final categoriesById = <String, FinanceCategory>{
      for (final category in categoryValues) category.id: category,
    };

    return Scaffold(
      appBar: const AhorunaAppBar(title: 'Movimientos', showBackButton: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(AppRoutes.transactionCreate);
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nuevo movimiento'),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.pageHorizontalPadding,
                AppDimensions.spaceMd,
                AppDimensions.pageHorizontalPadding,
                AppDimensions.spaceSm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'Buscar movimientos...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: filter.query.isEmpty
                            ? null
                            : IconButton(
                                tooltip: 'Limpiar búsqueda',
                                onPressed: () {
                                  _searchController.clear();

                                  ref
                                      .read(transactionFilterProvider.notifier)
                                      .setQuery('');
                                },
                                icon: const Icon(Icons.close_rounded),
                              ),
                      ),
                      onChanged: (value) {
                        ref
                            .read(transactionFilterProvider.notifier)
                            .setQuery(value);
                      },
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceSm),
                  _FilterButton(
                    activeCount: filter.activeAdvancedFilterCount,
                    onPressed: () {
                      _openFilters(categoryValues);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.pageHorizontalPadding,
                4,
                AppDimensions.pageHorizontalPadding,
                AppDimensions.spaceSm,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: filteredTransactions.when(
                      loading: () {
                        return const Text('Buscando...');
                      },
                      error: (error, stackTrace) {
                        return const Text(
                          'No se pudieron obtener los resultados.',
                        );
                      },
                      data: (values) {
                        return Text(
                          '${values.length} '
                          '${values.length == 1 ? 'resultado' : 'resultados'}',
                        );
                      },
                    ),
                  ),
                  if (filter.hasAnyFilters)
                    TextButton(
                      onPressed: _clearAllFilters,
                      child: const Text('Limpiar'),
                    ),
                ],
              ),
            ),
            Expanded(
              child: filteredTransactions.when(
                loading: () {
                  return const LoadingView(message: 'Cargando movimientos...');
                },
                error: (error, stackTrace) {
                  return Center(
                    child: ErrorView(
                      message: 'No pudimos cargar tus movimientos.',
                      onRetry: () {
                        ref.invalidate(transactionsProvider);

                        ref.invalidate(categoriesProvider);
                      },
                    ),
                  );
                },
                data: (values) {
                  if (values.isEmpty) {
                    return _EmptyHistory(hasFilters: filter.hasAnyFilters);
                  }

                  return _TransactionsHistory(
                    transactions: values,
                    categoriesById: categoriesById,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({required this.activeCount, required this.onPressed});

  final int activeCount;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(54, 54),
        padding: const EdgeInsets.symmetric(horizontal: 14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.filter_alt_outlined),
          if (activeCount > 0) ...[
            const SizedBox(width: 6),
            Container(
              constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
              padding: const EdgeInsets.symmetric(horizontal: 6),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$activeCount',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TransactionsHistory extends StatelessWidget {
  const _TransactionsHistory({
    required this.transactions,
    required this.categoriesById,
  });

  final List<FinanceTransaction> transactions;

  final Map<String, FinanceCategory> categoriesById;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

    final widgets = <Widget>[];

    DateTime? currentGroupDate;

    for (final transaction in transactions) {
      final transactionDay = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      );

      final isNewGroup =
          currentGroupDate == null || transactionDay != currentGroupDate;

      if (isNewGroup) {
        if (widgets.isNotEmpty) {
          widgets.add(const SizedBox(height: AppDimensions.spaceMd));
        }

        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: Text(
              TransactionVisuals.historyDateLabel(transaction.date)
                  .toUpperCase(),
              style: theme.textTheme.labelMedium?.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );

        currentGroupDate = transactionDay;
      }

      widgets.add(
        TransactionTile(
          transaction: transaction,
          category: categoriesById[transaction.categoryId],
          onTap: () {
            context.push(AppRoutes.transactionEditPath(transaction.id));
          },
        ),
      );

      widgets.add(const SizedBox(height: 10));
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.pageHorizontalPadding,
        AppDimensions.spaceSm,
        AppDimensions.pageHorizontalPadding,
        110,
      ),
      children: widgets,
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory({required this.hasFilters});

  final bool hasFilters;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasFilters
                  ? Icons.search_off_rounded
                  : Icons.receipt_long_outlined,
              size: 58,
              color: colors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              hasFilters
                  ? 'No encontramos movimientos'
                  : 'Aún no tienes movimientos',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 7),
            Text(
              hasFilters
                  ? 'Prueba con otra búsqueda o modifica los filtros aplicados.'
                  : 'Registra tu primer ingreso o gasto para comenzar a organizar tus finanzas.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
