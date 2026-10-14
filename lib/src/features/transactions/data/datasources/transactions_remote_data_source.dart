import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ahoruna/src/core/constants/firestore_collections.dart';
import 'package:ahoruna/src/features/transactions/data/models/transaction_model.dart';
import 'package:ahoruna/src/features/transactions/domain/entities/finance_transaction.dart';

abstract interface class TransactionsRemoteDataSource {
  Stream<List<TransactionModel>> watchTransactions();

  Future<TransactionModel> getTransaction(String transactionId);

  Future<void> createTransaction({
    required TransactionType type,
    required double amount,
    required String currency,
    required String description,
    required String categoryId,
    required DateTime date,
    String? note,
  });

  Future<void> updateTransaction({
    required String transactionId,
    required TransactionType type,
    required double amount,
    required String currency,
    required String description,
    required String categoryId,
    required DateTime date,
    String? note,
  });

  Future<void> deleteTransaction(String transactionId);
}

class FirestoreTransactionsRemoteDataSource
    implements TransactionsRemoteDataSource {
  FirestoreTransactionsRemoteDataSource(this._firebaseAuth, this._firestore);

  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  User _requireUser() {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw StateError('No existe un usuario autenticado.');
    }

    return user;
  }

  CollectionReference<Map<String, dynamic>> _transactionsReference() {
    final user = _requireUser();

    return _firestore
        .collection(FirestoreCollections.users)
        .doc(user.uid)
        .collection(FirestoreCollections.transactions);
  }

  @override
  Stream<List<TransactionModel>> watchTransactions() {
    return _transactionsReference()
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map(TransactionModel.fromDocument).toList();
        });
  }

  @override
  Future<TransactionModel> getTransaction(String transactionId) async {
    final snapshot = await _transactionsReference().doc(transactionId).get();

    if (!snapshot.exists) {
      throw StateError('El movimiento no existe.');
    }

    return TransactionModel.fromDocument(snapshot);
  }

  @override
  Future<void> createTransaction({
    required TransactionType type,
    required double amount,
    required String currency,
    required String description,
    required String categoryId,
    required DateTime date,
    String? note,
  }) async {
    await _transactionsReference().add({
      'type': type.name,
      'amount': amount,
      'currency': currency,
      'description': description,
      'categoryId': categoryId,
      'date': Timestamp.fromDate(date),
      'note': note,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> updateTransaction({
    required String transactionId,
    required TransactionType type,
    required double amount,
    required String currency,
    required String description,
    required String categoryId,
    required DateTime date,
    String? note,
  }) async {
    await _transactionsReference().doc(transactionId).set({
      'type': type.name,
      'amount': amount,
      'currency': currency,
      'description': description,
      'categoryId': categoryId,
      'date': Timestamp.fromDate(date),
      'note': note,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<void> deleteTransaction(String transactionId) {
    return _transactionsReference().doc(transactionId).delete();
  }
}
