import 'package:firebase_messaging/firebase_messaging.dart';

/// A class that wraps package for sending notifications.
/// Its role is to "send necessary notifications."
///
/// It exposes methods for sending notifications and for configuration.
class Notification {
  Notification({
    FirebaseMessaging? messaging,
  }) : _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;

  /// Requests notification permissions.
  ///
  /// On iOS, sets the foreground notification presentation options using
  /// [alert], [badge], and [sound], determining how notifications appear
  /// when the app is in the foreground.
  Future<NotificationSettings> requestPermission({
    bool alert = false,
    bool badge = false,
    bool sound = false,
  }) async {
    // Foreground notification presentation options for iOS.
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: alert,
      badge: badge,
      sound: sound,
    );
    final settings = await _messaging.requestPermission();
    return settings;
  }
}
