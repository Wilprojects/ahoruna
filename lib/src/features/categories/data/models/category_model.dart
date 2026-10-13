import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ahoruna/src/features/categories/domain/entities/finance_category.dart';

class CategoryModel extends FinanceCategory {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.iconKey,
    required super.colorHex,
    required super.type,
    required super.isDefault,
    required super.isActive,
  });

  factory CategoryModel.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();

    if (data == null) {
      throw StateError('La categoría no contiene datos.');
    }

    return CategoryModel(
      id: document.id,
      name: data['name'] as String? ?? '',
      iconKey: data['iconKey'] as String? ?? 'category',
      colorHex: data['colorHex'] as String? ?? '#73798E',
      type: _categoryTypeFromString(data['type'] as String?),
      isDefault: data['isDefault'] as bool? ?? false,
      isActive: data['isActive'] as bool? ?? true,
    );
  }

  static CategoryType _categoryTypeFromString(String? value) {
    switch (value) {
      case 'expense':
        return CategoryType.expense;

      case 'income':
        return CategoryType.income;

      case 'both':
      default:
        return CategoryType.both;
    }
  }
}
