import 'package:ahoruna/src/features/categories/domain/entities/finance_category.dart';
import 'package:ahoruna/src/features/categories/domain/repositories/category_repository.dart';

class WatchCategories {
  const WatchCategories(this._repository);

  final CategoryRepository _repository;

  Stream<List<FinanceCategory>> call() {
    return _repository.watchCategories();
  }
}
