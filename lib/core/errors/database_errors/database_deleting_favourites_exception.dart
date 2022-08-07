class DatabaseDeletingFavouritesException implements Exception {
  dynamic message = 'Database Deleting Favourites Error!';

  DatabaseDeletingFavouritesException([this.message]);

  @override
  String toString() {
    return 'Error: $message';
  }
}
