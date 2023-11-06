import 'dart:async';

/// A class that holds the value of a parameter fetched from a remote.
/// It also provides a Stream of updated parameter information.
class RemoteParameter<T> {
  RemoteParameter({
    required T value,
    required this.onConfigUpdated,
    required this.activateAndRefetch,
  }) : _value = value;

  /// A Stream of updated parameter information.
  Stream<void> onConfigUpdated;

  /// A function that will activate the fetched config and refetch the value.
  /// This is useful for when you want to force a refetch of the value.
  final Future<T> Function() activateAndRefetch;

  /// The current value of the parameter.
  T get value => _value;
  T _value;

  final List<void Function(T value)> _listeners = [];

  late StreamSubscription<void> _subscription;

  /// Add a listener to be notified when the value changes.
  /// Executed when the remote value is updated.
  void addListener(void Function(T value) listener) {
    _listeners.add(listener);

    if (_listeners.length == 1) {
      // When the listener is added for the first time,
      // monitor the onConfigUpdated stream.
      _subscription = onConfigUpdated.listen((_) async {
        _value = await activateAndRefetch();
        _notifyListeners();
      });
    }
  }

  /// Remove a listener.
  Future<void> removeListener(void Function(T value) listener) async {
    _listeners.remove(listener);

    if (_listeners.isEmpty) {
      // When the last listener is removed,
      // cancel the subscription to the onConfigUpdated stream.
      await _subscription.cancel();
    }
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener(_value);
    }
  }
}
