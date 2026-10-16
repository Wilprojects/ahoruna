import 'package:ahoruna/src/features/transactions/domain/entities/finance_transaction.dart';
import 'package:ahoruna/src/features/transactions/domain/entities/transaction_filter.dart';

class FilterTransactions {
  const FilterTransactions();

  List<FinanceTransaction> call({
    required List<FinanceTransaction> transactions,
    required TransactionFilter filter,
    required Map<String, String> categoryNamesById,
  }) {
    final normalizedQuery = _normalize(
      filter.query,
    );

    final queryTerms = normalizedQuery
        .split(' ')
        .where(
          (term) => term.isNotEmpty,
    )
        .toList();

    final filtered = transactions.where(
          (transaction) {
        if (!_matchesType(
          transaction,
          filter.type,
        )) {
          return false;
        }

        if (!_matchesCategory(
          transaction,
          filter.categoryId,
        )) {
          return false;
        }

        if (!_matchesDateRange(
          transaction,
          filter.dateFrom,
          filter.dateTo,
        )) {
          return false;
        }

        if (!_matchesSearch(
          transaction,
          queryTerms,
          categoryNamesById,
        )) {
          return false;
        }

        return true;
      },
    ).toList();

    filtered.sort(
          (first, second) {
        return second.date.compareTo(
          first.date,
        );
      },
    );

    return filtered;
  }

  bool _matchesType(
      FinanceTransaction transaction,
      TransactionTypeFilter filter,
      ) {
    switch (filter) {
      case TransactionTypeFilter.all:
        return true;

      case TransactionTypeFilter.expense:
        return transaction.type ==
            TransactionType.expense;

      case TransactionTypeFilter.income:
        return transaction.type ==
            TransactionType.income;
    }
  }

  bool _matchesCategory(
      FinanceTransaction transaction,
      String? categoryId,
      ) {
    if (categoryId == null) {
      return true;
    }

    return transaction.categoryId ==
        categoryId;
  }

  bool _matchesDateRange(
      FinanceTransaction transaction,
      DateTime? from,
      DateTime? to,
      ) {
    final transactionDate = DateTime(
      transaction.date.year,
      transaction.date.month,
      transaction.date.day,
    );

    if (from != null) {
      final fromDate = DateTime(
        from.year,
        from.month,
        from.day,
      );

      if (transactionDate.isBefore(fromDate)) {
        return false;
      }
    }

    if (to != null) {
      final toDate = DateTime(
        to.year,
        to.month,
        to.day,
      );

      if (transactionDate.isAfter(toDate)) {
        return false;
      }
    }

    return true;
  }

  bool _matchesSearch(
      FinanceTransaction transaction,
      List<String> queryTerms,
      Map<String, String> categoryNamesById,
      ) {
    if (queryTerms.isEmpty) {
      return true;
    }

    final categoryName =
        categoryNamesById[
        transaction.categoryId
        ] ??
            '';

    final searchableText = _normalize(
      '${transaction.description} '
          '${transaction.note ?? ''} '
          '$categoryName',
    );

    return queryTerms.every(
      searchableText.contains,
    );
  }

  String _normalize(String value) {
    var result = value
        .trim()
        .toLowerCase();

    const replacements = {
      'á': 'a',
      'é': 'e',
      'í': 'i',
      'ó': 'o',
      'ú': 'u',
      'ü': 'u',
      'ñ': 'n',
    };

    replacements.forEach(
          (source, target) {
        result = result.replaceAll(
          source,
          target,
        );
      },
    );

    return result.replaceAll(
      RegExp(r'\s+'),
      ' ',
    );
  }
}