import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ahoruna/src/core/constants/firestore_collections.dart';
import 'package:ahoruna/src/features/categories/data/models/category_model.dart';
import 'package:ahoruna/src/features/categories/data/seeds/default_categories.dart';
import 'package:ahoruna/src/features/categories/domain/entities/finance_category.dart';

abstract interface class CategoriesRemoteDataSource {
  Stream<List<CategoryModel>> watchCategories();

  Future<CategoryModel> getCategory(String categoryId);

  Future<bool> categoryNameExists(
    String normalizedName, {
    String? excludingCategoryId,
  });

  Future<void> ensureDefaultCategories();

  Future<void> createCategory({
    required String name,
    required String normalizedName,
    required String iconKey,
    required String colorHex,
    required CategoryType type,
  });

  Future<void> updateCategory({
    required String categoryId,
    required String name,
    required String normalizedName,
    required String iconKey,
    required String colorHex,
    required CategoryType type,
  });

  Future<void> deleteCategory(String categoryId);
}

class FirestoreCategoriesRemoteDataSource
    implements CategoriesRemoteDataSource {
  FirestoreCategoriesRemoteDataSource(this._firebaseAuth, this._firestore);

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  User _requireUser() {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw StateError('No existe un usuario autenticado.');
    }

    return user;
  }

  CollectionReference<Map<String, dynamic>> _categoriesReference() {
    final user = _requireUser();

    return _firestore
        .collection(FirestoreCollections.users)
        .doc(user.uid)
        .collection(FirestoreCollections.categories);
  }

  @override
  Stream<List<CategoryModel>> watchCategories() {
    return _categoriesReference().snapshots().map((snapshot) {
      final categories = snapshot.docs
          .map(CategoryModel.fromDocument)
          .where((category) => category.isActive)
          .toList();

      categories.sort((first, second) {
        final firstDefault = first.isDefault ? 0 : 1;

        final secondDefault = second.isDefault ? 0 : 1;

        final defaultComparison = firstDefault.compareTo(secondDefault);

        if (defaultComparison != 0) {
          return defaultComparison;
        }

        return first.name.toLowerCase().compareTo(second.name.toLowerCase());
      });

      return categories;
    });
  }

  @override
  Future<CategoryModel> getCategory(String categoryId) async {
    final snapshot = await _categoriesReference().doc(categoryId).get();

    if (!snapshot.exists) {
      throw StateError('La categoría no existe.');
    }

    return CategoryModel.fromDocument(snapshot);
  }

  @override
  Future<bool> categoryNameExists(
    String normalizedName, {
    String? excludingCategoryId,
  }) async {
    final snapshot = await _categoriesReference()
        .where('nameNormalized', isEqualTo: normalizedName)
        .get();

    return snapshot.docs.any((document) {
      return document.id != excludingCategoryId;
    });
  }

  @override
  Future<void> ensureDefaultCategories() async {
    final reference = _categoriesReference();

    final existingSnapshot = await reference.get();

    final existingIds = existingSnapshot.docs
        .map((document) => document.id)
        .toSet();

    final batch = _firestore.batch();

    var hasChanges = false;

    for (final category in defaultCategoryDefinitions) {
      if (existingIds.contains(category.id)) {
        continue;
      }

      hasChanges = true;

      final document = reference.doc(category.id);

      batch.set(document, {
        'name': category.name,
        'nameNormalized': _normalizeName(category.name),
        'iconKey': category.iconKey,
        'colorHex': category.colorHex,
        'type': category.type.name,
        'isDefault': true,
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    if (hasChanges) {
      await batch.commit();
    }
  }

  @override
  Future<void> createCategory({
    required String name,
    required String normalizedName,
    required String iconKey,
    required String colorHex,
    required CategoryType type,
  }) async {
    await _categoriesReference().add({
      'name': name,
      'nameNormalized': normalizedName,
      'iconKey': iconKey,
      'colorHex': colorHex,
      'type': type.name,
      'isDefault': false,
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> updateCategory({
    required String categoryId,
    required String name,
    required String normalizedName,
    required String iconKey,
    required String colorHex,
    required CategoryType type,
  }) async {
    await _categoriesReference().doc(categoryId).set({
      'name': name,
      'nameNormalized': normalizedName,
      'iconKey': iconKey,
      'colorHex': colorHex,
      'type': type.name,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> deleteCategory(String categoryId) {
    return _categoriesReference().doc(categoryId).delete();
  }

  String _normalizeName(String value) {
    return value.trim().toLowerCase();
  }
}
