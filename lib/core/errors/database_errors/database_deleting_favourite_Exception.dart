class DatabaseDeletingFavouriteException implements Exception {
  dynamic message = 'Database Deleting Favourite Error!';

  DatabaseDeletingFavouriteException([this.message]);

  @override
  String toString() {
    return "Exception: $message";
  }
}

class DatabaseDeletingFavouriteWrongIdException implements Exception {
  final dynamic message = 'Database Deleting Favourite Wrong Id Error!';

  DatabaseDeletingFavouriteWrongIdException();

  @override
  String toString() {
    return "Exception: $message";
  }
}
