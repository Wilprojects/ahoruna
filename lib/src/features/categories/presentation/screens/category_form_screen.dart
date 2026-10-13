import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ahoruna/src/app/theme/app_dimensions.dart';
import 'package:ahoruna/src/core/extensions/theme_extensions.dart';
import 'package:ahoruna/src/core/utils/validators.dart';
import 'package:ahoruna/src/features/categories/domain/entities/finance_category.dart';
import 'package:ahoruna/src/features/categories/domain/failures/category_failure.dart';
import 'package:ahoruna/src/features/categories/presentation/providers/categories_providers.dart';
import 'package:ahoruna/src/features/categories/presentation/utils/category_visuals.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_app_bar.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_button.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_card.dart';
import 'package:ahoruna/src/shared/widgets/ahoruna_text_field.dart';
import 'package:ahoruna/src/shared/widgets/error_view.dart';
import 'package:ahoruna/src/shared/widgets/loading_view.dart';

class CategoryFormScreen extends ConsumerWidget {
  const CategoryFormScreen({this.categoryId, super.key});

  final String? categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = categoryId != null;

    return Scaffold(
      appBar: AhorunaAppBar(
        title: isEditing ? 'Editar categoría' : 'Nueva categoría',
        showBackButton: true,
      ),
      body: categoryId == null
          ? const _CategoryEditor()
          : ref
                .watch(categoryByIdProvider(categoryId!))
                .when(
                  loading: () {
                    return const LoadingView(message: 'Cargando categoría...');
                  },
                  error: (error, stackTrace) {
                    return Center(
                      child: ErrorView(
                        message: 'No pudimos cargar la categoría.',
                        onRetry: () {
                          ref.invalidate(categoryByIdProvider(categoryId!));
                        },
                      ),
                    );
                  },
                  data: (category) {
                    return _CategoryEditor(
                      key: ValueKey(category.id),
                      category: category,
                    );
                  },
                ),
    );
  }
}

class _CategoryEditor extends ConsumerStatefulWidget {
  const _CategoryEditor({this.category, super.key});

  final FinanceCategory? category;

  @override
  ConsumerState<_CategoryEditor> createState() {
    return _CategoryEditorState();
  }
}

class _CategoryEditorState extends ConsumerState<_CategoryEditor> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;

  late CategoryType _type;
  late String _iconKey;
  late String _colorHex;

  bool get _isEditing => widget.category != null;

  @override
  void initState() {
    super.initState();

    final category = widget.category;

    _nameController = TextEditingController(text: category?.name ?? '');

    _type = category?.type ?? CategoryType.expense;

    _iconKey = category?.iconKey ?? 'category';

    _colorHex = category?.colorHex ?? '#5B5CF0';
  }

  void _onNameChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);

    _nameController.dispose();

    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final controller = ref.read(categoriesControllerProvider.notifier);

      if (_isEditing) {
        await controller.updateCategory(
          categoryId: widget.category!.id,
          name: _nameController.text,
          iconKey: _iconKey,
          colorHex: _colorHex,
          type: _type,
        );
      } else {
        await controller.createCategory(
          name: _nameController.text,
          iconKey: _iconKey,
          colorHex: _colorHex,
          type: _type,
        );
      }

      if (!mounted) {
        return;
      }

      context.pop();
    } on CategoryFailure catch (error) {
      if (!mounted) {
        return;
      }

      _showError(error.message);
    }
  }

  Future<void> _delete() async {
    final category = widget.category;

    if (category == null || category.isDefault) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar categoría'),
          content: Text(
            '¿Deseas eliminar "${category.name}"? '
            'Esta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    try {
      await ref
          .read(categoriesControllerProvider.notifier)
          .deleteCategory(category.id);

      if (!mounted) {
        return;
      }

      context.pop();
    } on CategoryFailure catch (error) {
      if (!mounted) {
        return;
      }

      _showError(error.message);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.ahorunaColors;

    final controller = ref.watch(categoriesControllerProvider);

    final isLoading = controller.isLoading;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.pageHorizontalPadding),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppDimensions.maxContentWidth,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AhorunaTextField(
                    label: 'Nombre de la categoría',
                    hintText: 'Ej. Mascotas',
                    controller: _nameController,
                    prefixIcon: Icons.edit_outlined,
                    textInputAction: TextInputAction.done,
                    validator: Validators.categoryName,
                  ),
                  const SizedBox(height: 24),
                  Text('Tipo', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 10),
                  SegmentedButton<CategoryType>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(
                        value: CategoryType.expense,
                        icon: Icon(Icons.arrow_upward_rounded),
                        label: Text('Gasto'),
                      ),
                      ButtonSegment(
                        value: CategoryType.income,
                        icon: Icon(Icons.arrow_downward_rounded),
                        label: Text('Ingreso'),
                      ),
                      ButtonSegment(
                        value: CategoryType.both,
                        icon: Icon(Icons.swap_vert_rounded),
                        label: Text('Ambos'),
                      ),
                    ],
                    selected: {_type},
                    onSelectionChanged: isLoading
                        ? null
                        : (selection) {
                            setState(() {
                              _type = selection.first;
                            });
                          },
                  ),
                  const SizedBox(height: 26),
                  Text('Icono', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: CategoryVisuals.icons.entries.map((entry) {
                      final selected = entry.key == _iconKey;

                      return InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: isLoading
                            ? null
                            : () {
                                setState(() {
                                  _iconKey = entry.key;
                                });
                              },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: selected
                                ? colors.primarySoft
                                : colors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: selected
                                  ? theme.colorScheme.primary
                                  : colors.border,
                            ),
                          ),
                          child: Icon(
                            entry.value,
                            color: selected
                                ? theme.colorScheme.primary
                                : colors.textSecondary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 26),
                  Text('Color', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: CategoryVisuals.colorHexes.map((colorHex) {
                      final color = CategoryVisuals.colorFromHex(colorHex);

                      final selected = colorHex == _colorHex;

                      return InkWell(
                        customBorder: const CircleBorder(),
                        onTap: isLoading
                            ? null
                            : () {
                                setState(() {
                                  _colorHex = colorHex;
                                });
                              },
                        child: Container(
                          width: 42,
                          height: 42,
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selected
                                  ? theme.colorScheme.primary
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: color,
                            ),
                            child: selected
                                ? const Icon(
                                    Icons.check_rounded,
                                    size: 20,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),
                  AhorunaCard(
                    showShadow: false,
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: CategoryVisuals.colorFromHex(_colorHex)
                                .withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            CategoryVisuals.iconFor(_iconKey),
                            color: CategoryVisuals.colorFromHex(_colorHex),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _nameController.text.trim().isEmpty
                                    ? 'Vista previa'
                                    : _nameController.text.trim(),
                                style: theme.textTheme.titleSmall,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                CategoryVisuals.typeLabel(_type),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  AhorunaButton(
                    label: _isEditing ? 'Guardar cambios' : 'Crear categoría',
                    icon: _isEditing ? Icons.save_outlined : Icons.add_rounded,
                    isLoading: isLoading,
                    onPressed: isLoading ? null : _save,
                  ),
                  if (_isEditing) ...[
                    const SizedBox(height: 16),
                    if (widget.category!.isDefault)
                      Text(
                        'Esta es una categoría predeterminada. '
                        'Puedes personalizarla, pero no eliminarla.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.textSecondary,
                        ),
                      )
                    else
                      AhorunaButton(
                        label: 'Eliminar categoría',
                        icon: Icons.delete_outline_rounded,
                        variant: AhorunaButtonVariant.danger,
                        isLoading: isLoading,
                        onPressed: isLoading ? null : _delete,
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
