import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/features/auth/presentation/providers/auth_dependencies.dart';
import 'package:ahoruna/src/features/categories/presentation/providers/categories_dependencies.dart';
import 'package:ahoruna/src/features/transactions/data/datasources/transactions_remote_data_source.dart';
import 'package:ahoruna/src/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:ahoruna/src/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:ahoruna/src/features/transactions/domain/usecases/create_transaction.dart';
import 'package:ahoruna/src/features/transactions/domain/usecases/delete_transaction.dart';
import 'package:ahoruna/src/features/transactions/domain/usecases/get_transaction.dart';
import 'package:ahoruna/src/features/transactions/domain/usecases/update_transaction.dart';
import 'package:ahoruna/src/features/transactions/domain/usecases/watch_transactions.dart';

import 'package:ahoruna/src/features/transactions/domain/usecases/filter_transactions.dart';

final transactionsRemoteDataSourceProvider =
    Provider<TransactionsRemoteDataSource>((ref) {
      return FirestoreTransactionsRemoteDataSource(
        ref.watch(firebaseAuthProvider),
        ref.watch(firebaseFirestoreProvider),
      );
    });

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepositoryImpl(
    ref.watch(transactionsRemoteDataSourceProvider),
    ref.watch(categoryRepositoryProvider),
  );
});

final watchTransactionsUseCaseProvider = Provider<WatchTransactions>((ref) {
  return WatchTransactions(ref.watch(transactionRepositoryProvider));
});

final getTransactionUseCaseProvider = Provider<GetTransaction>((ref) {
  return GetTransaction(ref.watch(transactionRepositoryProvider));
});

final createTransactionUseCaseProvider = Provider<CreateTransaction>((ref) {
  return CreateTransaction(ref.watch(transactionRepositoryProvider));
});

final updateTransactionUseCaseProvider = Provider<UpdateTransaction>((ref) {
  return UpdateTransaction(ref.watch(transactionRepositoryProvider));
});

final deleteTransactionUseCaseProvider = Provider<DeleteTransaction>((ref) {
  return DeleteTransaction(ref.watch(transactionRepositoryProvider));
});

final filterTransactionsUseCaseProvider = Provider<FilterTransactions>((ref) {
  return const FilterTransactions();
});
