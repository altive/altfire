import 'dart:isolate';

import 'package:altfire_tracker/altfire_tracker.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseCrashlytics extends Mock implements FirebaseCrashlytics {}

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

class MockTrackable extends Mock implements Trackable {}

void main() {
  group('Tracker', () {
    test('onFlutterError should call recordFlutterError on crashlytics',
        () async {
      final crashlytics = MockFirebaseCrashlytics();
      final analytics = MockFirebaseAnalytics();
      final tracker = Tracker(
        crashlytics: crashlytics,
        analytics: analytics,
      );

      final flutterErrorDetails = FlutterErrorDetails(
        exception: Exception('Test exception'),
      );
      when(
        () => crashlytics.recordFlutterError(flutterErrorDetails),
      ).thenAnswer((_) async {});

      await tracker.onFlutterError(flutterErrorDetails);

      verify(() => crashlytics.recordFlutterError(flutterErrorDetails))
          .called(1);
      verifyNoMoreInteractions(crashlytics);
      verifyNoMoreInteractions(analytics);
    });

    test('onPlatformError should call recordError on crashlytics and trackers',
        () async {
      final crashlytics = MockFirebaseCrashlytics();
      final analytics = MockFirebaseAnalytics();
      final trackable = MockTrackable();
      final tracker = Tracker(
        crashlytics: crashlytics,
        analytics: analytics,
        trackers: [trackable],
      );

      final error = Exception('Test exception');
      final stack = StackTrace.fromString('Test stack trace');
      when(
        () => crashlytics.recordError(error, stack, fatal: true),
      ).thenAnswer((_) async {});
      when(
        () => trackable.trackError(error, stack, fatal: true),
      ).thenAnswer((_) async {});

      final got = tracker.onPlatformError(error, stack);

      expect(got, true);
      verify(() => crashlytics.recordError(error, stack, fatal: true))
          .called(1);
      verify(() => trackable.trackError(error, stack, fatal: true)).called(1);
      verifyNoMoreInteractions(crashlytics);
      verifyNoMoreInteractions(analytics);
      verifyNoMoreInteractions(trackable);
    });

    test(
        'isolateErrorListener should call recordError '
        'on crashlytics and trackers', () async {
      final crashlytics = MockFirebaseCrashlytics();
      final analytics = MockFirebaseAnalytics();
      final trackable = MockTrackable();
      final tracker = Tracker(
        crashlytics: crashlytics,
        analytics: analytics,
        trackers: [trackable],
      );

      final error = Exception('Test exception');
      final stack = StackTrace.fromString('Test stack trace');
      when(
        () => crashlytics.recordError(
          any<Object>(),
          any(),
          fatal: any(named: 'fatal'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => trackable.trackError(
          any<Object>(),
          any(),
          fatal: any(named: 'fatal'),
        ),
      ).thenAnswer((_) async {});

      final got = tracker.isolateErrorListener();

      expect(got, isA<SendPort>());

      got.send([error, stack]);

      await pumpEventQueue();

      verify(
        () => crashlytics.recordError(
          any<Object>(),
          any(),
          fatal: any(named: 'fatal'),
        ),
      ).called(1);
      verify(
        () => trackable.trackError(
          any<Object>(),
          any(),
          fatal: any(named: 'fatal'),
        ),
      ).called(1);
      verifyNoMoreInteractions(crashlytics);
      verifyNoMoreInteractions(analytics);
      verifyNoMoreInteractions(trackable);
    });

    test('recordError should call recordError on crashlytics and trackers',
        () async {
      final crashlytics = MockFirebaseCrashlytics();
      final analytics = MockFirebaseAnalytics();
      final trackable = MockTrackable();
      final tracker = Tracker(
        crashlytics: crashlytics,
        analytics: analytics,
        trackers: [trackable],
      );

      final error = Exception('Test exception');
      final stack = StackTrace.fromString('Test stack trace');
      const fatal = true;
      when(
        () => crashlytics.recordError(error, stack, fatal: fatal),
      ).thenAnswer((_) async {});
      when(
        () => trackable.trackError(error, stack, fatal: fatal),
      ).thenAnswer((_) async {});

      await tracker.recordError(error, stack, fatal: fatal);

      verify(
        () => crashlytics.recordError(error, stack, fatal: fatal),
      ).called(1);
      verify(() => trackable.trackError(error, stack, fatal: fatal)).called(1);
      verifyNoMoreInteractions(crashlytics);
      verifyNoMoreInteractions(analytics);
      verifyNoMoreInteractions(trackable);
    });

    test(
        'setUserId should call setUserIdentifier '
        'on crashlytics, analytics and trackers', () async {
      final crashlytics = MockFirebaseCrashlytics();
      final analytics = MockFirebaseAnalytics();
      final trackable = MockTrackable();
      final tracker = Tracker(
        crashlytics: crashlytics,
        analytics: analytics,
        trackers: [trackable],
      );

      const userId = 'b979be1991444eeb814acdccd594';
      when(() => crashlytics.setUserIdentifier(userId))
          .thenAnswer((_) async {});
      when(() => analytics.setUserId(id: userId)).thenAnswer((_) async {});
      when(() => trackable.setUserId(userId)).thenAnswer((_) async {});

      await tracker.setUserId(userId);

      verify(() => crashlytics.setUserIdentifier(userId)).called(1);
      verify(() => analytics.setUserId(id: userId)).called(1);
      verify(() => trackable.setUserId(userId)).called(1);
      verifyNoMoreInteractions(crashlytics);
      verifyNoMoreInteractions(analytics);
      verifyNoMoreInteractions(trackable);
    });

    test(
        'clearUserId should call setUserIdentifier '
        'on crashlytics, analytics and trackers', () async {
      final crashlytics = MockFirebaseCrashlytics();
      final analytics = MockFirebaseAnalytics();
      final trackable = MockTrackable();
      final tracker = Tracker(
        crashlytics: crashlytics,
        analytics: analytics,
        trackers: [trackable],
      );

      const userId = '';
      when(
        () => crashlytics.setUserIdentifier(userId),
      ).thenAnswer((_) async {});
      when(analytics.setUserId).thenAnswer((_) async {});
      when(trackable.clearUserId).thenAnswer((_) async {});

      await tracker.clearUserId();

      verify(() => crashlytics.setUserIdentifier(userId)).called(1);
      verify(analytics.setUserId).called(1);
      verify(trackable.clearUserId).called(1);
      verifyNoMoreInteractions(crashlytics);
      verifyNoMoreInteractions(analytics);
      verifyNoMoreInteractions(trackable);
    });

    test('setUserProperties should call setUserProperty on analytics',
        () async {
      final crashlytics = MockFirebaseCrashlytics();
      final analytics = MockFirebaseAnalytics();
      final tracker = Tracker(
        crashlytics: crashlytics,
        analytics: analytics,
      );

      const properties = {'key': 'value'};
      when(
        () => analytics.setUserProperty(
          name: any(named: 'name'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      await tracker.setUserProperties(properties);

      verify(
        () => analytics.setUserProperty(
          name: any(named: 'name'),
          value: any(named: 'value'),
        ),
      ).called(1);
      verifyNoMoreInteractions(crashlytics);
      verifyNoMoreInteractions(analytics);
    });

    test('navigatorObservers should return a list of NavigatorObservers',
        () async {
      final crashlytics = MockFirebaseCrashlytics();
      final analytics = MockFirebaseAnalytics();
      final tracker = Tracker(
        crashlytics: crashlytics,
        analytics: analytics,
      );

      String nameExtractor(RouteSettings settings) => settings.name!;
      bool routerFilter(Route<dynamic>? route) => route != null;
      final got = tracker.navigatorObservers(
        nameExtractor: nameExtractor,
        routeFilter: routerFilter,
      );

      expect(got, isA<List<NavigatorObserver>>());
      expect(got.length, 1);
      expect(got[0], isA<FirebaseAnalyticsObserver>());
    });

    test('trackScreenView should call setCurrentScreen on analytics', () async {
      final crashlytics = MockFirebaseCrashlytics();
      final analytics = MockFirebaseAnalytics();
      final trackable = MockTrackable();
      final tracker = Tracker(
        crashlytics: crashlytics,
        analytics: analytics,
        trackers: [trackable],
      );

      const screenName = 'screen';
      when(
        () => analytics.logScreenView(
          screenName: screenName,
        ),
      ).thenAnswer((_) async {});
      when(
        () => trackable.trackScreenView(screenName),
      ).thenAnswer((_) async {});

      await tracker.trackScreenView(screenName);

      verify(
        () => analytics.logScreenView(
          screenName: screenName,
        ),
      ).called(1);
      verify(() => trackable.trackScreenView(screenName)).called(1);
      verifyNoMoreInteractions(crashlytics);
      verifyNoMoreInteractions(analytics);
    });

    test('logEvent should call logEvent on analytics and trackers', () async {
      final crashlytics = MockFirebaseCrashlytics();
      final analytics = MockFirebaseAnalytics();
      final trackable = MockTrackable();
      final tracker = Tracker(
        crashlytics: crashlytics,
        analytics: analytics,
        trackers: [trackable],
      );

      const eventName = 'event';
      const parameters = {'key': 'value'};
      when(
        () => analytics.logEvent(
          name: eventName,
          parameters: parameters,
        ),
      ).thenAnswer((_) async {});
      when(
        () => trackable.trackEvent(
          eventName,
          parameters: parameters,
        ),
      ).thenAnswer((_) async {});

      await tracker.logEvent(eventName, parameters: parameters);

      verify(
        () => analytics.logEvent(
          name: eventName,
          parameters: parameters,
        ),
      ).called(1);
      verify(
        () => trackable.trackEvent(
          eventName,
          parameters: parameters,
        ),
      ).called(1);
      verifyNoMoreInteractions(crashlytics);
      verifyNoMoreInteractions(analytics);
      verifyNoMoreInteractions(trackable);
    });
  });
}
