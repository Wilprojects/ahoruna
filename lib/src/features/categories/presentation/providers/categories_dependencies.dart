import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/features/auth/presentation/providers/auth_dependencies.dart';
import 'package:ahoruna/src/features/categories/data/datasources/categories_remote_data_source.dart';
import 'package:ahoruna/src/features/categories/data/repositories/category_repository_impl.dart';
import 'package:ahoruna/src/features/categories/domain/repositories/category_repository.dart';
import 'package:ahoruna/src/features/categories/domain/usecases/create_category.dart';
import 'package:ahoruna/src/features/categories/domain/usecases/delete_category.dart';
import 'package:ahoruna/src/features/categories/domain/usecases/ensure_default_categories.dart';
import 'package:ahoruna/src/features/categories/domain/usecases/get_category.dart';
import 'package:ahoruna/src/features/categories/domain/usecases/update_category.dart';
import 'package:ahoruna/src/features/categories/domain/usecases/watch_categories.dart';

final categoriesRemoteDataSourceProvider = Provider<CategoriesRemoteDataSource>(
  (ref) {
    return FirestoreCategoriesRemoteDataSource(
      ref.watch(firebaseAuthProvider),
      ref.watch(firebaseFirestoreProvider),
    );
  },
);

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl(ref.watch(categoriesRemoteDataSourceProvider));
});

final watchCategoriesUseCaseProvider = Provider<WatchCategories>((ref) {
  return WatchCategories(ref.watch(categoryRepositoryProvider));
});

final getCategoryUseCaseProvider = Provider<GetCategory>((ref) {
  return GetCategory(ref.watch(categoryRepositoryProvider));
});

final ensureDefaultCategoriesUseCaseProvider =
    Provider<EnsureDefaultCategories>((ref) {
      return EnsureDefaultCategories(ref.watch(categoryRepositoryProvider));
    });

final createCategoryUseCaseProvider = Provider<CreateCategory>((ref) {
  return CreateCategory(ref.watch(categoryRepositoryProvider));
});

final updateCategoryUseCaseProvider = Provider<UpdateCategory>((ref) {
  return UpdateCategory(ref.watch(categoryRepositoryProvider));
});

final deleteCategoryUseCaseProvider = Provider<DeleteCategory>((ref) {
  return DeleteCategory(ref.watch(categoryRepositoryProvider));
});
