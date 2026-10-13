enum CategoryType { expense, income, both }

class FinanceCategory {
  const FinanceCategory({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.colorHex,
    required this.type,
    required this.isDefault,
    required this.isActive,
  });

  final String id;
  final String name;
  final String iconKey;
  final String colorHex;
  final CategoryType type;
  final bool isDefault;
  final bool isActive;
}
