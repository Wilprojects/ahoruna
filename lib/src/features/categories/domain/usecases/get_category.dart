import 'package:ahoruna/src/features/categories/domain/entities/finance_category.dart';
import 'package:ahoruna/src/features/categories/domain/repositories/category_repository.dart';

class GetCategory {
  const GetCategory(this._repository);

  final CategoryRepository _repository;

  Future<FinanceCategory> call(String categoryId) {
    return _repository.getCategory(categoryId);
  }
}
