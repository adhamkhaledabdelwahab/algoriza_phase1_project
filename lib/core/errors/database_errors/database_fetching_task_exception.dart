class DatabaseFetchingTaskException implements Exception {
  dynamic message = 'Database Fetching Task Error!';

  DatabaseFetchingTaskException([this.message]);

  @override
  String toString() {
    return 'Exception: $message';
  }
}

class DatabaseFetchingTaskWrongIdException implements Exception {
  dynamic message = 'Database Fetching Task Wrong Id Error!';

  DatabaseFetchingTaskWrongIdException([this.message]);

  @override
  String toString() {
    return 'Exception: $message';
  }
}
