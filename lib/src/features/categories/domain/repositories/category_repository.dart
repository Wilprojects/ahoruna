import 'package:ahoruna/src/features/categories/domain/entities/finance_category.dart';

abstract interface class CategoryRepository {
  Stream<List<FinanceCategory>> watchCategories();

  Future<FinanceCategory> getCategory(String categoryId);

  Future<void> ensureDefaultCategories();

  Future<void> createCategory({
    required String name,
    required String iconKey,
    required String colorHex,
    required CategoryType type,
  });

  Future<void> updateCategory({
    required String categoryId,
    required String name,
    required String iconKey,
    required String colorHex,
    required CategoryType type,
  });

  Future<void> deleteCategory(String categoryId);
}
