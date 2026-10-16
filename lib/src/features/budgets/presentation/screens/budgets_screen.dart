import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ahoruna/src/app/router/app_routes.dart';
import 'package:ahoruna/src/app/theme/app_dimensions.dart';
import 'package:ahoruna/src/core/extensions/theme_extensions.dart';
import 'package:ahoruna/src/features/budgets/domain/entities/budget_overview.dart';
import 'package:ahoruna/src/features/budgets/domain/utils/budget_period_utils.dart';
import 'package:ahoruna/src/features/budgets/presentation/providers/budgets_providers.dart';
import 'package:ahoruna/src/features/budgets/presentation/utils/budget_visuals.dart';
import 'package:ahoruna/src/features/budgets/presentation/widgets/budget_progress_card.dart';
import 'package:ahoruna/src/features/categories/domain/entities/finance_category.dart';
import 'package:ahoruna/src/features/categories/presentation/providers/categories_providers.dart';
import 'package:ahoruna/src/features/transactions/presentation/utils/transaction_visuals.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_app_bar.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_card.dart';
import 'package:ahoruna/src/shared/widgets/error_view.dart';
import 'package:ahoruna/src/shared/widgets/loading_view.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedBudgetPeriodProvider);

    final period = BudgetPeriodUtils.fromDate(selectedDate);

    final overview = ref.watch(selectedBudgetOverviewProvider);

    final categories = ref.watch(categoriesProvider);

    final categoriesById = categories.when(
      data: (values) {
        return <String, FinanceCategory>{
          for (final category in values) category.id: category,
        };
      },
      loading: () {
        return <String, FinanceCategory>{};
      },
      error: (error, stackTrace) {
        return <String, FinanceCategory>{};
      },
    );

    return Scaffold(
      appBar: const AhorunaAppBar(title: 'Presupuestos', showBackButton: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(AppRoutes.budgetCreatePath(period));
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nuevo presupuesto'),
      ),
      body: Column(
        children: [
          _PeriodSelector(date: selectedDate),
          Expanded(
            child: overview.when(
              loading: () {
                return const LoadingView(message: 'Calculando presupuestos...');
              },
              error: (error, stackTrace) {
                return Center(
                  child: ErrorView(
                    message: 'No pudimos cargar tus presupuestos.',
                    onRetry: () {
                      ref.invalidate(budgetsForPeriodProvider(period));
                    },
                  ),
                );
              },
              data: (value) {
                return _BudgetContent(
                  overview: value,
                  categoriesById: categoriesById,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodSelector extends ConsumerWidget {
  const _PeriodSelector({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = BudgetPeriodUtils.fromDate(date);

    final isCurrent = BudgetPeriodUtils.isCurrentMonth(date);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.pageHorizontalPadding,
        AppDimensions.spaceMd,
        AppDimensions.pageHorizontalPadding,
        AppDimensions.spaceSm,
      ),
      child: AhorunaCard(
        showShadow: false,
        child: Row(
          children: [
            IconButton(
              tooltip: 'Mes anterior',
              onPressed: () {
                ref.read(selectedBudgetPeriodProvider.notifier).previousMonth();
              },
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    BudgetVisuals.monthLabel(period),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (!isCurrent)
                    TextButton(
                      onPressed: () {
                        ref
                            .read(selectedBudgetPeriodProvider.notifier)
                            .currentMonth();
                      },
                      child: const Text('Volver al mes actual'),
                    ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Mes siguiente',
              onPressed: () {
                ref.read(selectedBudgetPeriodProvider.notifier).nextMonth();
              },
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class _BudgetContent extends StatelessWidget {
  const _BudgetContent({required this.overview, required this.categoriesById});

  final BudgetOverview overview;

  final Map<String, FinanceCategory> categoriesById;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.pageHorizontalPadding,
        AppDimensions.spaceSm,
        AppDimensions.pageHorizontalPadding,
        110,
      ),
      children: [
        AhorunaCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Presupuesto total',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                TransactionVisuals.formatCurrencyValue(
                  overview.totalLimit,
                  overview.currency,
                ),
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 18),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: overview.progressRatio,
                  minHeight: 9,
                  backgroundColor: colors.surfaceSecondary,
                  color:
                      overview.totalSpent > overview.totalLimit &&
                          overview.totalLimit > 0
                      ? colors.expense
                      : theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _SummaryValue(
                      title: 'Gastado',
                      value: TransactionVisuals.formatCurrencyValue(
                        overview.totalSpent,
                        overview.currency,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _SummaryValue(
                      title: overview.totalRemaining >= 0
                          ? 'Disponible'
                          : 'Excedido',
                      value: TransactionVisuals.formatCurrencyValue(
                        overview.totalRemaining.abs(),
                        overview.currency,
                      ),
                      alignRight: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (overview.warningCount > 0 || overview.exceededCount > 0) ...[
          const SizedBox(height: AppDimensions.spaceMd),
          AhorunaCard(
            showShadow: false,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: overview.exceededCount > 0
                      ? colors.expense
                      : colors.warning,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    overview.exceededCount > 0
                        ? '${overview.exceededCount} '
                              '${overview.exceededCount == 1 ? 'presupuesto ha' : 'presupuestos han'} '
                              'superado su límite.'
                        : '${overview.warningCount} '
                              '${overview.warningCount == 1 ? 'presupuesto está' : 'presupuestos están'} '
                              'cerca de alcanzar su límite.',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ],
        if (overview.otherCurrencyBudgetCount > 0) ...[
          const SizedBox(height: AppDimensions.spaceMd),
          AhorunaCard(
            showShadow: false,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${overview.otherCurrencyBudgetCount} '
                    '${overview.otherCurrencyBudgetCount == 1 ? 'presupuesto utiliza' : 'presupuestos utilizan'} '
                    'otra moneda. Los totales actuales '
                    'solo consideran ${overview.currency}.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppDimensions.space2Xl),
        Text('Por categoría', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppDimensions.spaceMd),
        if (overview.items.isEmpty)
          AhorunaCard(
            showShadow: false,
            child: Column(
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 48,
                  color: colors.textSecondary,
                ),
                const SizedBox(height: 14),
                Text(
                  'Aún no tienes presupuestos',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  'Crea un límite mensual para una '
                  'categoría y Ahoruna calculará '
                  'automáticamente cuánto has gastado.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          )
        else
          ...overview.items.map((progress) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: BudgetProgressCard(
                progress: progress,
                category: categoriesById[progress.budget.categoryId],
                onTap: () {
                  context.push(AppRoutes.budgetEditPath(progress.budget.id));
                },
              ),
            );
          }),
      ],
    );
  }
}

class _SummaryValue extends StatelessWidget {
  const _SummaryValue({
    required this.title,
    required this.value,
    this.alignRight = false,
  });

  final String title;
  final String value;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.titleMedium),
      ],
    );
  }
}
