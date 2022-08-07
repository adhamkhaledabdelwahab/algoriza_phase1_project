import 'package:algoriza_phase1_project/data/models/models.dart';

abstract class CubitDatabaseTaskInterface {
  Future<void> insertTask(Task task);

  Future<void> markTaskAsCompleted(Task task);

  Future<void> deleteTask(Task task);

  Future<void> fetchAllTasks();

  Future<void> deleteAllTasks();
}
