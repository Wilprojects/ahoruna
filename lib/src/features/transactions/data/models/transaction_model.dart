import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ahoruna/src/features/transactions/domain/entities/finance_transaction.dart';

class TransactionModel extends FinanceTransaction {
  const TransactionModel({
    required super.id,
    required super.type,
    required super.amount,
    required super.currency,
    required super.description,
    required super.categoryId,
    required super.date,
    super.note,
  });

  factory TransactionModel.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();

    if (data == null) {
      throw StateError('El movimiento no contiene datos.');
    }

    final timestamp = data['date'];

    return TransactionModel(
      id: document.id,
      type: _typeFromString(data['type'] as String?),
      amount: (data['amount'] as num?)?.toDouble() ?? 0,
      currency: data['currency'] as String? ?? 'PEN',
      description: data['description'] as String? ?? '',
      categoryId: data['categoryId'] as String? ?? '',
      date: timestamp is Timestamp
          ? timestamp.toDate()
          : DateTime.fromMillisecondsSinceEpoch(0),
      note: data['note'] as String?,
    );
  }

  static TransactionType _typeFromString(String? value) {
    switch (value) {
      case 'income':
        return TransactionType.income;

      case 'expense':
      default:
        return TransactionType.expense;
    }
  }
}
