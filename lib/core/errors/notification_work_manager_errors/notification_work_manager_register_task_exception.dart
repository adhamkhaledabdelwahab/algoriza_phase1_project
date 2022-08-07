class NotificationWorkManagerRegisterTaskException implements Exception {
  dynamic message = 'Notification Work Manager Register Task Error!';

  NotificationWorkManagerRegisterTaskException([this.message]);

  @override
  String toString() {
    return 'Exception: $message';
  }
}
