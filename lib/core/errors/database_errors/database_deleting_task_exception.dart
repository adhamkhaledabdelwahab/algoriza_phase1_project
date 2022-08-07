class DatabaseDeletingTaskException implements Exception {
  dynamic message = 'Database Deleting Task Error!';

  DatabaseDeletingTaskException([this.message]);

  @override
  String toString() {
    return "Exception: $message";
  }
}

class DatabaseDeletingTaskWrongIdException implements Exception {
  final dynamic message = 'Database Deleting Task Wrong Id Error!';

  DatabaseDeletingTaskWrongIdException();

  @override
  String toString() {
    return "Exception: $message";
  }
}
