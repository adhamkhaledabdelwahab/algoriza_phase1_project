class NotificationCancelException implements Exception {
  dynamic message = 'Notification Cancel Error!';

  NotificationCancelException([this.message]);

  @override
  String toString() {
    return 'Exception: $message';
  }
}
