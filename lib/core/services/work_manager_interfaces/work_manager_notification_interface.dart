import 'package:algoriza_phase1_project/data/models/models.dart';

abstract class WorkManagerNotificationInterface {
  Future<void> registerPeriodicTask(Task task);

  Future<void> cancelAllTasks();

  Future<void> cancelTaskByUniqueName(Task task);
}
