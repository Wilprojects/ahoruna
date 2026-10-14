import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/features/transactions/domain/entities/finance_transaction.dart';
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
