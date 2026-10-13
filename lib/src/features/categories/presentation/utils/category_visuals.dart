import 'package:flutter/material.dart';

import 'package:ahoruna/src/features/categories/domain/entities/finance_category.dart';

class CategoryVisuals {
  CategoryVisuals._();

  static const Map<String, IconData> icons = {
    'restaurant': Icons.restaurant_rounded,
    'directions_car': Icons.directions_car_rounded,
    'home': Icons.home_rounded,
    'health': Icons.health_and_safety_rounded,
    'movie': Icons.movie_rounded,
    'receipt': Icons.receipt_long_rounded,
    'payments': Icons.payments_rounded,
    'laptop': Icons.laptop_mac_rounded,
    'trending_up': Icons.trending_up_rounded,
    'category': Icons.category_rounded,
    'shopping_bag': Icons.shopping_bag_rounded,
    'school': Icons.school_rounded,
    'pets': Icons.pets_rounded,
    'flight': Icons.flight_rounded,
    'sports_esports': Icons.sports_esports_rounded,
    'savings': Icons.savings_rounded,
    'gift': Icons.card_giftcard_rounded,
    'business': Icons.business_center_rounded,
  };

  static const List<String> colorHexes = [
    '#5B5CF0',
    '#7A63F3',
    '#9674F6',
    '#14B87A',
    '#2CB67D',
    '#EF5B67',
    '#F2A13A',
    '#4A90E2',
    '#E56B6F',
    '#73798E',
  ];

  static IconData iconFor(String iconKey) {
    return icons[iconKey] ?? Icons.category_rounded;
  }

  static Color colorFromHex(String hex) {
    final cleanHex = hex.replaceAll('#', '');

    final value = cleanHex.length == 6 ? 'FF$cleanHex' : cleanHex;

    return Color(int.parse(value, radix: 16));
  }

  static String typeLabel(CategoryType type) {
    switch (type) {
      case CategoryType.expense:
        return 'Gasto';

      case CategoryType.income:
        return 'Ingreso';

      case CategoryType.both:
        return 'Ambos';
    }
  }
}
