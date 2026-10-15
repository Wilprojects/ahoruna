import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:ahoruna/src/features/dashboard/domain/usecases/calculate_dashboard_summary.dart';
import 'package:ahoruna/src/features/settings/presentation/providers/user_preferences_provider.dart';
import 'package:ahoruna/src/features/transactions/presentation/providers/transactions_providers.dart';

final calculateDashboardSummaryProvider = Provider<CalculateDashboardSummary>((
  ref,
) {
  return const CalculateDashboardSummary();
});

final dashboardSummaryProvider =
    Provider.autoDispose<AsyncValue<DashboardSummary>>((ref) {
      final transactions = ref.watch(transactionsProvider);

      final preferences = ref.watch(userPreferencesProvider);

      final calculator = ref.watch(calculateDashboardSummaryProvider);

      return preferences.when(
        loading: () {
          return const AsyncLoading();
        },
        error: (error, stackTrace) {
          return AsyncError(error, stackTrace);
        },
        data: (preferenceValues) {
          return transactions.when(
            loading: () {
              return const AsyncLoading();
            },
            error: (error, stackTrace) {
              return AsyncError(error, stackTrace);
            },
            data: (transactionValues) {
              return AsyncData(
                calculator(
                  transactions: transactionValues,
                  currency: preferenceValues.currencyCode,
                  now: DateTime.now(),
                ),
              );
            },
          );
        },
      );
    });
