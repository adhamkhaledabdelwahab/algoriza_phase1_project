class DatabaseFetchingFavouritesException implements Exception {
  dynamic message = 'Database Fetching Favourites Error!';

  DatabaseFetchingFavouritesException([this.message]);

  @override
  String toString() {
    return 'Exception: $message';
  }
}
