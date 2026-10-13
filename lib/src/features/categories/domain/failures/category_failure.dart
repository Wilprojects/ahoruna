class CategoryFailure implements Exception {
  const CategoryFailure(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() {
    return message;
  }
}
