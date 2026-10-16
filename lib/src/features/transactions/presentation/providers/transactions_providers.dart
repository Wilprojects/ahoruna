import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/features/categories/domain/entities/finance_category.dart';
import 'package:ahoruna/src/features/categories/presentation/providers/categories_providers.dart';
import 'package:ahoruna/src/features/transactions/domain/entities/finance_transaction.dart';
import 'package:ahoruna/src/features/transactions/domain/entities/transaction_filter.dart';
import 'package:ahoruna/src/features/transactions/presentation/controllers/transaction_filter_controller.dart';
import 'package:ahoruna/src/features/transactions/presentation/controllers/transactions_controller.dart';
import 'package:ahoruna/src/features/transactions/presentation/providers/transactions_dependencies.dart';

final transactionsProvider =
    StreamProvider.autoDispose<List<FinanceTransaction>>((ref) {
      final watchTransactions = ref.watch(watchTransactionsUseCaseProvider);

      return watchTransactions();
    });

final transactionByIdProvider = FutureProvider.autoDispose
    .family<FinanceTransaction, String>((ref, transactionId) {
      final getTransaction = ref.watch(getTransactionUseCaseProvider);

      return getTransaction(transactionId);
    });

final transactionsControllerProvider =
    AsyncNotifierProvider<TransactionsController, void>(
      TransactionsController.new,
    );

final transactionFilterProvider =
    NotifierProvider<TransactionFilterController, TransactionFilter>(
      TransactionFilterController.new,
    );

final filteredTransactionsProvider =
    Provider.autoDispose<AsyncValue<List<FinanceTransaction>>>((ref) {
      final transactions = ref.watch(transactionsProvider);

      final categories = ref.watch(categoriesProvider);

      final filter = ref.watch(transactionFilterProvider);

      final filterTransactions = ref.watch(filterTransactionsUseCaseProvider);

      return transactions.when(
        loading: () {
          return const AsyncLoading();
        },
        error: (error, stackTrace) {
          return AsyncError(error, stackTrace);
        },
        data: (transactionValues) {
          return categories.when(
            loading: () {
              return const AsyncLoading();
            },
            error: (error, stackTrace) {
              return AsyncError(error, stackTrace);
            },
            data: (categoryValues) {
              final categoryNamesById = <String, String>{
                for (final FinanceCategory category in categoryValues)
                  category.id: category.name,
              };

              return AsyncData(
                filterTransactions(
                  transactions: transactionValues,
                  filter: filter,
                  categoryNamesById: categoryNamesById,
                ),
              );
            },
          );
        },
      );
    });
