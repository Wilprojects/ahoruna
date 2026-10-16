import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/features/transactions/domain/entities/transaction_filter.dart';

class TransactionFilterController extends Notifier<TransactionFilter> {
  @override
  TransactionFilter build() {
    return const TransactionFilter();
  }

  void setQuery(String query) {
    state = TransactionFilter(
      query: query,
      type: state.type,
      categoryId: state.categoryId,
      dateFrom: state.dateFrom,
      dateTo: state.dateTo,
    );
  }

  void applyAdvancedFilters(TransactionFilter filter) {
    state = TransactionFilter(
      query: state.query,
      type: filter.type,
      categoryId: filter.categoryId,
      dateFrom: filter.dateFrom,
      dateTo: filter.dateTo,
    );
  }

  void clearAdvancedFilters() {
    state = TransactionFilter(query: state.query);
  }

  void clearAll() {
    state = const TransactionFilter();
  }
}
