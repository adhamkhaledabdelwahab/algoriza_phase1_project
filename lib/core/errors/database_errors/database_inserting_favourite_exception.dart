class DatabaseInsertingFavouriteException implements Exception {
  dynamic message = 'Database Inserting Favourite Error!';

  DatabaseInsertingFavouriteException([this.message]);

  @override
  String toString() {
    return 'Exception: $message';
  }
}

class DatabaseInsertingFavouriteAlgorithmConflictException
    implements Exception {
  final dynamic message =
      'Database Inserting Favourite Algorithm Conflict Error!';

  DatabaseInsertingFavouriteAlgorithmConflictException();

  @override
  String toString() {
    return 'Exception: $message';
  }
}
