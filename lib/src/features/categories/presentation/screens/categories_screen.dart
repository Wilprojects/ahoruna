import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ahoruna/src/app/router/app_routes.dart';
import 'package:ahoruna/src/app/theme/app_dimensions.dart';
import 'package:ahoruna/src/core/extensions/theme_extensions.dart';
import 'package:ahoruna/src/features/categories/domain/entities/finance_category.dart';
import 'package:ahoruna/src/features/categories/presentation/providers/categories_providers.dart';
import 'package:ahoruna/src/features/categories/presentation/widgets/category_tile.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_app_bar.dart';
import 'package:ahoruna/src/shared/widgets/error_view.dart';
import 'package:ahoruna/src/shared/widgets/loading_view.dart';

enum _CategoryFilter { all, expense, income }

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() {
    return _CategoriesScreenState();
  }
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  _CategoryFilter _filter = _CategoryFilter.all;

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: const AhorunaAppBar(title: 'Categorías', showBackButton: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(AppRoutes.categoryCreate);
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nueva categoría'),
      ),
      body: categories.when(
        loading: () {
          return const LoadingView(message: 'Cargando categorías...');
        },
        error: (error, stackTrace) {
          return Center(
            child: ErrorView(
              message: 'No pudimos cargar tus categorías.',
              onRetry: () {
                ref.invalidate(categoriesProvider);
              },
            ),
          );
        },
        data: (values) {
          return _buildContent(context, values);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, List<FinanceCategory> categories) {
    final filtered = categories.where((category) {
      switch (_filter) {
        case _CategoryFilter.all:
          return true;

        case _CategoryFilter.expense:
          return category.type == CategoryType.expense ||
              category.type == CategoryType.both;

        case _CategoryFilter.income:
          return category.type == CategoryType.income ||
              category.type == CategoryType.both;
      }
    }).toList();

    return SafeArea(
      top: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.pageHorizontalPadding,
              12,
              AppDimensions.pageHorizontalPadding,
              12,
            ),
            child: SegmentedButton<_CategoryFilter>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: _CategoryFilter.all, label: Text('Todas')),
                ButtonSegment(
                  value: _CategoryFilter.expense,
                  label: Text('Gastos'),
                ),
                ButtonSegment(
                  value: _CategoryFilter.income,
                  label: Text('Ingresos'),
                ),
              ],
              selected: {_filter},
              onSelectionChanged: (selection) {
                setState(() {
                  _filter = selection.first;
                });
              },
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? _EmptyCategories(filter: _filter)
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.pageHorizontalPadding,
                      8,
                      AppDimensions.pageHorizontalPadding,
                      100,
                    ),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 10);
                    },
                    itemBuilder: (context, index) {
                      final category = filtered[index];

                      return CategoryTile(
                        category: category,
                        onTap: () {
                          context.push(AppRoutes.categoryEditPath(category.id));
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCategories extends StatelessWidget {
  const _EmptyCategories({required this.filter});

  final _CategoryFilter filter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

    final message = switch (filter) {
      _CategoryFilter.all => 'Todavía no tienes categorías.',
      _CategoryFilter.expense => 'No hay categorías de gastos.',
      _CategoryFilter.income => 'No hay categorías de ingresos.',
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.category_outlined,
              size: 52,
              color: colors.textSecondary,
            ),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
