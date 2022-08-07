class NotificationWorkManagerCancelAllTasksException implements Exception {
  dynamic message = 'Notification Work Manager Cancel All Tasks Error!';

  NotificationWorkManagerCancelAllTasksException([this.message]);

  @override
  String toString() {
    return 'Exception: $message';
  }
}
