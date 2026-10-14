import 'package:ahoruna/src/features/transactions/domain/entities/finance_transaction.dart';
import 'package:ahoruna/src/features/transactions/domain/repositories/transaction_repository.dart';

class GetTransaction {
  const GetTransaction(this._repository);

  final TransactionRepository _repository;

  Future<FinanceTransaction> call(String transactionId) {
    return _repository.getTransaction(transactionId);
  }
}
