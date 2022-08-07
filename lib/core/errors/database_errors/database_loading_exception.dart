class DatabaseLoadingException implements Exception {
  dynamic message = 'Database Loading Error!';

  DatabaseLoadingException([this.message]);

  @override
  String toString() {
    return "Exception: $message";
  }
}
