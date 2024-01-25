import 'package:altfire_tracker/altfire_tracker.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'interceptor_provider.g.dart';

@Riverpod(keepAlive: true)
LogInterceptor logInterceptor(LogInterceptorRef ref) => LogInterceptor(
      requestBody: true,
      responseBody: true,
    );

@Riverpod(keepAlive: true)
RecordErrorInterceptor recordErrorInterceptor(RecordErrorInterceptorRef ref) =>
    RecordErrorInterceptor();

/// Interception class for sending error logs
/// when an error occurs during API communication
class RecordErrorInterceptor extends Interceptor {
  RecordErrorInterceptor();

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Send logs to Crashlytics
    await Tracker().recordError(err, err.stackTrace);
    super.onError(err, handler);
  }
}
