class NotificationInitializingException implements Exception {
  dynamic message = 'Notification Initialization Error!';

  NotificationInitializingException([this.message]);

  @override
  String toString() {
    return 'Exception: $message';
  }
}

class NotificationInitializingFalseOrNullValueException implements Exception {
  dynamic message = 'Notification Initialization False Or Null Value Error!';

  NotificationInitializingFalseOrNullValueException([this.message]);

  @override
  String toString() {
    return 'Exception: $message';
  }
}

class NotificationTimeZoneException implements Exception {
  dynamic message = 'Notification Time Zones Error!';

  NotificationTimeZoneException([this.message]);

  @override
  String toString() {
    return 'Exception: $message';
  }
}

class NotificationIOSPermissionException implements Exception{
  dynamic message = 'Notification IOS Permission Error!';

  NotificationIOSPermissionException([this.message]);

  @override
  String toString() {
    return 'Exception: $message';
  }
}

class NotificationIOSPermissionNotGrantedOrNullException implements Exception{
  dynamic message = 'Notification IOS Permission Not Granted Or Null Value Error!';

  NotificationIOSPermissionNotGrantedOrNullException([this.message]);

  @override
  String toString() {
    return 'Exception: $message';
  }
}
