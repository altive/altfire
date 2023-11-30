import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterfire_messenger/messenger.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

class MockNotificationSettings extends Mock implements NotificationSettings {}

void main() {
  group('Messenger', () {
    test(
        'requestPermission should call '
        'setForegroundNotificationPresentationOptions and '
        'requestPermission on messaging', () async {
      final messaging = MockFirebaseMessaging();
      final messenger = Messenger(messaging: messaging);
      final settings = MockNotificationSettings();

      when(
        () => messaging.setForegroundNotificationPresentationOptions(
          alert: any(named: 'alert'),
          badge: any(named: 'badge'),
          sound: any(named: 'sound'),
        ),
      ).thenAnswer((_) async {});
      when(messaging.requestPermission).thenAnswer((_) async => settings);

      final got = await messenger.requestPermission();

      expect(got, settings);

      verify(
        () => messaging.setForegroundNotificationPresentationOptions(
          alert: any(named: 'alert'),
          badge: any(named: 'badge'),
          sound: any(named: 'sound'),
        ),
      ).called(1);
      verify(messaging.requestPermission).called(1);

      verifyNoMoreInteractions(messaging);
    });
  });
}
