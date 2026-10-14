import 'package:ahoruna/src/features/transactions/domain/repositories/transaction_repository.dart';

class DeleteTransaction {
  const DeleteTransaction(this._repository);

  final TransactionRepository _repository;

  Future<void> call(String transactionId) {
    return _repository.deleteTransaction(transactionId);
  }
}
