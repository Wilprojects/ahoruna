import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/features/auth/presentation/providers/auth_dependencies.dart';
import 'package:ahoruna/src/features/budgets/data/datasources/budgets_remote_data_source.dart';
import 'package:ahoruna/src/features/budgets/data/repositories/budget_repository_impl.dart';
import 'package:ahoruna/src/features/budgets/domain/repositories/budget_repository.dart';
import 'package:ahoruna/src/features/budgets/domain/usecases/calculate_budget_overview.dart';
import 'package:ahoruna/src/features/budgets/domain/usecases/create_budget.dart';
import 'package:ahoruna/src/features/budgets/domain/usecases/delete_budget.dart';
import 'package:ahoruna/src/features/budgets/domain/usecases/get_budget.dart';
import 'package:ahoruna/src/features/budgets/domain/usecases/update_budget.dart';
import 'package:ahoruna/src/features/budgets/domain/usecases/watch_budgets.dart';
import 'package:ahoruna/src/features/categories/presentation/providers/categories_dependencies.dart';

final budgetsRemoteDataSourceProvider = Provider<BudgetsRemoteDataSource>((
  ref,
) {
  return FirestoreBudgetsRemoteDataSource(
    ref.watch(firebaseAuthProvider),
    ref.watch(firebaseFirestoreProvider),
  );
});

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepositoryImpl(
    ref.watch(budgetsRemoteDataSourceProvider),
    ref.watch(categoryRepositoryProvider),
  );
});

final watchBudgetsUseCaseProvider = Provider<WatchBudgets>((ref) {
  return WatchBudgets(ref.watch(budgetRepositoryProvider));
});

final getBudgetUseCaseProvider = Provider<GetBudget>((ref) {
  return GetBudget(ref.watch(budgetRepositoryProvider));
});

final createBudgetUseCaseProvider = Provider<CreateBudget>((ref) {
  return CreateBudget(ref.watch(budgetRepositoryProvider));
});

final updateBudgetUseCaseProvider = Provider<UpdateBudget>((ref) {
  return UpdateBudget(ref.watch(budgetRepositoryProvider));
});

final deleteBudgetUseCaseProvider = Provider<DeleteBudget>((ref) {
  return DeleteBudget(ref.watch(budgetRepositoryProvider));
});

final calculateBudgetOverviewProvider = Provider<CalculateBudgetOverview>((
  ref,
) {
  return const CalculateBudgetOverview();
});
