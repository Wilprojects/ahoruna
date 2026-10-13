import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/features/categories/domain/entities/finance_category.dart';
import 'package:ahoruna/src/features/categories/presentation/controllers/categories_controller.dart';
import 'package:ahoruna/src/features/categories/presentation/providers/categories_dependencies.dart';

final categoriesProvider = StreamProvider<List<FinanceCategory>>((ref) async* {
  final ensureDefaults = ref.watch(ensureDefaultCategoriesUseCaseProvider);

  final watchCategories = ref.watch(watchCategoriesUseCaseProvider);

  await ensureDefaults();

  yield* watchCategories();
});

final categoryByIdProvider = FutureProvider.family<FinanceCategory, String>((
  ref,
  categoryId,
) {
  final getCategory = ref.watch(getCategoryUseCaseProvider);

  return getCategory(categoryId);
});

final categoriesControllerProvider =
    AsyncNotifierProvider<CategoriesController, void>(CategoriesController.new);
