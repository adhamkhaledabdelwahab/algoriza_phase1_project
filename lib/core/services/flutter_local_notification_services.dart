// ignore_for_file: depend_on_referenced_packages

import 'package:algoriza_phase1_project/data/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class FlutterLocalNotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final String channelId = 'Notification_ID';
  final String channelName = 'Notification_Channel_Name';
  final String channelDesc = 'Notification_Channel_Description';

  Future<bool?> initializeNotification() async {
    await _configureLocalTimeZone();
    await _requestIOSPermissions();
    return await _flutterLocalNotificationsPlugin.initialize(
      _getInitializationSettings(),
      onSelectNotification: _selectNotification,
    );
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<void> _requestIOSPermissions() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  InitializationSettings _getInitializationSettings() {
    return InitializationSettings(
      iOS: _getIOSInitializationSettings(),
      android: _getAndroidInitializationSettings(),
    );
  }

  IOSInitializationSettings _getIOSInitializationSettings() {
    return IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );
  }

  AndroidInitializationSettings _getAndroidInitializationSettings() {
    return const AndroidInitializationSettings('res_notification_app_icon');
  }

  Future _selectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    } else {
      debugPrint("Notification Done");
    }
  }

  Future _onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    debugPrint('Task $id: $title');
  }

  Future<void> displayNotification(Task task) async {
    var platformChannelSpecifics = NotificationDetails(
        android: _getAndroidNotificationDetails(),
        iOS: const IOSNotificationDetails());
    return await _flutterLocalNotificationsPlugin.show(
      task.notificationId,
      task.title,
      null,
      platformChannelSpecifics,
      payload: '${task.title}|'
          '${task.date}|'
          '${task.startTime}|'
          '${task.repeat}|'
          '${task.reminder}|'
          '${task.color}|'
          '${task.isCompleted}',
    );
  }

  Future<void> repeatNotification(Task task) async {
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: _getAndroidNotificationDetails(),
      iOS: const IOSNotificationDetails(),
    );
    return await _flutterLocalNotificationsPlugin.periodicallyShow(
        task.notificationId,
        task.title,
        null,
        task.repeat == Repeat.repeatDaily
            ? RepeatInterval.daily
            : RepeatInterval.weekly,
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        payload: '${task.title}|'
            '${task.date}|'
            '${task.startTime}|'
            '${task.repeat}|'
            '${task.reminder}|'
            '${task.color}|'
            '${task.isCompleted}');
  }

  Future<void> scheduledNotification(Task task) async {
    return await _flutterLocalNotificationsPlugin.zonedSchedule(
      task.notificationId,
      task.title,
      null,
      _nextInstanceOfTenAM(
        DateFormat('HH:mm').parse(task.startTime).hour,
        DateFormat('HH:mm').parse(task.startTime).minute,
        task.reminder,
        task.repeat,
        task.date,
      ),
      NotificationDetails(
        android: _getAndroidNotificationDetails(),
        iOS: const IOSNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      payload: '${task.title}|'
          '${task.date}|'
          '${task.startTime}|'
          '${task.repeat}|'
          '${task.reminder}|'
          '${task.color}|'
          '${task.isCompleted}',
    );
  }

  AndroidNotificationDetails _getAndroidNotificationDetails() {
    return AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDesc,
      importance: Importance.max,
      priority: Priority.high,
    );
  }

  tz.TZDateTime _nextInstanceOfTenAM(
      int hour, int minutes, Reminder remind, Repeat repeat, String date) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    var formattedDate = DateFormat.yMd().parse(date);
    var fd = tz.TZDateTime.from(formattedDate, tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, fd.year, fd.month, fd.day, hour, minutes);
    scheduledDate = _afterRemind(remind, scheduledDate);
    if (scheduledDate.isBefore(now)) {
      if (repeat == Repeat.repeatDaily) {
        scheduledDate = tz.TZDateTime(tz.local, fd.year, fd.month,
            fd.day + (now.difference(scheduledDate).inDays + 1), hour, minutes);
      } else if (repeat == Repeat.repeatWeekly) {
        scheduledDate = tz.TZDateTime(tz.local, fd.year, fd.month,
            fd.day + (now.difference(scheduledDate).inDays + 7), hour, minutes);
      }
      scheduledDate = _afterRemind(remind, scheduledDate);
    }
    debugPrint(scheduledDate.toString());
    return scheduledDate;
  }

  tz.TZDateTime _afterRemind(Reminder remind, tz.TZDateTime scheduledDate) {
    if (remind == Reminder.tenMinutes) {
      return scheduledDate.subtract(const Duration(minutes: 10));
    } else if (remind == Reminder.tenMinutes) {
      return scheduledDate.subtract(const Duration(minutes: 30));
    } else if (remind == Reminder.oneHour) {
      return scheduledDate.subtract(const Duration(hours: 1));
    } else if (remind == Reminder.oneDay) {
      return scheduledDate.subtract(const Duration(days: 1));
    } else {
      return scheduledDate;
    }
  }

  Future<void> cancelNotification(Task task) async {
    return await _flutterLocalNotificationsPlugin.cancel(task.notificationId);
  }

  Future<void> cancelAllNotifications() async {
    return await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
