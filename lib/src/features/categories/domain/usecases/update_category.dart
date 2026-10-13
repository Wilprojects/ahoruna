import 'package:ahoruna/src/features/categories/domain/entities/finance_category.dart';
import 'package:ahoruna/src/features/categories/domain/repositories/category_repository.dart';

class UpdateCategory {
  const UpdateCategory(this._repository);

  final CategoryRepository _repository;

  Future<void> call({
    required String categoryId,
    required String name,
    required String iconKey,
    required String colorHex,
    required CategoryType type,
  }) {
    return _repository.updateCategory(
      categoryId: categoryId,
      name: name,
      iconKey: iconKey,
      colorHex: colorHex,
      type: type,
    );
  }
}
