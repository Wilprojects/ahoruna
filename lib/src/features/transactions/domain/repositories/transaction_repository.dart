import 'package:ahoruna/src/features/transactions/domain/entities/finance_transaction.dart';

abstract interface class TransactionRepository {
  Stream<List<FinanceTransaction>> watchTransactions();

  Future<FinanceTransaction> getTransaction(String transactionId);

  Future<void> createTransaction({
    required TransactionType type,
    required double amount,
    required String currency,
    required String description,
    required String categoryId,
    required DateTime date,
    String? note,
  });

  Future<void> updateTransaction({
    required String transactionId,
    required TransactionType type,
    required double amount,
    required String currency,
    required String description,
    required String categoryId,
    required DateTime date,
    String? note,
  });

  Future<void> deleteTransaction(String transactionId);
}
