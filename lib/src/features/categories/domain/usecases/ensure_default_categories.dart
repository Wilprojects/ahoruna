import 'package:ahoruna/src/features/categories/domain/repositories/category_repository.dart';

class EnsureDefaultCategories {
  const EnsureDefaultCategories(this._repository);

  final CategoryRepository _repository;

  Future<void> call() {
    return _repository.ensureDefaultCategories();
  }
}
