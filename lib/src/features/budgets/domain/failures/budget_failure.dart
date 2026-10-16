class BudgetFailure implements Exception {
  const BudgetFailure(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() {
    return message;
  }
}
