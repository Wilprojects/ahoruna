import 'package:ahoruna/src/features/transactions/domain/entities/finance_transaction.dart';
import 'package:ahoruna/src/features/transactions/domain/repositories/transaction_repository.dart';

class CreateTransaction {
  const CreateTransaction(this._repository);

  final TransactionRepository _repository;

  Future<void> call({
    required TransactionType type,
    required double amount,
    required String currency,
    required String description,
    required String categoryId,
    required DateTime date,
    String? note,
  }) {
    return _repository.createTransaction(
      type: type,
      amount: amount,
      currency: currency,
      description: description,
      categoryId: categoryId,
      date: date,
      note: note,
    );
  }
}
