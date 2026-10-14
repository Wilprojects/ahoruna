import 'package:firebase_core/firebase_core.dart';

import 'package:ahoruna/src/features/categories/domain/entities/finance_category.dart';
import 'package:ahoruna/src/features/categories/domain/failures/category_failure.dart';
import 'package:ahoruna/src/features/categories/domain/repositories/category_repository.dart';
import 'package:ahoruna/src/features/transactions/data/datasources/transactions_remote_data_source.dart';
import 'package:ahoruna/src/features/transactions/domain/entities/finance_transaction.dart';
import 'package:ahoruna/src/features/transactions/domain/failures/transaction_failure.dart';
import 'package:ahoruna/src/features/transactions/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  const TransactionRepositoryImpl(
    this._remoteDataSource,
    this._categoryRepository,
  );

  final TransactionsRemoteDataSource _remoteDataSource;

  final CategoryRepository _categoryRepository;

  @override
  Stream<List<FinanceTransaction>> watchTransactions() async* {
    try {
      await for (final transactions in _remoteDataSource.watchTransactions()) {
        yield transactions;
      }
    } on StateError {
      throw const TransactionFailure('No existe una sesión activa.');
    } on FirebaseException {
      throw const TransactionFailure('No pudimos cargar tus movimientos.');
    }
  }

  @override
  Future<FinanceTransaction> getTransaction(String transactionId) async {
    try {
      return await _remoteDataSource.getTransaction(transactionId);
    } on StateError {
      throw const TransactionFailure('El movimiento no existe.');
    } on FirebaseException {
      throw const TransactionFailure('No pudimos cargar el movimiento.');
    }
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
    try {
      final cleanDescription = description.trim();

      final cleanNote = note?.trim();

      _validateBasicData(
        amount: amount,
        currency: currency,
        description: cleanDescription,
        date: date,
      );

      await _validateCategory(categoryId: categoryId, type: type);

      await _remoteDataSource.createTransaction(
        type: type,
        amount: _normalizeAmount(amount),
        currency: currency.trim().toUpperCase(),
        description: cleanDescription,
        categoryId: categoryId,
        date: date,
        note: cleanNote == null || cleanNote.isEmpty ? null : cleanNote,
      );
    } on TransactionFailure {
      rethrow;
    } on CategoryFailure {
      throw const TransactionFailure(
        'La categoría seleccionada '
        'no está disponible.',
      );
    } on StateError {
      throw const TransactionFailure('No existe una sesión activa.');
    } on FirebaseException {
      throw const TransactionFailure('No pudimos crear el movimiento.');
    }
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
    try {
      final cleanDescription = description.trim();

      final cleanNote = note?.trim();

      _validateBasicData(
        amount: amount,
        currency: currency,
        description: cleanDescription,
        date: date,
      );

      await _validateCategory(categoryId: categoryId, type: type);

      await _remoteDataSource.updateTransaction(
        transactionId: transactionId,
        type: type,
        amount: _normalizeAmount(amount),
        currency: currency.trim().toUpperCase(),
        description: cleanDescription,
        categoryId: categoryId,
        date: date,
        note: cleanNote == null || cleanNote.isEmpty ? null : cleanNote,
      );
    } on TransactionFailure {
      rethrow;
    } on CategoryFailure {
      throw const TransactionFailure(
        'La categoría seleccionada '
        'no está disponible.',
      );
    } on StateError {
      throw const TransactionFailure('El movimiento no existe.');
    } on FirebaseException {
      throw const TransactionFailure('No pudimos actualizar el movimiento.');
    }
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _remoteDataSource.deleteTransaction(transactionId);
    } on StateError {
      throw const TransactionFailure('El movimiento no existe.');
    } on FirebaseException {
      throw const TransactionFailure('No pudimos eliminar el movimiento.');
    }
  }

  Future<void> _validateCategory({
    required String categoryId,
    required TransactionType type,
  }) async {
    final category = await _categoryRepository.getCategory(categoryId);

    if (!category.isActive) {
      throw const TransactionFailure(
        'La categoría seleccionada '
        'ya no está disponible.',
      );
    }

    final isCompatible = switch (type) {
      TransactionType.expense =>
        category.type == CategoryType.expense ||
            category.type == CategoryType.both,
      TransactionType.income =>
        category.type == CategoryType.income ||
            category.type == CategoryType.both,
    };

    if (!isCompatible) {
      throw const TransactionFailure(
        'La categoría seleccionada no corresponde '
        'al tipo de movimiento.',
      );
    }
  }

  void _validateBasicData({
    required double amount,
    required String currency,
    required String description,
    required DateTime date,
  }) {
    if (amount <= 0) {
      throw const TransactionFailure('El monto debe ser mayor a 0.');
    }

    if (currency.trim().isEmpty) {
      throw const TransactionFailure('La moneda no es válida.');
    }

    if (description.isEmpty) {
      throw const TransactionFailure('La descripción es obligatoria.');
    }

    final today = DateTime.now();

    final todayOnly = DateTime(today.year, today.month, today.day);

    final transactionDate = DateTime(date.year, date.month, date.day);

    if (transactionDate.isAfter(todayOnly)) {
      throw const TransactionFailure(
        'La fecha del movimiento '
        'no puede ser futura.',
      );
    }
  }

  double _normalizeAmount(double amount) {
    return (amount * 100).round() / 100;
  }
}
