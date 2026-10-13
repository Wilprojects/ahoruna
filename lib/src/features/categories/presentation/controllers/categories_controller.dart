import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/features/categories/domain/entities/finance_category.dart';
import 'package:ahoruna/src/features/categories/presentation/providers/categories_dependencies.dart';
import 'package:ahoruna/src/features/categories/presentation/providers/categories_providers.dart';

class CategoriesController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> createCategory({
    required String name,
    required String iconKey,
    required String colorHex,
    required CategoryType type,
  }) {
    return _execute(() async {
      await ref.read(createCategoryUseCaseProvider)(
        name: name,
        iconKey: iconKey,
        colorHex: colorHex,
        type: type,
      );
    });
  }

  Future<void> updateCategory({
    required String categoryId,
    required String name,
    required String iconKey,
    required String colorHex,
    required CategoryType type,
  }) {
    return _execute(() async {
      await ref.read(updateCategoryUseCaseProvider)(
        categoryId: categoryId,
        name: name,
        iconKey: iconKey,
        colorHex: colorHex,
        type: type,
      );

      ref.invalidate(categoryByIdProvider(categoryId));
    });
  }

  Future<void> deleteCategory(String categoryId) {
    return _execute(() async {
      await ref.read(deleteCategoryUseCaseProvider)(categoryId);

      ref.invalidate(categoryByIdProvider(categoryId));
    });
  }

  Future<void> _execute(Future<void> Function() action) async {
    state = const AsyncLoading();

    try {
      await action();

      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);

      rethrow;
    }
  }
}
