import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/features/budgets/domain/entities/budget.dart';
import 'package:ahoruna/src/features/budgets/domain/entities/budget_overview.dart';
import 'package:ahoruna/src/features/budgets/domain/utils/budget_period_utils.dart';
import 'package:ahoruna/src/features/budgets/presentation/controllers/budget_period_controller.dart';
import 'package:ahoruna/src/features/budgets/presentation/controllers/budgets_controller.dart';
import 'package:ahoruna/src/features/budgets/presentation/providers/budgets_dependencies.dart';
import 'package:ahoruna/src/features/settings/presentation/providers/user_preferences_provider.dart';
import 'package:ahoruna/src/features/transactions/presentation/providers/transactions_providers.dart';

final selectedBudgetPeriodProvider =
    NotifierProvider<BudgetPeriodController, DateTime>(
      BudgetPeriodController.new,
    );

final budgetsForPeriodProvider = StreamProvider.autoDispose
    .family<List<Budget>, String>((ref, period) {
      final watchBudgets = ref.watch(watchBudgetsUseCaseProvider);

      return watchBudgets(period: period);
    });

final budgetByIdProvider = FutureProvider.autoDispose.family<Budget, String>((
  ref,
  budgetId,
) {
  final getBudget = ref.watch(getBudgetUseCaseProvider);

  return getBudget(budgetId);
});

final budgetOverviewForPeriodProvider = Provider.autoDispose
    .family<AsyncValue<BudgetOverview>, String>((ref, period) {
      final budgets = ref.watch(budgetsForPeriodProvider(period));

      final transactions = ref.watch(transactionsProvider);

      final preferences = ref.watch(userPreferencesProvider);

      final calculator = ref.watch(calculateBudgetOverviewProvider);

      return budgets.when(
        loading: () {
          return const AsyncLoading();
        },
        error: (error, stackTrace) {
          return AsyncError(error, stackTrace);
        },
        data: (budgetValues) {
          return transactions.when(
            loading: () {
              return const AsyncLoading();
            },
            error: (error, stackTrace) {
              return AsyncError(error, stackTrace);
            },
            data: (transactionValues) {
              return preferences.when(
                loading: () {
                  return const AsyncLoading();
                },
                error: (error, stackTrace) {
                  return AsyncError(error, stackTrace);
                },
                data: (preferenceValues) {
                  return AsyncData(
                    calculator(
                      budgets: budgetValues,
                      transactions: transactionValues,
                      currency: preferenceValues.currencyCode,
                      period: period,
                    ),
                  );
                },
              );
            },
          );
        },
      );
    });

final selectedBudgetOverviewProvider =
    Provider.autoDispose<AsyncValue<BudgetOverview>>((ref) {
      final selectedDate = ref.watch(selectedBudgetPeriodProvider);

      final period = BudgetPeriodUtils.fromDate(selectedDate);

      return ref.watch(budgetOverviewForPeriodProvider(period));
    });

final budgetsControllerProvider =
    AsyncNotifierProvider<BudgetsController, void>(BudgetsController.new);
