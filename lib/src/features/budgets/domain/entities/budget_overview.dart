import 'package:ahoruna/src/features/budgets/domain/entities/budget.dart';

enum BudgetStatus { safe, warning, exceeded }

class BudgetProgress {
  const BudgetProgress({
    required this.budget,
    required this.spentAmount,
    required this.status,
  });

  final Budget budget;
  final double spentAmount;
  final BudgetStatus status;

  double get remainingAmount {
    return budget.limitAmount - spentAmount;
  }

  double get percentage {
    if (budget.limitAmount <= 0) {
      return 0;
    }

    return spentAmount / budget.limitAmount * 100;
  }

  double get progressRatio {
    if (budget.limitAmount <= 0) {
      return 0;
    }

    return (spentAmount / budget.limitAmount).clamp(0.0, 1.0).toDouble();
  }
}

class BudgetOverview {
  const BudgetOverview({
    required this.period,
    required this.currency,
    required this.totalLimit,
    required this.totalSpent,
    required this.otherCurrencyBudgetCount,
    required this.items,
  });

  final String period;
  final String currency;

  final double totalLimit;
  final double totalSpent;

  final int otherCurrencyBudgetCount;

  final List<BudgetProgress> items;

  double get totalRemaining {
    return totalLimit - totalSpent;
  }

  double get progressRatio {
    if (totalLimit <= 0) {
      return 0;
    }

    return (totalSpent / totalLimit).clamp(0.0, 1.0).toDouble();
  }

  int get warningCount {
    return items.where((item) => item.status == BudgetStatus.warning).length;
  }

  int get exceededCount {
    return items.where((item) => item.status == BudgetStatus.exceeded).length;
  }
}
