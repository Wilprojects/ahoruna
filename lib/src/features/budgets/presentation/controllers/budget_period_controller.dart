import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/features/budgets/domain/utils/budget_period_utils.dart';

class BudgetPeriodController extends Notifier<DateTime> {
  @override
  DateTime build() {
    return BudgetPeriodUtils.normalize(DateTime.now());
  }

  void previousMonth() {
    state = BudgetPeriodUtils.previousMonth(state);
  }

  void nextMonth() {
    state = BudgetPeriodUtils.nextMonth(state);
  }

  void currentMonth() {
    state = BudgetPeriodUtils.normalize(DateTime.now());
  }
}
