enum TransactionType { expense, income }

class FinanceTransaction {
  const FinanceTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.currency,
    required this.description,
    required this.categoryId,
    required this.date,
    this.note,
  });

  final String id;
  final TransactionType type;

  /// Siempre positivo.
  final double amount;

  final String currency;
  final String description;
  final String categoryId;
  final DateTime date;
  final String? note;
}
