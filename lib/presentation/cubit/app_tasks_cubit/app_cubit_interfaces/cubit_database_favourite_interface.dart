import 'package:algoriza_phase1_project/data/models/favourite_model.dart';

abstract class CubitDatabaseFavouriteInterface {
  Future<void> insertTaskToFavourites(Favourite favourite);

  Future<void> deleteTaskFromFavourites(Favourite favourite);

  Future<void> fetchAllFavourites();

  Future<void> deleteAllFavourites();
}
