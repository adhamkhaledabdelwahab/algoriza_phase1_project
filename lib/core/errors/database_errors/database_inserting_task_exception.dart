class DatabaseInsertingTaskException implements Exception {
  dynamic message = 'Database Inserting Task Error!';

  DatabaseInsertingTaskException([this.message]);

  @override
  String toString() {
    return "Exception: $message";
  }
}

class DatabaseInsertingTaskAlgorithmConflictException implements Exception {
  final dynamic message = 'Database Inserting Task Algorithm Conflict Error!';

  DatabaseInsertingTaskAlgorithmConflictException();

  @override
  String toString() {
    return "Exception: $message";
  }
}
