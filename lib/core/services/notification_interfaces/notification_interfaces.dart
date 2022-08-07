import 'package:algoriza_phase1_project/data/models/task_model.dart';

abstract class NotificationInterface {
  Future<void> scheduleNotification(Task task);

  Future<void> cancelNotification(Task task);

  Future<void> cancelAllNotifications();
}
