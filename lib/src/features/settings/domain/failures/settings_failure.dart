class SettingsFailure implements Exception {
  const SettingsFailure(this.message);

  final String message;

  @override
  String toString() {
    return message;
  }
}
