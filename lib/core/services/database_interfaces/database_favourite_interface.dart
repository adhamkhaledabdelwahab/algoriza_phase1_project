import 'package:algoriza_phase1_project/data/models/favourite_model.dart';

abstract class DatabaseFavouriteInterface {
  Future<int> insertTaskToFavourites(Favourite favourite);

  Future<int> deleteTaskFromFavourites(Favourite favourite);

  Future<List<Map<String, dynamic>>> fetchAllFavourites();

  Future<int> deleteAllFavourites();
}
