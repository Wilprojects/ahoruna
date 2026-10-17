import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ahoruna/src/app/router/app_routes.dart';
import 'package:ahoruna/src/app/theme/app_dimensions.dart';
import 'package:ahoruna/src/app/theme/app_gradients.dart';
import 'package:ahoruna/src/core/extensions/theme_extensions.dart';
import 'package:ahoruna/src/features/auth/presentation/providers/auth_providers.dart';
import 'package:ahoruna/src/features/categories/domain/entities/finance_category.dart';
import 'package:ahoruna/src/features/categories/presentation/providers/categories_providers.dart';
import 'package:ahoruna/src/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:ahoruna/src/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'package:ahoruna/src/features/dashboard/presentation/utils/dashboard_visuals.dart';
import 'package:ahoruna/src/features/transactions/domain/entities/finance_transaction.dart';
import 'package:ahoruna/src/features/transactions/presentation/providers/transactions_providers.dart';
import 'package:ahoruna/src/features/transactions/presentation/utils/transaction_visuals.dart';
import 'package:ahoruna/src/features/transactions/presentation/widgets/transaction_tile.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_app_bar.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_button.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_card.dart';
import 'package:ahoruna/src/shared/widgets/error_view.dart';
import 'package:ahoruna/src/shared/widgets/loading_view.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    final dashboard = ref.watch(dashboardSummaryProvider);

    final categories = ref.watch(categoriesProvider);

    final user = authState.when(
      data: (value) => value,
      loading: () => null,
      error: (error, stackTrace) => null,
    );

    final displayName = user?.displayName?.trim();

    final firstName = displayName != null && displayName.isNotEmpty
        ? displayName.split(RegExp(r'\s+')).first
        : null;

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
      appBar: AhorunaAppBar(
        title: 'Ahoruna',

        // Home es una pantalla principal del Shell.
        // Nunca debe mostrar flecha de regreso.
        showBackButton: false,

        actions: [
          IconButton(
            tooltip: 'Perfil',
            onPressed: () {
              // Perfil es un TAB principal.
              context.go(AppRoutes.profile);
            },
            icon: const Icon(Icons.person_outline_rounded),
          ),
          IconButton(
            tooltip: 'Configuración',
            onPressed: () {
              // Configuración es una pantalla secundaria.
              context.push(AppRoutes.settings);
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: dashboard.when(
        loading: () {
          return const LoadingView(
            message: 'Preparando tu resumen financiero...',
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: ErrorView(
              message: 'No pudimos cargar tu resumen financiero.',
              onRetry: () {
                ref.invalidate(transactionsProvider);
              },
            ),
          );
        },
        data: (summary) {
          return _DashboardContent(
            summary: summary,
            firstName: firstName,
            categoriesById: categoriesById,
          );
        },
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({
    required this.summary,
    required this.firstName,
    required this.categoriesById,
  });

  final DashboardSummary summary;
  final String? firstName;
  final Map<String, FinanceCategory> categoriesById;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

    return SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.pageHorizontalPadding,
          AppDimensions.spaceMd,
          AppDimensions.pageHorizontalPadding,
          AppDimensions.space3Xl,
        ),
        children: [
          Text(
            firstName == null ? 'Hola 👋' : 'Hola, $firstName 👋',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: AppDimensions.spaceXs),
          Text(
            'Tus finanzas, más simples.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.space2Xl),

          // ==================================================
          // BALANCE PRINCIPAL
          // ==================================================
          AhorunaCard(
            gradient: AppGradients.balance,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Balance disponible',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  TransactionVisuals.formatCurrencyValue(
                    summary.balance,
                    summary.currency,
                  ),
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Balance histórico en ${summary.currency}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.space2Xl),

          // ==================================================
          // RESUMEN DEL MES
          // ==================================================
          Row(
            children: [
              Text('Resumen del mes', style: theme.textTheme.titleMedium),
              const Spacer(),
              Text(
                DashboardVisuals.monthLabel(summary.periodDate),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.spaceMd),

          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  title: 'Ingresos',
                  value: TransactionVisuals.formatAmount(
                    summary.monthlyIncome,
                    summary.currency,
                    type: TransactionType.income,
                  ),
                  icon: Icons.south_west_rounded,
                  color: colors.income,
                ),
              ),
              const SizedBox(width: AppDimensions.spaceMd),
              Expanded(
                child: _MetricCard(
                  title: 'Gastos',
                  value: TransactionVisuals.formatAmount(
                    summary.monthlyExpense,
                    summary.currency,
                    type: TransactionType.expense,
                  ),
                  icon: Icons.north_east_rounded,
                  color: colors.expense,
                ),
              ),
            ],
          ),

          // ==================================================
          // AVISO DE OTRAS MONEDAS
          // ==================================================
          if (summary.otherCurrencyTransactionCount > 0) ...[
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
                      'Los totales muestran únicamente '
                      'movimientos en ${summary.currency}. '
                      '${summary.otherCurrencyTransactionCount} '
                      '${summary.otherCurrencyTransactionCount == 1 ? 'movimiento utiliza' : 'movimientos utilizan'} '
                      'otra moneda y no se '
                      '${summary.otherCurrencyTransactionCount == 1 ? 'incluye' : 'incluyen'} '
                      'en estos cálculos.',
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

          // ==================================================
          // ACCIONES RÁPIDAS
          // ==================================================
          Text('Acciones rápidas', style: theme.textTheme.titleMedium),

          const SizedBox(height: AppDimensions.spaceMd),

          AhorunaButton(
            label: 'Nuevo movimiento',
            icon: Icons.add_rounded,
            onPressed: () {
              // Pantalla secundaria.
              context.push(AppRoutes.transactionCreate);
            },
          ),

          const SizedBox(height: AppDimensions.spaceMd),

          Row(
            children: [
              // ----------------------------------------------
              // MOVIMIENTOS
              //
              // Es un TAB principal.
              // ----------------------------------------------

              Expanded(
                child: _QuickActionCard(
                  icon: Icons.receipt_long_outlined,
                  label: 'Movimientos',
                  onTap: () {
                    context.go(AppRoutes.transactions);
                  },
                ),
              ),

              const SizedBox(width: AppDimensions.spaceMd),

              // ----------------------------------------------
              // CATEGORÍAS
              //
              // Es una pantalla secundaria.
              // IMPORTANTE: debe usar PUSH y NO GO.
              // De esta forma queda Home en el stack y
              // Categorías puede volver atrás.
              // ----------------------------------------------
              Expanded(
                child: _QuickActionCard(
                  icon: Icons.category_outlined,
                  label: 'Categorías',
                  onTap: () {
                    context.push(AppRoutes.categories);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.spaceMd),

          // ----------------------------------------------
          // PRESUPUESTOS
          //
          // Es un TAB principal.
          // ----------------------------------------------
          AhorunaCard(
            showShadow: false,
            onTap: () {
              context.go(AppRoutes.budgets);
            },
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colors.primarySoft,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Presupuestos', style: theme.textTheme.labelLarge),
                      const SizedBox(height: 3),
                      Text(
                        'Define límites mensuales y '
                        'controla tus gastos.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: colors.textSecondary),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.space2Xl),

          // ==================================================
          // MOVIMIENTOS RECIENTES
          // ==================================================
          Row(
            children: [
              Expanded(
                child: Text(
                  'Movimientos recientes',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Movimientos es un TAB principal.
                  context.go(AppRoutes.transactions);
                },
                child: const Text('Ver todos'),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.spaceSm),

          if (summary.recentTransactions.isEmpty)
            AhorunaCard(
              showShadow: false,
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 44,
                    color: colors.textSecondary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Aún no tienes movimientos',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Registra tu primer ingreso o gasto '
                    'para comenzar a construir tu resumen.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          else
            ...summary.recentTransactions.map((transaction) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TransactionTile(
                  transaction: transaction,
                  category: categoriesById[transaction.categoryId],
                  onTap: () {
                    // Editar movimiento es una
                    // pantalla secundaria.
                    context.push(AppRoutes.transactionEditPath(transaction.id));
                  },
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

    return AhorunaCard(
      showShadow: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

    return AhorunaCard(
      showShadow: false,
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.primarySoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}
