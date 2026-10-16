enum TransactionTypeFilter { all, expense, income }

class TransactionFilter {
  const TransactionFilter({
    this.query = '',
    this.type = TransactionTypeFilter.all,
    this.categoryId,
    this.dateFrom,
    this.dateTo,
  });

  final String query;
  final TransactionTypeFilter type;
  final String? categoryId;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  bool get hasSearch {
    return query.trim().isNotEmpty;
  }

  bool get hasDateRange {
    return dateFrom != null || dateTo != null;
  }

  bool get hasAdvancedFilters {
    return type != TransactionTypeFilter.all ||
        categoryId != null ||
        hasDateRange;
  }

  bool get hasAnyFilters {
    return hasSearch || hasAdvancedFilters;
  }

  int get activeAdvancedFilterCount {
    var count = 0;

    if (type != TransactionTypeFilter.all) {
      count++;
    }

    if (categoryId != null) {
      count++;
    }

    if (hasDateRange) {
      count++;
    }

    return count;
  }
}
