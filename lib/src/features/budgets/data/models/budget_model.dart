import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ahoruna/src/features/budgets/domain/entities/budget.dart';

class BudgetModel extends Budget {
  const BudgetModel({
    required super.id,
    required super.categoryId,
    required super.limitAmount,
    required super.currency,
    required super.period,
    required super.alertPercent,
    required super.isActive,
  });

  factory BudgetModel.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();

    if (data == null) {
      throw StateError('El presupuesto no contiene datos.');
    }

    return BudgetModel(
      id: document.id,
      categoryId: data['categoryId'] as String? ?? '',
      limitAmount: (data['limitAmount'] as num?)?.toDouble() ?? 0,
      currency: data['currency'] as String? ?? 'PEN',
      period: data['period'] as String? ?? '',
      alertPercent: (data['alertPercent'] as num?)?.toInt() ?? 80,
      isActive: data['isActive'] as bool? ?? true,
    );
  }
}
