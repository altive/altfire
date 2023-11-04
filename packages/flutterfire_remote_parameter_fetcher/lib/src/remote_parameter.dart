/// A class that holds the value of a parameter fetched from a remote.
/// It also provides a Stream of updated parameter information.
class RemoteParameter<T> {
  RemoteParameter({
    required T value,
    required Stream<void> onConfigUpdated,
    required this.activateAndRefetch,
  }) : _value = value {
    onConfigUpdated.listen((_) async {
      _value = await activateAndRefetch();
      _notifyListeners();
    });
  }

  /// A function that will activate the fetched config and refetch the value.
  /// This is useful for when you want to force a refetch of the value.
  final Future<T> Function() activateAndRefetch;

  /// The current value of the parameter.
  T get value => _value;
  T _value;

  final List<void Function(T value)> _listeners = [];

  /// Add a listener to be notified when the value changes.
  /// Executed when the remote value is updated.
  void addListener(void Function(T value) listener) {
    _listeners.add(listener);
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener(_value);
    }
  }
}
