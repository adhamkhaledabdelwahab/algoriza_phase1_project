class NotificationWorkManagerRepeatTaskException implements Exception {
  dynamic message = 'Notification Work Manager Repeat Task Error!';

  NotificationWorkManagerRepeatTaskException([this.message]);

  @override
  String toString() {
    return 'Exception: $message';
  }
}
