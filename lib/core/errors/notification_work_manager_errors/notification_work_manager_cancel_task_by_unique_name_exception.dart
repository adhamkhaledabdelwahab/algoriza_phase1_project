class NotificationWorkManagerCancelTaskByUniqueNameException
    implements Exception {
  dynamic message =
      'Notification Work Manager Cancel Task By Unique Name Error!';

  NotificationWorkManagerCancelTaskByUniqueNameException([this.message]);

  @override
  String toString() {
    return 'Exception: $message';
  }
}
