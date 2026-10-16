import 'package:ahoruna/src/features/budgets/domain/repositories/budget_repository.dart';

class CreateBudget {
  const CreateBudget(this._repository);

  final BudgetRepository _repository;

  Future<void> call({
    required String categoryId,
    required double limitAmount,
    required String currency,
    required String period,
    required int alertPercent,
  }) {
    return _repository.createBudget(
      categoryId: categoryId,
      limitAmount: limitAmount,
      currency: currency,
      period: period,
      alertPercent: alertPercent,
    );
  }
}
