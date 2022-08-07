class DatabaseFetchingTasksException implements Exception {
  dynamic message = 'Database Fetching Tasks Error!';

  DatabaseFetchingTasksException([this.message]);

  @override
  String toString() {
    return 'Exception: $message';
  }
}
