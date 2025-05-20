import 'package:altfire_tracker_example/record_error_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mock/mock.mocks.dart';
import 'mock/mock_firebase_crashlytics.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final methodCallLog = <MethodCall>[];

  setUpAll(() async {
    setupFirebaseCrashlyticsMocks(methodCallLog);
    await Firebase.initializeApp();
  });

  tearDown(methodCallLog.clear);

  group('RecordErrorInterceptor', () {
    test('Logs are sent to Crashlytics when onError is called', () async {
      final recordErrorInterceptor = RecordErrorInterceptor();
      // NOTE: In firebase_crashlytics v2.8.10 and later,
      // if StackTrace.empty is used, it is replaced with StackTrace.
      // current internally in the SDK, causing the test to fail. Therefore,
      // we are using a dummy StackTrace for testing purposes.
      final stackTrace = StackTrace.fromString('stacktrace');
      final err = DioException(
        requestOptions: RequestOptions(path: 'dummy'),
        stackTrace: stackTrace,
      );
      final handler = MockErrorInterceptorHandler();
      when(handler.next(err)).thenReturn(null);
      await recordErrorInterceptor.onError(err, handler);
      expect(methodCallLog, <Matcher>[
        isMethodCall(
          'Crashlytics#recordError',
          arguments: <String, dynamic>{
            'exception': err.toString(),
            'information': '',
            'reason': null,
            'fatal': false,
            'buildId': '',
            'loadingUnits': <String>[],
            'stackTraceElements': <Map<String, String>>[],
          },
        ),
      ]);
    });
  });
}
