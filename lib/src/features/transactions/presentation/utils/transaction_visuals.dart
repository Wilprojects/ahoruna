import 'package:intl/intl.dart';

import 'package:ahoruna/src/features/transactions/domain/entities/finance_transaction.dart';

class TransactionVisuals {
  TransactionVisuals._();

  static String currencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'USD':
        return r'$';

      case 'EUR':
        return '€';

      case 'PEN':
      default:
        return 'S/';
    }
  }

  static String formatAmount(
    double amount,
    String currency, {
    TransactionType? type,
  }) {
    final formatter = NumberFormat('#,##0.00');

    final symbol = currencySymbol(currency);

    final prefix = switch (type) {
      TransactionType.income => '+',
      TransactionType.expense => '-',
      null => '',
    };

    return '$prefix$symbol ${formatter.format(amount)}';
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String typeLabel(TransactionType type) {
    switch (type) {
      case TransactionType.expense:
        return 'Gasto';

      case TransactionType.income:
        return 'Ingreso';
    }
  }

  static String formatCurrencyValue(double value, String currency) {
    final formatter = NumberFormat('#,##0.00');

    final symbol = currencySymbol(currency);

    final sign = value < 0 ? '-' : '';

    return '$sign$symbol ${formatter.format(value.abs())}';
  }

  static String historyDateLabel(
      DateTime date, {
        DateTime? now,
      }) {
    final reference = now ?? DateTime.now();

    final today = DateTime(
      reference.year,
      reference.month,
      reference.day,
    );

    final transactionDay = DateTime(
      date.year,
      date.month,
      date.day,
    );

    if (transactionDay == today) {
      return 'Hoy';
    }

    final yesterday = today.subtract(
      const Duration(days: 1),
    );

    if (transactionDay == yesterday) {
      return 'Ayer';
    }

    return formatDate(date);
  }
}
