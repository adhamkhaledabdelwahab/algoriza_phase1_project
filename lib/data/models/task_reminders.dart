import 'package:flutter/material.dart';

enum Reminder { none, tenMinutes, thirtyMinutes, oneHour, oneDay }

const Map<int, Reminder> taskReminders = {
  0: Reminder.none,
  1: Reminder.tenMinutes,
  2: Reminder.thirtyMinutes,
  3: Reminder.oneHour,
  4: Reminder.oneDay,
};

String getReminder(int reminderIndex) {
  switch (reminderIndex) {
    case 0:
      return 'None';
    case 1:
      return '10 minutes early';
    case 2:
      return '30 minutes early';
    case 3:
      return '1 hour early';
    case 4:
      return '1 day early';
    default:
      return 'None';
  }
}
