import 'package:firebase_core/firebase_core.dart';

import 'package:ahoruna/src/features/categories/data/datasources/categories_remote_data_source.dart';
import 'package:ahoruna/src/features/categories/domain/entities/finance_category.dart';
import 'package:ahoruna/src/features/categories/domain/failures/category_failure.dart';
import 'package:ahoruna/src/features/categories/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl(this._remoteDataSource);

  final CategoriesRemoteDataSource _remoteDataSource;

  @override
  Stream<List<FinanceCategory>> watchCategories() async* {
    try {
      await for (final categories in _remoteDataSource.watchCategories()) {
        yield categories;
      }
    } on StateError {
      throw const CategoryFailure('No existe una sesión activa.');
    } on FirebaseException {
      throw const CategoryFailure('No pudimos cargar tus categorías.');
    }
  }

  @override
  Future<FinanceCategory> getCategory(String categoryId) async {
    try {
      return await _remoteDataSource.getCategory(categoryId);
    } on StateError {
      throw const CategoryFailure('La categoría no existe.');
    } on FirebaseException {
      throw const CategoryFailure('No pudimos cargar la categoría.');
    }
  }

  @override
  Future<void> ensureDefaultCategories() async {
    try {
      await _remoteDataSource.ensureDefaultCategories();
    } on StateError {
      throw const CategoryFailure('No existe una sesión activa.');
    } on FirebaseException {
      throw const CategoryFailure('No pudimos preparar tus categorías.');
    }
  }

  @override
  Future<void> createCategory({
    required String name,
    required String iconKey,
    required String colorHex,
    required CategoryType type,
  }) async {
    final cleanName = name.trim();
    final normalizedName = _normalizeName(cleanName);

    try {
      final exists = await _remoteDataSource.categoryNameExists(normalizedName);

      if (exists) {
        throw const CategoryFailure(
          'Ya existe una categoría con ese nombre.',
          code: 'duplicate-name',
        );
      }

      await _remoteDataSource.createCategory(
        name: cleanName,
        normalizedName: normalizedName,
        iconKey: iconKey,
        colorHex: colorHex,
        type: type,
      );
    } on CategoryFailure {
      rethrow;
    } on StateError {
      throw const CategoryFailure('No existe una sesión activa.');
    } on FirebaseException {
      throw const CategoryFailure('No pudimos crear la categoría.');
    }
  }

  @override
  Future<void> updateCategory({
    required String categoryId,
    required String name,
    required String iconKey,
    required String colorHex,
    required CategoryType type,
  }) async {
    final cleanName = name.trim();
    final normalizedName = _normalizeName(cleanName);

    try {
      final exists = await _remoteDataSource.categoryNameExists(
        normalizedName,
        excludingCategoryId: categoryId,
      );

      if (exists) {
        throw const CategoryFailure(
          'Ya existe una categoría con ese nombre.',
          code: 'duplicate-name',
        );
      }

      await _remoteDataSource.updateCategory(
        categoryId: categoryId,
        name: cleanName,
        normalizedName: normalizedName,
        iconKey: iconKey,
        colorHex: colorHex,
        type: type,
      );
    } on CategoryFailure {
      rethrow;
    } on StateError {
      throw const CategoryFailure('La categoría no existe.');
    } on FirebaseException {
      throw const CategoryFailure('No pudimos actualizar la categoría.');
    }
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    try {
      final category = await _remoteDataSource.getCategory(categoryId);

      if (category.isDefault) {
        throw const CategoryFailure(
          'Las categorías predeterminadas '
          'no se pueden eliminar.',
          code: 'default-category',
        );
      }

      await _remoteDataSource.deleteCategory(categoryId);
    } on CategoryFailure {
      rethrow;
    } on StateError {
      throw const CategoryFailure('La categoría no existe.');
    } on FirebaseException {
      throw const CategoryFailure('No pudimos eliminar la categoría.');
    }
  }

  String _normalizeName(String value) {
    return value.trim().toLowerCase();
  }
}
