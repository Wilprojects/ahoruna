class BudgetPeriodUtils {
  BudgetPeriodUtils._();

  static String fromDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');

    return '${date.year}-$month';
  }

  static DateTime parse(String period) {
    final parts = period.split('-');

    if (parts.length != 2) {
      throw const FormatException('Período inválido.');
    }

    final year = int.tryParse(parts[0]);

    final month = int.tryParse(parts[1]);

    if (year == null || month == null || month < 1 || month > 12) {
      throw const FormatException('Período inválido.');
    }

    return DateTime(year, month, 1);
  }

  static DateTime normalize(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime previousMonth(DateTime date) {
    return DateTime(date.year, date.month - 1, 1);
  }

  static DateTime nextMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 1);
  }

  static bool containsDate({required String period, required DateTime date}) {
    final periodDate = parse(period);

    return periodDate.year == date.year && periodDate.month == date.month;
  }

  static bool isCurrentMonth(DateTime date) {
    final now = DateTime.now();

    return date.year == now.year && date.month == now.month;
  }
}
