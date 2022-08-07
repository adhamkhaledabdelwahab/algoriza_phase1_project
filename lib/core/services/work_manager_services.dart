import 'package:algoriza_phase1_project/core/errors/notification_work_manager_errors/notification_work_manager_errors.dart';
import 'package:algoriza_phase1_project/core/services/flutter_local_notification_services.dart';
import 'package:algoriza_phase1_project/core/services/work_manager_interfaces/work_manager_notification_interface.dart';
import 'package:algoriza_phase1_project/data/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

void workMangerNotificationTaskExecute() {
  Workmanager().executeTask((task, inputData) async {
    try {
      Task task = Task.fromJson(inputData!);
      FlutterLocalNotificationsPlugin plugin =
          FlutterLocalNotificationsPlugin();
      FlutterLocalNotificationService notificationService =
          FlutterLocalNotificationService(plugin);
      await notificationService.initializeNotificationService();
      await notificationService.scheduleNotification(task);
    } catch (e) {
      debugPrint('$e');
      return Future.error(e);
    }
    return Future.value(true);
  });
}

class WorkManagerService implements WorkManagerNotificationInterface {
  final Workmanager _notificationWorkManager;

  WorkManagerService(this._notificationWorkManager);

  Future<void> initializeWorkManagerService() async {
    return await _initializeWorkManager();
  }

  Future<void> _initializeWorkManager() async {
    try {
      await _notificationWorkManager
          .initialize(workMangerNotificationTaskExecute);
    } catch (e) {
      throw NotificationWorkManagerInitializationException('$e');
    }
  }

  @override
  Future<void> cancelAllTasks() async {
    try {
      await _notificationWorkManager.cancelAll();
    } catch (e) {
      throw NotificationWorkManagerCancelAllTasksException('$e');
    }
  }

  @override
  Future<void> cancelTaskByUniqueName(Task task) async {
    try {
      await _notificationWorkManager.cancelByUniqueName(task.id);
    } catch (e) {
      throw NotificationWorkManagerCancelTaskByUniqueNameException('$e');
    }
  }

  @override
  Future<void> registerPeriodicTask(Task task) async {
    try {
      await _notificationWorkManager.registerPeriodicTask(
        task.id,
        task.title,
        inputData: task.toJson(),
        frequency: _getRepeat(task.repeat),
        existingWorkPolicy: ExistingWorkPolicy.replace,
      );
    } catch (e) {
      throw NotificationWorkManagerRepeatTaskException('$e');
    }
  }

  Duration _getRepeat(Repeat repeat) {
    switch (repeat) {
      case Repeat.repeatDaily:
        return const Duration(days: 1);
      case Repeat.repeatWeekly:
        return const Duration(days: 7);
      case Repeat.repeatMonthly:
        return const Duration(days: 27);
      default:
        return Duration.zero;
    }
  }
}
