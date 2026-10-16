import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/features/budgets/presentation/providers/budgets_dependencies.dart';

class BudgetsController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> createBudget({
    required String categoryId,
    required double limitAmount,
    required String currency,
    required String period,
    required int alertPercent,
  }) {
    return _execute(() async {
      await ref.read(createBudgetUseCaseProvider)(
        categoryId: categoryId,
        limitAmount: limitAmount,
        currency: currency,
        period: period,
        alertPercent: alertPercent,
      );
    });
  }

  Future<void> updateBudget({
    required String budgetId,
    required String categoryId,
    required double limitAmount,
    required int alertPercent,
  }) {
    return _execute(() async {
      await ref.read(updateBudgetUseCaseProvider)(
        budgetId: budgetId,
        categoryId: categoryId,
        limitAmount: limitAmount,
        alertPercent: alertPercent,
      );
    });
  }

  Future<void> deleteBudget(String budgetId) {
    return _execute(() async {
      await ref.read(deleteBudgetUseCaseProvider)(budgetId);
    });
  }

  Future<void> _execute(Future<void> Function() action) async {
    state = const AsyncLoading();

    try {
      await action();

      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);

      rethrow;
    }
  }
}
