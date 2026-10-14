import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/features/transactions/domain/entities/finance_transaction.dart';
import 'package:ahoruna/src/features/transactions/presentation/providers/transactions_dependencies.dart';

class TransactionsController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> createTransaction({
    required TransactionType type,
    required double amount,
    required String currency,
    required String description,
    required String categoryId,
    required DateTime date,
    String? note,
  }) {
    return _execute(() async {
      await ref.read(createTransactionUseCaseProvider)(
        type: type,
        amount: amount,
        currency: currency,
        description: description,
        categoryId: categoryId,
        date: date,
        note: note,
      );
    });
  }

  Future<void> updateTransaction({
    required String transactionId,
    required TransactionType type,
    required double amount,
    required String currency,
    required String description,
    required String categoryId,
    required DateTime date,
    String? note,
  }) {
    return _execute(() async {
      await ref.read(updateTransactionUseCaseProvider)(
        transactionId: transactionId,
        type: type,
        amount: amount,
        currency: currency,
        description: description,
        categoryId: categoryId,
        date: date,
        note: note,
      );
    });
  }

  Future<void> deleteTransaction(String transactionId) {
    return _execute(() async {
      await ref.read(deleteTransactionUseCaseProvider)(transactionId);
    });
  }

  Future<void> _execute(Future<void> Function() action) async {
    state = const AsyncLoading();

    try {
      await action();

      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);

      rethrow;
    }
  }
}
