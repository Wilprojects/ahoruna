import 'package:ahoruna/src/features/budgets/domain/entities/budget_overview.dart';
import 'package:ahoruna/src/features/budgets/domain/utils/budget_period_utils.dart';

class BudgetVisuals {
  BudgetVisuals._();

  static const List<String> _months = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];

  static String monthLabel(String period) {
    final date = BudgetPeriodUtils.parse(period);

    final month = _months[date.month - 1];

    final capitalized =
        '${month[0].toUpperCase()}'
        '${month.substring(1)}';

    return '$capitalized ${date.year}';
  }

  static String statusLabel(BudgetStatus status) {
    switch (status) {
      case BudgetStatus.safe:
        return 'En orden';

      case BudgetStatus.warning:
        return 'Alerta';

      case BudgetStatus.exceeded:
        return 'Excedido';
    }
  }
}
