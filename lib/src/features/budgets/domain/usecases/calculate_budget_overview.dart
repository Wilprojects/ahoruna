import 'package:ahoruna/src/features/budgets/domain/entities/budget.dart';
import 'package:ahoruna/src/features/budgets/domain/entities/budget_overview.dart';
import 'package:ahoruna/src/features/budgets/domain/utils/budget_period_utils.dart';
import 'package:ahoruna/src/features/transactions/domain/entities/finance_transaction.dart';

class CalculateBudgetOverview {
  const CalculateBudgetOverview();

  BudgetOverview call({
    required List<Budget> budgets,
    required List<FinanceTransaction> transactions,
    required String currency,
    required String period,
  }) {
    final selectedCurrency = currency.trim().toUpperCase();

    final selectedBudgets = budgets
        .where(
          (budget) => budget.currency.trim().toUpperCase() == selectedCurrency,
        )
        .toList();

    final otherCurrencyBudgetCount = budgets.length - selectedBudgets.length;

    final spentByCategoryCents = <String, int>{};

    for (final transaction in transactions) {
      if (transaction.type != TransactionType.expense) {
        continue;
      }

      if (transaction.currency.trim().toUpperCase() != selectedCurrency) {
        continue;
      }

      if (!BudgetPeriodUtils.containsDate(
        period: period,
        date: transaction.date,
      )) {
        continue;
      }

      final amountCents = (transaction.amount * 100).round();

      spentByCategoryCents.update(
        transaction.categoryId,
        (current) => current + amountCents,
        ifAbsent: () => amountCents,
      );
    }

    final items = <BudgetProgress>[];

    var totalLimitCents = 0;
    var totalSpentCents = 0;

    for (final budget in selectedBudgets) {
      final limitCents = (budget.limitAmount * 100).round();

      final spentCents = spentByCategoryCents[budget.categoryId] ?? 0;

      final percentage = limitCents <= 0 ? 0 : spentCents / limitCents * 100;

      final status = percentage >= 100
          ? BudgetStatus.exceeded
          : percentage >= budget.alertPercent
          ? BudgetStatus.warning
          : BudgetStatus.safe;

      items.add(
        BudgetProgress(
          budget: budget,
          spentAmount: spentCents / 100,
          status: status,
        ),
      );

      totalLimitCents += limitCents;
      totalSpentCents += spentCents;
    }

    items.sort((first, second) {
      return second.percentage.compareTo(first.percentage);
    });

    return BudgetOverview(
      period: period,
      currency: selectedCurrency,
      totalLimit: totalLimitCents / 100,
      totalSpent: totalSpentCents / 100,
      otherCurrencyBudgetCount: otherCurrencyBudgetCount,
      items: items,
    );
  }
}
