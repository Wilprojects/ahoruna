import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ahoruna/src/core/constants/firestore_collections.dart';
import 'package:ahoruna/src/features/budgets/data/models/budget_model.dart';

abstract interface class BudgetsRemoteDataSource {
  Stream<List<BudgetModel>> watchBudgets({required String period});

  Future<BudgetModel> getBudget(String budgetId);

  Future<bool> budgetExists({
    required String categoryId,
    required String period,
    required String currency,
    String? excludingBudgetId,
  });

  Future<void> createBudget({
    required String categoryId,
    required double limitAmount,
    required String currency,
    required String period,
    required int alertPercent,
  });

  Future<void> updateBudget({
    required String budgetId,
    required String categoryId,
    required double limitAmount,
    required int alertPercent,
  });

  Future<void> deleteBudget(String budgetId);
}

class FirestoreBudgetsRemoteDataSource implements BudgetsRemoteDataSource {
  FirestoreBudgetsRemoteDataSource(this._firebaseAuth, this._firestore);

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  User _requireUser() {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw StateError('No existe un usuario autenticado.');
    }

    return user;
  }

  CollectionReference<Map<String, dynamic>> _budgetsReference() {
    final user = _requireUser();

    return _firestore
        .collection(FirestoreCollections.users)
        .doc(user.uid)
        .collection(FirestoreCollections.budgets);
  }

  @override
  Stream<List<BudgetModel>> watchBudgets({required String period}) {
    return _budgetsReference()
        .where('period', isEqualTo: period)
        .snapshots()
        .map((snapshot) {
          final budgets = snapshot.docs
              .map(BudgetModel.fromDocument)
              .where((budget) => budget.isActive)
              .toList();

          budgets.sort((first, second) {
            return first.categoryId.compareTo(second.categoryId);
          });

          return budgets;
        });
  }

  @override
  Future<BudgetModel> getBudget(String budgetId) async {
    final snapshot = await _budgetsReference().doc(budgetId).get();

    if (!snapshot.exists) {
      throw StateError('El presupuesto no existe.');
    }

    return BudgetModel.fromDocument(snapshot);
  }

  @override
  Future<bool> budgetExists({
    required String categoryId,
    required String period,
    required String currency,
    String? excludingBudgetId,
  }) async {
    final snapshot = await _budgetsReference()
        .where('period', isEqualTo: period)
        .get();

    final normalizedCurrency = currency.trim().toUpperCase();

    return snapshot.docs.any((document) {
      if (document.id == excludingBudgetId) {
        return false;
      }

      final data = document.data();

      final documentCurrency = (data['currency'] as String? ?? '')
          .trim()
          .toUpperCase();

      return data['categoryId'] == categoryId &&
          documentCurrency == normalizedCurrency &&
          (data['isActive'] as bool? ?? true);
    });
  }

  @override
  Future<void> createBudget({
    required String categoryId,
    required double limitAmount,
    required String currency,
    required String period,
    required int alertPercent,
  }) async {
    await _budgetsReference().add({
      'categoryId': categoryId,
      'limitAmount': limitAmount,
      'currency': currency.toUpperCase(),
      'period': period,
      'alertPercent': alertPercent,
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> updateBudget({
    required String budgetId,
    required String categoryId,
    required double limitAmount,
    required int alertPercent,
  }) async {
    await _budgetsReference().doc(budgetId).set({
      'categoryId': categoryId,
      'limitAmount': limitAmount,
      'alertPercent': alertPercent,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> deleteBudget(String budgetId) {
    return _budgetsReference().doc(budgetId).delete();
  }
}
