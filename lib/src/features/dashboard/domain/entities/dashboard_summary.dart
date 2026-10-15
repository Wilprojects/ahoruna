import 'package:ahoruna/src/features/transactions/domain/entities/finance_transaction.dart';

class DashboardSummary {
  const DashboardSummary({
    required this.currency,
    required this.balance,
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.otherCurrencyTransactionCount,
    required this.recentTransactions,
    required this.periodDate,
  });

  final String currency;

  /// Balance histórico:
  /// ingresos - gastos.
  final double balance;

  /// Total de ingresos del mes actual.
  final double monthlyIncome;

  /// Total de gastos del mes actual.
  final double monthlyExpense;

  /// Movimientos que no participan en los
  /// totales porque utilizan otra moneda.
  final int otherCurrencyTransactionCount;

  /// Últimos movimientos.
  final List<FinanceTransaction> recentTransactions;

  /// Fecha utilizada para determinar
  /// el período mensual.
  final DateTime periodDate;

  double get monthlyNet {
    return monthlyIncome - monthlyExpense;
  }
}
