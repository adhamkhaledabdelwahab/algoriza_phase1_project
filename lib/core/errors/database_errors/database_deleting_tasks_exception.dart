class DatabaseDeletingTasksException implements Exception {
  dynamic message = 'Database Deleting Tasks Error!';

  DatabaseDeletingTasksException([this.message]);

  @override
  String toString() {
    return 'Exception: $message';
  }
}
