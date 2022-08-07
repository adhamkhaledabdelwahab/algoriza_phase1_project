class NotificationScheduleException implements Exception {
  dynamic message = 'Notification Schedule Error!';

  NotificationScheduleException([this.message]);

  @override
  String toString() {
    return 'Exception: $message';
  }
}
