class DatabaseUpdatingTaskException implements Exception {
  dynamic message = 'Database Updating Task Error!';

  DatabaseUpdatingTaskException([this.message]);

  @override
  String toString() {
    return "Exception: $message";
  }
}

class DatabaseUpdatingTaskWrongIdException implements Exception {
  final dynamic message = 'Database Updating Task Wrong Id Error!';

  DatabaseUpdatingTaskWrongIdException();

  @override
  String toString() {
    return "Exception: $message";
  }
}
