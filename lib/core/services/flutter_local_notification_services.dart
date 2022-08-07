// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:algoriza_phase1_project/core/errors/notification_errors/notification_errors.dart';
import 'package:algoriza_phase1_project/core/services/notification_interfaces/notification_interfaces.dart';
import 'package:algoriza_phase1_project/data/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class FlutterLocalNotificationService implements NotificationInterface {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  final String channelId = 'Notification_ID';
  final String channelName = 'Notification_Channel_Name';
  final String channelDesc = 'Notification_Channel_Description';

  FlutterLocalNotificationService(this._flutterLocalNotificationsPlugin);

  Future<void> initializeNotificationService() async {
    bool? isInitialized = await _initializeNotificationPlugin();
    if (isInitialized == null || isInitialized == false) {
      throw NotificationInitializingFalseOrNullValueException();
    }
    return;
  }

  Future<bool?> _initializeNotificationPlugin() async {
    try {
      await _configureLocalTimeZone();
      await _requestIOSPermissions();
      return await _flutterLocalNotificationsPlugin.initialize(
        _getInitializationSettings(),
        onSelectNotification: _selectNotification,
      );
    } on NotificationIOSPermissionException catch (e) {
      if (Platform.isIOS) {
        throw NotificationIOSPermissionException('$e');
      }
    } on NotificationIOSPermissionNotGrantedOrNullException {
      throw NotificationIOSPermissionNotGrantedOrNullException();
    } on NotificationTimeZoneException catch (e) {
      throw NotificationTimeZoneException('$e');
    } catch (e) {
      throw NotificationInitializingException('$e');
    }
    return null;
  }

  Future<void> _configureLocalTimeZone() async {
    try {
      tz.initializeTimeZones();
      final String timeZoneName =
          await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      throw NotificationTimeZoneException('$e');
    }
  }

  Future<void> _requestIOSPermissions() async {
    try {
      bool? iosPermissionGranted = await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      if (Platform.isIOS &&
          (iosPermissionGranted == null || iosPermissionGranted == false)) {
        throw NotificationIOSPermissionNotGrantedOrNullException();
      }
    } on NotificationIOSPermissionNotGrantedOrNullException {
      throw NotificationIOSPermissionNotGrantedOrNullException();
    } catch (e) {
      throw NotificationIOSPermissionException('$e');
    }
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

  Future<void> _selectNotification(String? payload) async {
    debugPrint('notification payload: $payload');
  }

  Future _onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    debugPrint('Task $id: $title');
  }

  @override
  Future<void> cancelNotification(Task task) async {
    try {
      return await _flutterLocalNotificationsPlugin.cancel(task.notificationId);
    } catch (e) {
      throw NotificationCancelException('$e');
    }
  }

  @override
  Future<void> cancelAllNotifications() async {
    try {
      return await _flutterLocalNotificationsPlugin.cancelAll();
    } catch (e) {
      throw NotificationCancelAllException('$e');
    }
  }

  @override
  Future<void> scheduleNotification(Task task) async {
    try {
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
    } catch (e) {
      throw NotificationScheduleException('$e');
    }
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
      } else if (repeat == Repeat.repeatMonthly) {
        scheduledDate = tz.TZDateTime(
            tz.local, fd.year, fd.month + 1, fd.day, hour, minutes);
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
}
