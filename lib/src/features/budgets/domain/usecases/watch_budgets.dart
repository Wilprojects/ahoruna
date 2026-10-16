import 'package:ahoruna/src/features/budgets/domain/entities/budget.dart';
import 'package:ahoruna/src/features/budgets/domain/repositories/budget_repository.dart';

class WatchBudgets {
  const WatchBudgets(this._repository);

  final BudgetRepository _repository;

  Stream<List<Budget>> call({required String period}) {
    return _repository.watchBudgets(period: period);
  }
}
