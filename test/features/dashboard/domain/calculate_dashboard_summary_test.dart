import 'package:flutter_test/flutter_test.dart';

import 'package:ahoruna/src/features/dashboard/domain/usecases/calculate_dashboard_summary.dart';
import 'package:ahoruna/src/features/transactions/domain/entities/finance_transaction.dart';

void main() {
  group('CalculateDashboardSummary', () {
    const useCase = CalculateDashboardSummary();

    test('calculates balance and monthly totals '
        'using only selected currency', () {
      final transactions = <FinanceTransaction>[
        FinanceTransaction(
          id: '1',
          type: TransactionType.income,
          amount: 1000,
          currency: 'PEN',
          description: 'Sueldo',
          categoryId: 'salary',
          date: DateTime(2026, 10, 1),
        ),
        FinanceTransaction(
          id: '2',
          type: TransactionType.expense,
          amount: 50,
          currency: 'PEN',
          description: 'Cena',
          categoryId: 'food',
          date: DateTime(2026, 10, 10),
        ),
        FinanceTransaction(
          id: '3',
          type: TransactionType.expense,
          amount: 100,
          currency: 'PEN',
          description: 'Compra septiembre',
          categoryId: 'shopping',
          date: DateTime(2026, 9, 20),
        ),
        FinanceTransaction(
          id: '4',
          type: TransactionType.income,
          amount: 200,
          currency: 'USD',
          description: 'Ingreso dólares',
          categoryId: 'freelance',
          date: DateTime(2026, 10, 12),
        ),
      ];

      final summary = useCase(
        transactions: transactions,
        currency: 'PEN',
        now: DateTime(2026, 10, 15),
      );

      expect(summary.balance, 850);

      expect(summary.monthlyIncome, 1000);

      expect(summary.monthlyExpense, 50);

      expect(summary.monthlyNet, 950);

      expect(summary.otherCurrencyTransactionCount, 1);

      expect(summary.recentTransactions.length, 4);

      expect(summary.recentTransactions.first.id, '4');
    });

    test('limits recent transactions', () {
      final transactions = List.generate(10, (index) {
        return FinanceTransaction(
          id: '$index',
          type: TransactionType.expense,
          amount: 10,
          currency: 'PEN',
          description: 'Movimiento $index',
          categoryId: 'food',
          date: DateTime(2026, 10, index + 1),
        );
      });

      final summary = useCase(
        transactions: transactions,
        currency: 'PEN',
        now: DateTime(2026, 10, 15),
        recentLimit: 5,
      );

      expect(summary.recentTransactions.length, 5);

      expect(summary.recentTransactions.first.id, '9');
    });
  });
}
