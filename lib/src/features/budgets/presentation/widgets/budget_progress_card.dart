import 'package:flutter/material.dart';

import 'package:ahoruna/src/core/extensions/theme_extensions.dart';
import 'package:ahoruna/src/features/budgets/domain/entities/budget_overview.dart';
import 'package:ahoruna/src/features/budgets/presentation/utils/budget_visuals.dart';
import 'package:ahoruna/src/features/categories/domain/entities/finance_category.dart';
import 'package:ahoruna/src/features/categories/presentation/utils/category_visuals.dart';
import 'package:ahoruna/src/features/transactions/presentation/utils/transaction_visuals.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_card.dart';

class BudgetProgressCard extends StatelessWidget {
  const BudgetProgressCard({
    required this.progress,
    required this.category,
    required this.onTap,
    super.key,
  });

  final BudgetProgress progress;
  final FinanceCategory? category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

    final statusColor = switch (progress.status) {
      BudgetStatus.safe => colors.income,
      BudgetStatus.warning => colors.warning,
      BudgetStatus.exceeded => colors.expense,
    };

    final categoryColor = category == null
        ? theme.colorScheme.primary
        : CategoryVisuals.colorFromHex(category!.colorHex);

    final remaining = progress.remainingAmount;

    return AhorunaCard(
      showShadow: false,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: categoryColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  category == null
                      ? Icons.category_rounded
                      : CategoryVisuals.iconFor(category!.iconKey),
                  color: categoryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category?.name ?? 'Categoría',
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${progress.percentage.toStringAsFixed(0)}% utilizado',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  BudgetVisuals.statusLabel(progress.status),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress.progressRatio,
              minHeight: 8,
              backgroundColor: colors.surfaceSecondary,
              color: statusColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${TransactionVisuals.formatCurrencyValue(progress.spentAmount, progress.budget.currency)} de '
                  '${TransactionVisuals.formatCurrencyValue(progress.budget.limitAmount, progress.budget.currency)}',
                  style: theme.textTheme.bodySmall,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                remaining >= 0
                    ? 'Quedan '
                          '${TransactionVisuals.formatCurrencyValue(remaining, progress.budget.currency)}'
                    : 'Excedido por '
                          '${TransactionVisuals.formatCurrencyValue(remaining.abs(), progress.budget.currency)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: remaining >= 0 ? colors.textSecondary : colors.expense,
                  fontWeight: remaining < 0 ? FontWeight.w700 : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
