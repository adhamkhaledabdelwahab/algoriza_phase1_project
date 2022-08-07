import 'package:algoriza_phase1_project/data/models/models.dart';

abstract class CubitNotificationInterface {
  Future<void> scheduleNotification(Task task);

  Future<void> repeatNotification(Task task);

  Future<void> cancelNotification(Task task);

  Future<void> cancelAllNotifications();
}
