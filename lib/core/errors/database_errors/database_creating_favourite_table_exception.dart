class DatabaseCreatingFavouriteTableException implements Exception {
  dynamic message = 'Database Creating Favourite Table Error!';

  DatabaseCreatingFavouriteTableException([this.message]);

  @override
  String toString() {
    return "Exception: $message";
  }
}
