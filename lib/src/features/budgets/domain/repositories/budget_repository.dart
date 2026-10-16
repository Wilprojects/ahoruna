import 'package:ahoruna/src/features/budgets/domain/entities/budget.dart';

abstract interface class BudgetRepository {
  Stream<List<Budget>> watchBudgets({required String period});

  Future<Budget> getBudget(String budgetId);

  Future<void> createBudget({
    required String categoryId,
    required double limitAmount,
    required String currency,
    required String period,
    required int alertPercent,
  });

  Future<void> updateBudget({
    required String budgetId,
    required String categoryId,
    required double limitAmount,
    required int alertPercent,
  });

  Future<void> deleteBudget(String budgetId);
}
