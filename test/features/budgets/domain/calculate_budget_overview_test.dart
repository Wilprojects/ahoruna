import 'package:flutter_test/flutter_test.dart';

import 'package:ahoruna/src/features/budgets/domain/entities/budget.dart';
import 'package:ahoruna/src/features/budgets/domain/entities/budget_overview.dart';
import 'package:ahoruna/src/features/budgets/domain/usecases/calculate_budget_overview.dart';
import 'package:ahoruna/src/features/transactions/domain/entities/finance_transaction.dart';

void main() {
  group(
    'CalculateBudgetOverview',
        () {
      const useCase =
      CalculateBudgetOverview();

      test(
        'calculates spent amounts '
            'and statuses correctly',
            () {
          const budgets = <Budget>[
            Budget(
              id: 'food-budget',
              categoryId: 'food',
              limitAmount: 500,
              currency: 'PEN',
              period: '2026-10',
              alertPercent: 80,
              isActive: true,
            ),
            Budget(
              id: 'transport-budget',
              categoryId: 'transport',
              limitAmount: 100,
              currency: 'PEN',
              period: '2026-10',
              alertPercent: 80,
              isActive: true,
            ),
            Budget(
              id: 'home-budget',
              categoryId: 'home',
              limitAmount: 200,
              currency: 'PEN',
              period: '2026-10',
              alertPercent: 80,
              isActive: true,
            ),
            Budget(
              id: 'usd-budget',
              categoryId: 'food',
              limitAmount: 100,
              currency: 'USD',
              period: '2026-10',
              alertPercent: 80,
              isActive: true,
            ),
          ];

          final transactions =
          <FinanceTransaction>[
            FinanceTransaction(
              id: '1',
              type:
              TransactionType.expense,
              amount: 300,
              currency: 'PEN',
              description: 'Comida',
              categoryId: 'food',
              date:
              DateTime(2026, 10, 5),
            ),
            FinanceTransaction(
              id: '2',
              type:
              TransactionType.expense,
              amount: 90,
              currency: 'PEN',
              description: 'Taxi',
              categoryId: 'transport',
              date:
              DateTime(2026, 10, 10),
            ),
            FinanceTransaction(
              id: '3',
              type:
              TransactionType.expense,
              amount: 250,
              currency: 'PEN',
              description: 'Hogar',
              categoryId: 'home',
              date:
              DateTime(2026, 10, 12),
            ),
            FinanceTransaction(
              id: '4',
              type:
              TransactionType.income,
              amount: 1000,
              currency: 'PEN',
              description: 'Ingreso',
              categoryId: 'salary',
              date:
              DateTime(2026, 10, 1),
            ),
            FinanceTransaction(
              id: '5',
              type:
              TransactionType.expense,
              amount: 100,
              currency: 'PEN',
              description:
              'Septiembre',
              categoryId: 'food',
              date:
              DateTime(2026, 9, 30),
            ),
            FinanceTransaction(
              id: '6',
              type:
              TransactionType.expense,
              amount: 50,
              currency: 'USD',
              description:
              'Comida dólares',
              categoryId: 'food',
              date:
              DateTime(2026, 10, 15),
            ),
          ];

          final overview = useCase(
            budgets: budgets,
            transactions:
            transactions,
            currency: 'PEN',
            period: '2026-10',
          );

          expect(
            overview.totalLimit,
            800,
          );

          expect(
            overview.totalSpent,
            640,
          );

          expect(
            overview.totalRemaining,
            160,
          );

          expect(
            overview
                .otherCurrencyBudgetCount,
            1,
          );

          expect(
            overview.warningCount,
            1,
          );

          expect(
            overview.exceededCount,
            1,
          );

          final food = overview.items
              .firstWhere(
                (item) =>
            item.budget.categoryId ==
                'food',
          );

          expect(
            food.spentAmount,
            300,
          );

          expect(
            food.status,
            BudgetStatus.safe,
          );

          final transport =
          overview.items.firstWhere(
                (item) =>
            item.budget.categoryId ==
                'transport',
          );

          expect(
            transport.status,
            BudgetStatus.warning,
          );

          final home =
          overview.items.firstWhere(
                (item) =>
            item.budget.categoryId ==
                'home',
          );

          expect(
            home.status,
            BudgetStatus.exceeded,
          );
        },
      );
    },
  );
}