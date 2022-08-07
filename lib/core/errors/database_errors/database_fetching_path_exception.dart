class DatabaseFetchingPathException implements Exception {
  dynamic message = 'Error Fetching Database Path!';

  DatabaseFetchingPathException([this.message]);

  @override
  String toString() {
    return "Exception: $message";
  }
}

class DatabaseFetchingPathEmptyValueException implements Exception {
  final dynamic message = 'Error Fetching Database Path!';

  DatabaseFetchingPathEmptyValueException();

  @override
  String toString() {
    return "Exception: $message";
  }
}
