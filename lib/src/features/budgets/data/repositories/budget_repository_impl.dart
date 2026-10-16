import 'package:firebase_core/firebase_core.dart';

import 'package:ahoruna/src/features/budgets/data/datasources/budgets_remote_data_source.dart';
import 'package:ahoruna/src/features/budgets/domain/entities/budget.dart';
import 'package:ahoruna/src/features/budgets/domain/failures/budget_failure.dart';
import 'package:ahoruna/src/features/budgets/domain/repositories/budget_repository.dart';
import 'package:ahoruna/src/features/budgets/domain/utils/budget_period_utils.dart';
import 'package:ahoruna/src/features/categories/domain/entities/finance_category.dart';
import 'package:ahoruna/src/features/categories/domain/failures/category_failure.dart';
import 'package:ahoruna/src/features/categories/domain/repositories/category_repository.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  const BudgetRepositoryImpl(this._remoteDataSource, this._categoryRepository);

  final BudgetsRemoteDataSource _remoteDataSource;

  final CategoryRepository _categoryRepository;

  @override
  Stream<List<Budget>> watchBudgets({required String period}) async* {
    try {
      await for (final budgets in _remoteDataSource.watchBudgets(
        period: period,
      )) {
        yield budgets;
      }
    } on StateError {
      throw const BudgetFailure('No existe una sesión activa.');
    } on FirebaseException {
      throw const BudgetFailure('No pudimos cargar tus presupuestos.');
    }
  }

  @override
  Future<Budget> getBudget(String budgetId) async {
    try {
      return await _remoteDataSource.getBudget(budgetId);
    } on StateError {
      throw const BudgetFailure('El presupuesto no existe.');
    } on FirebaseException {
      throw const BudgetFailure('No pudimos cargar el presupuesto.');
    }
  }

  @override
  Future<void> createBudget({
    required String categoryId,
    required double limitAmount,
    required String currency,
    required String period,
    required int alertPercent,
  }) async {
    try {
      _validateBasicData(
        limitAmount: limitAmount,
        currency: currency,
        period: period,
        alertPercent: alertPercent,
      );

      await _validateCategory(categoryId);

      final normalizedCurrency = currency.trim().toUpperCase();

      final exists = await _remoteDataSource.budgetExists(
        categoryId: categoryId,
        period: period,
        currency: normalizedCurrency,
      );

      if (exists) {
        throw const BudgetFailure(
          'Ya existe un presupuesto '
          'para esta categoría en el '
          'período seleccionado.',
          code: 'duplicate-budget',
        );
      }

      await _remoteDataSource.createBudget(
        categoryId: categoryId,
        limitAmount: _normalizeAmount(limitAmount),
        currency: normalizedCurrency,
        period: period,
        alertPercent: alertPercent,
      );
    } on BudgetFailure {
      rethrow;
    } on CategoryFailure {
      throw const BudgetFailure(
        'La categoría seleccionada '
        'no está disponible.',
      );
    } on StateError {
      throw const BudgetFailure('No existe una sesión activa.');
    } on FirebaseException {
      throw const BudgetFailure('No pudimos crear el presupuesto.');
    }
  }

  @override
  Future<void> updateBudget({
    required String budgetId,
    required String categoryId,
    required double limitAmount,
    required int alertPercent,
  }) async {
    try {
      final current = await _remoteDataSource.getBudget(budgetId);

      _validateBasicData(
        limitAmount: limitAmount,
        currency: current.currency,
        period: current.period,
        alertPercent: alertPercent,
      );

      await _validateCategory(categoryId);

      final exists = await _remoteDataSource.budgetExists(
        categoryId: categoryId,
        period: current.period,
        currency: current.currency,
        excludingBudgetId: budgetId,
      );

      if (exists) {
        throw const BudgetFailure(
          'Ya existe otro presupuesto '
          'para esta categoría en el '
          'mismo período.',
          code: 'duplicate-budget',
        );
      }

      await _remoteDataSource.updateBudget(
        budgetId: budgetId,
        categoryId: categoryId,
        limitAmount: _normalizeAmount(limitAmount),
        alertPercent: alertPercent,
      );
    } on BudgetFailure {
      rethrow;
    } on CategoryFailure {
      throw const BudgetFailure(
        'La categoría seleccionada '
        'no está disponible.',
      );
    } on StateError {
      throw const BudgetFailure('El presupuesto no existe.');
    } on FirebaseException {
      throw const BudgetFailure('No pudimos actualizar el presupuesto.');
    }
  }

  @override
  Future<void> deleteBudget(String budgetId) async {
    try {
      await _remoteDataSource.getBudget(budgetId);

      await _remoteDataSource.deleteBudget(budgetId);
    } on StateError {
      throw const BudgetFailure('El presupuesto no existe.');
    } on FirebaseException {
      throw const BudgetFailure('No pudimos eliminar el presupuesto.');
    }
  }

  Future<void> _validateCategory(String categoryId) async {
    final category = await _categoryRepository.getCategory(categoryId);

    if (!category.isActive) {
      throw const BudgetFailure('La categoría ya no está disponible.');
    }

    if (category.type == CategoryType.income) {
      throw const BudgetFailure(
        'Los presupuestos solo pueden '
        'utilizar categorías de gastos.',
      );
    }
  }

  void _validateBasicData({
    required double limitAmount,
    required String currency,
    required String period,
    required int alertPercent,
  }) {
    if (limitAmount <= 0) {
      throw const BudgetFailure('El límite debe ser mayor a 0.');
    }

    if (currency.trim().isEmpty) {
      throw const BudgetFailure('La moneda no es válida.');
    }

    try {
      BudgetPeriodUtils.parse(period);
    } on FormatException {
      throw const BudgetFailure(
        'El período del presupuesto '
        'no es válido.',
      );
    }

    if (alertPercent < 1 || alertPercent > 100) {
      throw const BudgetFailure(
        'El porcentaje de alerta '
        'no es válido.',
      );
    }
  }

  double _normalizeAmount(double amount) {
    return (amount * 100).round() / 100;
  }
}
