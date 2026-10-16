import 'package:flutter_test/flutter_test.dart';

import 'package:ahoruna/src/features/transactions/domain/entities/finance_transaction.dart';
import 'package:ahoruna/src/features/transactions/domain/entities/transaction_filter.dart';
import 'package:ahoruna/src/features/transactions/domain/usecases/filter_transactions.dart';

void main() {
  group('FilterTransactions', () {
    const useCase = FilterTransactions();

    final transactions = <FinanceTransaction>[
      FinanceTransaction(
        id: '1',
        type: TransactionType.expense,
        amount: 50,
        currency: 'PEN',
        description: 'Cena familiar',
        categoryId: 'food',
        date: DateTime(2026, 10, 15),
        note: 'Restaurante favorito',
      ),
      FinanceTransaction(
        id: '2',
        type: TransactionType.income,
        amount: 3500,
        currency: 'PEN',
        description: 'Sueldo octubre',
        categoryId: 'salary',
        date: DateTime(2026, 10, 14),
      ),
      FinanceTransaction(
        id: '3',
        type: TransactionType.expense,
        amount: 100,
        currency: 'PEN',
        description: 'Supermercado',
        categoryId: 'food',
        date: DateTime(2026, 9, 20),
      ),
      FinanceTransaction(
        id: '4',
        type: TransactionType.expense,
        amount: 80,
        currency: 'PEN',
        description: 'Veterinario',
        categoryId: 'pets',
        date: DateTime(2026, 10, 10),
      ),
    ];

    const categoryNames = <String, String>{
      'food': 'Alimentación',
      'salary': 'Sueldo',
      'pets': 'Mascotas',
    };

    test('filters by transaction type', () {
      final result = useCase(
        transactions: transactions,
        filter: const TransactionFilter(type: TransactionTypeFilter.income),
        categoryNamesById: categoryNames,
      );

      expect(result.length, 1);

      expect(result.first.id, '2');
    });

    test('filters by category', () {
      final result = useCase(
        transactions: transactions,
        filter: const TransactionFilter(categoryId: 'food'),
        categoryNamesById: categoryNames,
      );

      expect(result.length, 2);
    });

    test('filters by inclusive date range', () {
      final result = useCase(
        transactions: transactions,
        filter: TransactionFilter(
          dateFrom: DateTime(2026, 10, 10),
          dateTo: DateTime(2026, 10, 14),
        ),
        categoryNamesById: categoryNames,
      );

      expect(result.length, 2);

      expect(result.map((value) => value.id), containsAll(['2', '4']));
    });

    test('searches description', () {
      final result = useCase(
        transactions: transactions,
        filter: const TransactionFilter(query: 'super'),
        categoryNamesById: categoryNames,
      );

      expect(result.length, 1);

      expect(result.first.id, '3');
    });

    test('searches notes', () {
      final result = useCase(
        transactions: transactions,
        filter: const TransactionFilter(query: 'restaurante'),
        categoryNamesById: categoryNames,
      );

      expect(result.length, 1);

      expect(result.first.id, '1');
    });

    test('search ignores accents and case', () {
      final result = useCase(
        transactions: transactions,
        filter: const TransactionFilter(query: 'ALIMENTACION'),
        categoryNamesById: categoryNames,
      );

      expect(result.length, 2);
    });

    test('combines multiple filters', () {
      final result = useCase(
        transactions: transactions,
        filter: TransactionFilter(
          query: 'mascotas',
          type: TransactionTypeFilter.expense,
          dateFrom: DateTime(2026, 10, 1),
          dateTo: DateTime(2026, 10, 31),
        ),
        categoryNamesById: categoryNames,
      );

      expect(result.length, 1);

      expect(result.first.id, '4');
    });
  });
}
