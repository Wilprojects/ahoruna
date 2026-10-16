import 'package:ahoruna/src/features/budgets/domain/repositories/budget_repository.dart';

class UpdateBudget {
  const UpdateBudget(this._repository);

  final BudgetRepository _repository;

  Future<void> call({
    required String budgetId,
    required String categoryId,
    required double limitAmount,
    required int alertPercent,
  }) {
    return _repository.updateBudget(
      budgetId: budgetId,
      categoryId: categoryId,
      limitAmount: limitAmount,
      alertPercent: alertPercent,
    );
  }
}
