import 'package:algoriza_phase1_project/data/models/task_model.dart';

abstract class DatabaseTaskInterface {
  Future<int> insertTask(Task task);

  Future<int> markTaskAsCompleted(Task task);

  Future<int> deleteTask(Task task);

  Future<List<Map<String, dynamic>>> fetchTask(Task task);

  Future<List<Map<String, dynamic>>> fetchAllTasks();

  Future<int> deleteAllTasks();
}
