class DatabaseCreatingTaskTableException implements Exception{
  dynamic message = 'Database Creating Task Table Error!';

  DatabaseCreatingTaskTableException([this.message]);

  @override
  String toString() {
    return "Exception: $message";
  }
}
