/// Abstract class that defines the interface for tracking events and errors.
///
/// Implementations of this class can send tracking information to various
/// analytics　and monitoring services. This class should be implemented
/// by any service that　wants to handle the application's tracking data,
/// such as events and errors.
abstract class Trackable {
  /// Tracks an error.
  ///
  /// Use this method to record errors that occur in the application.
  /// You can mark an error as fatal by setting [fatal] to true.
  ///
  /// Parameters:
  ///   [error] - The error object that was caught.
  ///   [stackTrace] - The stack trace associated with the error.
  ///   [fatal] - A flag to indicate if the error is fatal. Defaults to false.
  Future<void> trackError(
    Object error,
    StackTrace stackTrace, {
    bool fatal = false,
  });

  /// Tracks an event.
  ///
  /// This method allows for logging of custom events within the application.
  /// Events can be anything from user actions to system events.
  ///
  /// Parameters:
  ///   [name] - The name of the event to track.
  ///   [parameters] - Additional parameters or context to log with the event.
  ///                  This is optional and can be null.
  Future<void> trackEvent(
    String name, {
    Map<String, Object?>? parameters,
  });
}
