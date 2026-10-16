import 'package:ahoruna/src/features/budgets/domain/repositories/budget_repository.dart';

class DeleteBudget {
  const DeleteBudget(this._repository);

  final BudgetRepository _repository;

  Future<void> call(String budgetId) {
    return _repository.deleteBudget(budgetId);
  }
}
