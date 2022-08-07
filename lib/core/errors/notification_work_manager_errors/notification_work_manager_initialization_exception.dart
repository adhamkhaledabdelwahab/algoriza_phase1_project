class NotificationWorkManagerInitializationException implements Exception {
  dynamic message = 'Notification Work Manager Initialization Error!';

  NotificationWorkManagerInitializationException([this.message]);

  @override
  String toString() {
    return 'Exception: $message';
  }
}
