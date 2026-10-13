import 'package:flutter_test/flutter_test.dart';

import 'package:ahoruna/src/features/categories/domain/entities/finance_category.dart';
import 'package:ahoruna/src/features/categories/domain/repositories/category_repository.dart';
import 'package:ahoruna/src/features/categories/domain/usecases/create_category.dart';
import 'package:ahoruna/src/features/categories/domain/usecases/delete_category.dart';

void main() {
  group('Category use cases', () {
    test('creates a category through repository', () async {
      final repository = _FakeCategoryRepository();

      final useCase = CreateCategory(repository);

      await useCase(
        name: 'Mascotas',
        iconKey: 'pets',
        colorHex: '#5B5CF0',
        type: CategoryType.expense,
      );

      expect(repository.categories.length, 1);

      expect(repository.categories.first.name, 'Mascotas');
    });

    test('deletes a category through repository', () async {
      final repository = _FakeCategoryRepository();

      await repository.createCategory(
        name: 'Mascotas',
        iconKey: 'pets',
        colorHex: '#5B5CF0',
        type: CategoryType.expense,
      );

      final category = repository.categories.first;

      final useCase = DeleteCategory(repository);

      await useCase(category.id);

      expect(repository.categories, isEmpty);
    });
  });
}

class _FakeCategoryRepository implements CategoryRepository {
  final List<FinanceCategory> categories = [];

  int _nextId = 1;

  @override
  Stream<List<FinanceCategory>> watchCategories() {
    return Stream.value(List.unmodifiable(categories));
  }

  @override
  Future<FinanceCategory> getCategory(String categoryId) async {
    return categories.firstWhere((category) => category.id == categoryId);
  }

  @override
  Future<void> ensureDefaultCategories() async {}

  @override
  Future<void> createCategory({
    required String name,
    required String iconKey,
    required String colorHex,
    required CategoryType type,
  }) async {
    categories.add(
      FinanceCategory(
        id: 'category-${_nextId++}',
        name: name,
        iconKey: iconKey,
        colorHex: colorHex,
        type: type,
        isDefault: false,
        isActive: true,
      ),
    );
  }

  @override
  Future<void> updateCategory({
    required String categoryId,
    required String name,
    required String iconKey,
    required String colorHex,
    required CategoryType type,
  }) async {
    final index = categories.indexWhere(
      (category) => category.id == categoryId,
    );

    final previous = categories[index];

    categories[index] = FinanceCategory(
      id: previous.id,
      name: name,
      iconKey: iconKey,
      colorHex: colorHex,
      type: type,
      isDefault: previous.isDefault,
      isActive: previous.isActive,
    );
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    categories.removeWhere((category) => category.id == categoryId);
  }
}
