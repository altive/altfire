import 'dart:async';

/// A class that holds the value of a parameter fetched from a remote.
/// It also provides a Stream of updated parameter information.
class RemoteParameter<T> {
  RemoteParameter({
    required T value,
    required StreamSubscription<void> subscription,
  })  : _value = value,
        _subscription = subscription;

  /// The subscription to the stream of updated parameter information.
  final StreamSubscription<void> _subscription;

  /// The current value of the parameter.
  T get value => _value;
  final T _value;

  /// Closes the [RemoteParameter].
  Future<void> dispose() async {
    await _subscription.cancel();
  }
}
