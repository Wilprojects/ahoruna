import 'package:ahoruna/src/features/budgets/domain/entities/budget.dart';
import 'package:ahoruna/src/features/budgets/domain/repositories/budget_repository.dart';

class GetBudget {
  const GetBudget(this._repository);

  final BudgetRepository _repository;

  Future<Budget> call(String budgetId) {
    return _repository.getBudget(budgetId);
  }
}
