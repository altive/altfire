import 'package:firebase_messaging/firebase_messaging.dart';

/// A class that wraps package for sending notifications and messages.
/// Its role is to "send necessary notifications and messages to the user".
///
/// It exposes methods for sending and receiving notifications, displaying
/// in-app messages, and managing settings related to these functions.
class Messenger {
  Messenger({
    FirebaseMessaging? messaging,
  }) : _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;

  /// Requests notification permissions.
  ///
  /// On iOS, sets the foreground notification presentation options using
  /// [alert], [badge], and [sound], determining how notification appear
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
