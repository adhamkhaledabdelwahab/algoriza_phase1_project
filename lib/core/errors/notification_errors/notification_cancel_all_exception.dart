class NotificationCancelAllException implements Exception {
  dynamic message = 'Notification Cancel All Error!';

  NotificationCancelAllException([this.message]);

  @override
  String toString() {
    return 'Exception: $message';
  }
}
