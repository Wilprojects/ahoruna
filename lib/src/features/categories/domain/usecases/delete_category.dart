import 'package:ahoruna/src/features/categories/domain/repositories/category_repository.dart';

class DeleteCategory {
  const DeleteCategory(this._repository);

  final CategoryRepository _repository;

  Future<void> call(String categoryId) {
    return _repository.deleteCategory(categoryId);
  }
}
