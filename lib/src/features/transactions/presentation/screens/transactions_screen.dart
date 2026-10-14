import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ahoruna/src/app/router/app_routes.dart';
import 'package:ahoruna/src/app/theme/app_dimensions.dart';
import 'package:ahoruna/src/core/extensions/theme_extensions.dart';
import 'package:ahoruna/src/features/categories/domain/entities/finance_category.dart';
import 'package:ahoruna/src/features/categories/presentation/providers/categories_providers.dart';
import 'package:ahoruna/src/features/transactions/domain/entities/finance_transaction.dart';
import 'package:ahoruna/src/features/transactions/presentation/providers/transactions_providers.dart';
import 'package:ahoruna/src/features/transactions/presentation/widgets/transaction_tile.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_app_bar.dart';
import 'package:ahoruna/src/shared/widgets/error_view.dart';
import 'package:ahoruna/src/shared/widgets/loading_view.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);

    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: const AhorunaAppBar(title: 'Movimientos', showBackButton: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(AppRoutes.transactionCreate);
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nuevo movimiento'),
      ),
      body: transactions.when(
        loading: () {
          return const LoadingView(message: 'Cargando movimientos...');
        },
        error: (error, stackTrace) {
          return Center(
            child: ErrorView(
              message: 'No pudimos cargar tus movimientos.',
              onRetry: () {
                ref.invalidate(transactionsProvider);
              },
            ),
          );
        },
        data: (transactionValues) {
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
            data: (categoryValues) {
              return _TransactionsContent(
                transactions: transactionValues,
                categories: categoryValues,
              );
            },
          );
        },
      ),
    );
  }
}

class _TransactionsContent extends StatelessWidget {
  const _TransactionsContent({
    required this.transactions,
    required this.categories,
  });

  final List<FinanceTransaction> transactions;

  final List<FinanceCategory> categories;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

    if (transactions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 58,
                color: colors.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                'Aún no tienes movimientos',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                'Registra tu primer ingreso o gasto '
                'para comenzar a organizar tus finanzas.',
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

    final categoriesById = <String, FinanceCategory>{
      for (final category in categories) category.id: category,
    };

    return SafeArea(
      top: false,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.pageHorizontalPadding,
          16,
          AppDimensions.pageHorizontalPadding,
          100,
        ),
        itemCount: transactions.length + 1,
        separatorBuilder: (context, index) {
          return const SizedBox(height: 10);
        },
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '${transactions.length} '
                '${transactions.length == 1 ? 'movimiento' : 'movimientos'}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            );
          }

          final transaction = transactions[index - 1];

          return TransactionTile(
            transaction: transaction,
            category: categoriesById[transaction.categoryId],
            onTap: () {
              context.push(AppRoutes.transactionEditPath(transaction.id));
            },
          );
        },
      ),
    );
  }
}
