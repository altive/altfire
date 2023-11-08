import 'dart:async';
import 'dart:isolate';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'trackable.dart';

/// A class that wraps a package for sending events to Analytics.
/// Its role is to "send necessary events to Analytics."
///
/// It exposes methods for sending analytic events and for configuration.
class Tracker {
  Tracker({
    FirebaseCrashlytics? crashlytics,
    FirebaseAnalytics? analytics,
    List<Trackable> trackers = const [],
  })  : _crashlytics = crashlytics ?? FirebaseCrashlytics.instance,
        _analytics = analytics ?? FirebaseAnalytics.instance,
        _trackers = trackers;

  final FirebaseCrashlytics _crashlytics;

  final FirebaseAnalytics _analytics;

  final List<Trackable> _trackers;

  /// A callback for logging errors caught by the Flutter framework.
  ///
  /// Usage example：
  /// ```dart
  /// FlutterError.onError = analyticsReporter.onFlutterError;
  /// ```
  ///
  Future<void> onFlutterError(
    FlutterErrorDetails flutterErrorDetails, {
    bool fatal = false,
  }) async {
    FlutterError.presentError(flutterErrorDetails);
    await _crashlytics.recordFlutterError(flutterErrorDetails, fatal: fatal);
  }

  /// A callback to log asynchronous errors
  /// that are not caught by the Flutter framework.
  ///
  ///
  /// Usage example：
  /// ```dart
  /// PlatformDispatcher.instance.onError = analyticsReporter.onPlatformError;
  /// ```
  bool onPlatformError(Object error, StackTrace stack) {
    unawaited(_crashlytics.recordError(error, stack, fatal: true));
    return true;
  }

  /// A listener to register with [Isolate.current]
  /// to record errors outside of Flutter.
  ///
  /// Usage example：
  /// ```dart
  /// Isolate.current.addErrorListener(
  ///   analyticsReporter.isolateErrorListener()
  /// );
  /// ```
  SendPort isolateErrorListener() {
    return RawReceivePort((List<dynamic> pair) async {
      final errorAndStacktrace = pair;
      await _crashlytics.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last as StackTrace,
        fatal: true,
      );
    }).sendPort;
  }

  /// Record a Dart or native error that caused the application to crash.
  Future<void> recordError(
    Object exception,
    StackTrace stack, {
    bool fatal = false,
  }) async {
    await Future.wait([
      _crashlytics.recordError(
        exception,
        stack,
        fatal: fatal,
      ),
      ..._trackers.map(
        (tracker) => tracker.trackError(
          exception,
          stack,
          fatal: fatal,
        ),
      ),
    ]);
  }

  /// Set the user ID.
  Future<void> setUserId(String userId) async {
    await _crashlytics.setUserIdentifier(userId);
    await _analytics.setUserId(id: userId);
  }

  /// Clear the set user ID.
  Future<void> clearUserId() async {
    await setUserId('');
    await _analytics.setUserId();
  }

  /// Set the user's properties.
  Future<void> setUserProperties(Map<String, String?> properties) async {
    for (final property in properties.entries) {
      await _analytics.setUserProperty(
        name: property.key,
        value: property.value,
      );
    }
  }

  /// Returns a list of NavigatorObservers to register with Navigator.
  /// Use [nameExtractor] to set the parameter value to send.
  List<NavigatorObserver> navigatorObservers({
    required String? Function(RouteSettings) nameExtractor,
  }) {
    return [
      // Returns a NavigatorObserver of FirebaseAnalytics.
      FirebaseAnalyticsObserver(
        analytics: _analytics,
        nameExtractor: nameExtractor,
      ),
    ];
  }

  /// Send an event to Analytics.
  Future<void> logEvent(
    String eventName, {
    Map<String, Object?>? parameters,
  }) async {
    await Future.wait([
      _analytics.logEvent(
        name: eventName,
        parameters: parameters,
      ),
      ..._trackers.map(
        (tracker) => tracker.trackEvent(
          eventName,
          parameters: parameters,
        ),
      ),
    ]);
  }
}
