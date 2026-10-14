import 'package:flutter_test/flutter_test.dart';

import 'package:ahoruna/src/features/transactions/domain/entities/finance_transaction.dart';
import 'package:ahoruna/src/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:ahoruna/src/features/transactions/domain/usecases/create_transaction.dart';
import 'package:ahoruna/src/features/transactions/domain/usecases/delete_transaction.dart';

void main() {
  group('Transaction use cases', () {
    test('creates a transaction through repository', () async {
      final repository = _FakeTransactionRepository();

      final useCase = CreateTransaction(repository);

      await useCase(
        type: TransactionType.expense,
        amount: 48.50,
        currency: 'PEN',
        description: 'Cena',
        categoryId: 'food',
        date: DateTime(2026, 10, 13),
        note: 'Restaurante',
      );

      expect(repository.transactions.length, 1);

      expect(repository.transactions.first.amount, 48.50);

      expect(repository.transactions.first.type, TransactionType.expense);
    });

    test('deletes a transaction through repository', () async {
      final repository = _FakeTransactionRepository();

      await repository.createTransaction(
        type: TransactionType.income,
        amount: 100,
        currency: 'PEN',
        description: 'Ingreso',
        categoryId: 'income',
        date: DateTime(2026, 10, 13),
      );

      final transaction = repository.transactions.first;

      final useCase = DeleteTransaction(repository);

      await useCase(transaction.id);

      expect(repository.transactions, isEmpty);
    });
  });
}

class _FakeTransactionRepository implements TransactionRepository {
  final List<FinanceTransaction> transactions = [];

  int _nextId = 1;

  @override
  Stream<List<FinanceTransaction>> watchTransactions() {
    return Stream.value(List.unmodifiable(transactions));
  }

  @override
  Future<FinanceTransaction> getTransaction(String transactionId) async {
    return transactions.firstWhere(
      (transaction) => transaction.id == transactionId,
    );
  }

  @override
  Future<void> createTransaction({
    required TransactionType type,
    required double amount,
    required String currency,
    required String description,
    required String categoryId,
    required DateTime date,
    String? note,
  }) async {
    transactions.add(
      FinanceTransaction(
        id: 'transaction-${_nextId++}',
        type: type,
        amount: amount,
        currency: currency,
        description: description,
        categoryId: categoryId,
        date: date,
        note: note,
      ),
    );
  }

  @override
  Future<void> updateTransaction({
    required String transactionId,
    required TransactionType type,
    required double amount,
    required String currency,
    required String description,
    required String categoryId,
    required DateTime date,
    String? note,
  }) async {
    final index = transactions.indexWhere(
      (transaction) => transaction.id == transactionId,
    );

    transactions[index] = FinanceTransaction(
      id: transactionId,
      type: type,
      amount: amount,
      currency: currency,
      description: description,
      categoryId: categoryId,
      date: date,
      note: note,
    );
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    transactions.removeWhere((transaction) => transaction.id == transactionId);
  }
}
