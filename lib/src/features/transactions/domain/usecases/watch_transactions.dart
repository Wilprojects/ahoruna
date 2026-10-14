import 'package:ahoruna/src/features/transactions/domain/entities/finance_transaction.dart';
import 'package:ahoruna/src/features/transactions/domain/repositories/transaction_repository.dart';

class WatchTransactions {
  const WatchTransactions(this._repository);

  final TransactionRepository _repository;

  Stream<List<FinanceTransaction>> call() {
    return _repository.watchTransactions();
  }
}
