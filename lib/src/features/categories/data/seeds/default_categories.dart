import 'package:ahoruna/src/features/categories/domain/entities/finance_category.dart';

class DefaultCategoryDefinition {
  const DefaultCategoryDefinition({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.colorHex,
    required this.type,
  });

  final String id;
  final String name;
  final String iconKey;
  final String colorHex;
  final CategoryType type;
}

const defaultCategoryDefinitions = <DefaultCategoryDefinition>[
  DefaultCategoryDefinition(
    id: 'default_food',
    name: 'Alimentación',
    iconKey: 'restaurant',
    colorHex: '#EF5B67',
    type: CategoryType.expense,
  ),
  DefaultCategoryDefinition(
    id: 'default_transport',
    name: 'Transporte',
    iconKey: 'directions_car',
    colorHex: '#5B5CF0',
    type: CategoryType.expense,
  ),
  DefaultCategoryDefinition(
    id: 'default_home',
    name: 'Hogar',
    iconKey: 'home',
    colorHex: '#F2A13A',
    type: CategoryType.expense,
  ),
  DefaultCategoryDefinition(
    id: 'default_health',
    name: 'Salud',
    iconKey: 'health',
    colorHex: '#14B87A',
    type: CategoryType.expense,
  ),
  DefaultCategoryDefinition(
    id: 'default_entertainment',
    name: 'Entretenimiento',
    iconKey: 'movie',
    colorHex: '#9674F6',
    type: CategoryType.expense,
  ),
  DefaultCategoryDefinition(
    id: 'default_services',
    name: 'Servicios',
    iconKey: 'receipt',
    colorHex: '#4A90E2',
    type: CategoryType.expense,
  ),
  DefaultCategoryDefinition(
    id: 'default_salary',
    name: 'Sueldo',
    iconKey: 'payments',
    colorHex: '#14B87A',
    type: CategoryType.income,
  ),
  DefaultCategoryDefinition(
    id: 'default_freelance',
    name: 'Freelance',
    iconKey: 'laptop',
    colorHex: '#7A63F3',
    type: CategoryType.income,
  ),
  DefaultCategoryDefinition(
    id: 'default_investments',
    name: 'Inversiones',
    iconKey: 'trending_up',
    colorHex: '#2CB67D',
    type: CategoryType.income,
  ),
  DefaultCategoryDefinition(
    id: 'default_other',
    name: 'Otros',
    iconKey: 'category',
    colorHex: '#73798E',
    type: CategoryType.both,
  ),
];
