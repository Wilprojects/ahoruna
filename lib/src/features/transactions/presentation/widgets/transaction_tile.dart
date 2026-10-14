import 'package:flutter/material.dart';

import 'package:ahoruna/src/core/extensions/theme_extensions.dart';
import 'package:ahoruna/src/features/categories/domain/entities/finance_category.dart';
import 'package:ahoruna/src/features/categories/presentation/utils/category_visuals.dart';
import 'package:ahoruna/src/features/transactions/domain/entities/finance_transaction.dart';
import 'package:ahoruna/src/features/transactions/presentation/utils/transaction_visuals.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_card.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    required this.transaction,
    required this.category,
    required this.onTap,
    super.key,
  });

  final FinanceTransaction transaction;
  final FinanceCategory? category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

    final categoryColor = category == null
        ? colors.textSecondary
        : CategoryVisuals.colorFromHex(category!.colorHex);

    final amountColor = transaction.type == TransactionType.income
        ? colors.income
        : colors.expense;

    return AhorunaCard(
      showShadow: false,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              category == null
                  ? Icons.category_rounded
                  : CategoryVisuals.iconFor(category!.iconKey),
              color: categoryColor,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                Text(
                  '${category?.name ?? 'Categoría'}'
                  ' • '
                  '${TransactionVisuals.formatDate(transaction.date)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            TransactionVisuals.formatAmount(
              transaction.amount,
              transaction.currency,
              type: transaction.type,
            ),
            style: theme.textTheme.titleSmall?.copyWith(
              color: amountColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
