import 'dart:math';

import 'package:algoriza_phase1_project/data/models/task_colors.dart';
import 'package:algoriza_phase1_project/data/models/task_reminders.dart';
import 'package:algoriza_phase1_project/data/models/task_repeat.dart';
import 'package:flutter/material.dart';

class Task {
  final String id;
  final String title;
  final String date;
  final String startTime;
  final String endTime;
  final Reminder reminder;
  final Repeat repeat;
  final Color color;
  final int isCompleted;
  final int notificationId;

  Task({
    required this.id,
    required this.title,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.reminder = Reminder.tenMinutes,
    this.repeat = Repeat.none,
    this.color = Colors.blue,
    this.isCompleted = 0,
    this.notificationId = 1,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'date': date,
        'startTime': startTime,
        'endTime': endTime,
        'reminder': taskReminders.keys
            .firstWhere((element) => taskReminders[element] == reminder),
        'repeat': taskRepeats.keys
            .firstWhere((element) => taskRepeats[element] == repeat),
        'color': taskColors.keys
            .firstWhere((element) => taskColors[element] == color),
        'isCompleted': isCompleted,
      };

  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        title = json['title'] as String,
        date = json['date'] as String,
        startTime = json['startTime'] as String,
        endTime = json['endTime'] as String,
        reminder = taskReminders[json['reminder'] as int]!,
        repeat = taskRepeats[json['repeat'] as int]!,
        color = taskColors[json['color'] as int]!,
        isCompleted = json['isCompleted'] as int,
        notificationId = (json['notificationId'] ?? Random().nextInt(99999)) as int;
}
