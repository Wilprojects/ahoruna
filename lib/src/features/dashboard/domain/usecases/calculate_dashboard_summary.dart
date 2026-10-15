import 'package:ahoruna/src/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:ahoruna/src/features/transactions/domain/entities/finance_transaction.dart';

class CalculateDashboardSummary {
  const CalculateDashboardSummary();

  DashboardSummary call({
    required List<FinanceTransaction> transactions,
    required String currency,
    required DateTime now,
    int recentLimit = 5,
  }) {
    final selectedCurrency = currency.trim().toUpperCase();

    var balanceCents = 0;
    var monthlyIncomeCents = 0;
    var monthlyExpenseCents = 0;
    var otherCurrencyTransactionCount = 0;

    for (final transaction in transactions) {
      final transactionCurrency = transaction.currency.trim().toUpperCase();

      if (transactionCurrency != selectedCurrency) {
        otherCurrencyTransactionCount++;
        continue;
      }

      final amountCents = (transaction.amount * 100).round();

      switch (transaction.type) {
        case TransactionType.income:
          balanceCents += amountCents;

          if (_isSameMonth(transaction.date, now)) {
            monthlyIncomeCents += amountCents;
          }

        case TransactionType.expense:
          balanceCents -= amountCents;

          if (_isSameMonth(transaction.date, now)) {
            monthlyExpenseCents += amountCents;
          }
      }
    }

    final sortedTransactions = List<FinanceTransaction>.from(transactions)
      ..sort((first, second) {
        return second.date.compareTo(first.date);
      });

    final recentTransactions = sortedTransactions.take(recentLimit).toList();

    return DashboardSummary(
      currency: selectedCurrency,
      balance: balanceCents / 100,
      monthlyIncome: monthlyIncomeCents / 100,
      monthlyExpense: monthlyExpenseCents / 100,
      otherCurrencyTransactionCount: otherCurrencyTransactionCount,
      recentTransactions: recentTransactions,
      periodDate: now,
    );
  }

  bool _isSameMonth(DateTime first, DateTime second) {
    return first.year == second.year && first.month == second.month;
  }
}
