class DashboardVisuals {
  DashboardVisuals._();

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

  static String monthLabel(DateTime date) {
    final month = _months[date.month - 1];

    final capitalized =
        '${month[0].toUpperCase()}'
        '${month.substring(1)}';

    return '$capitalized ${date.year}';
  }
}
