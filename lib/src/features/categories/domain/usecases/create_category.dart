import 'package:ahoruna/src/features/categories/domain/entities/finance_category.dart';
import 'package:ahoruna/src/features/categories/domain/repositories/category_repository.dart';

class CreateCategory {
  const CreateCategory(this._repository);

  final CategoryRepository _repository;

  Future<void> call({
    required String name,
    required String iconKey,
    required String colorHex,
    required CategoryType type,
  }) {
    return _repository.createCategory(
      name: name,
      iconKey: iconKey,
      colorHex: colorHex,
      type: type,
    );
  }
}
