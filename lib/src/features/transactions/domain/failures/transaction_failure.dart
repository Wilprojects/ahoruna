class TransactionFailure implements Exception {
  const TransactionFailure(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() {
    return message;
  }
}
