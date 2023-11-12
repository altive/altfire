import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:meta/meta.dart';

import 'remote_parameter.dart';

typedef ValueChanged<T> = void Function(T value);

/// A class that wraps Remote Config.
/// Its role is to "fetch the configured parameters from remote and provide
/// them".
///
/// Exposes [fetchAndActivate] and configuration methods for Remote Config.
class RemoteParameterFetcher {
  RemoteParameterFetcher({
    FirebaseRemoteConfig? rc,
  }) : _rc = rc ?? FirebaseRemoteConfig.instance;

  final FirebaseRemoteConfig _rc;

  /// Fetch and activate parameters from remote.
  Future<bool> fetchAndActivate() async {
    return _rc.fetchAndActivate();
  }

  /// Activate parameters fetched from remote.
  Future<bool> activate() async {
    return _rc.activate();
  }

  /// Configure settings related to parameter fetching.
  Future<void> configure({
    required Duration fetchTimeout,
    required Duration minimumFetchInterval,
  }) async {
    await _rc.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: fetchTimeout,
        minimumFetchInterval: minimumFetchInterval,
      ),
    );
  }

  /// Set default values for when parameters cannot be fetched from remote.
  Future<void> setDefaults(Map<String, Object?> defaultParameters) async {
    for (final p in defaultParameters.values) {
      assert(p is String || p is int || p is double || p is bool);
    }
    await _rc.setDefaults(defaultParameters);
  }

  /// Provide a Stream of updated parameter information.
  ///
  /// NOTE: In the method form, each call inadvertently creates
  /// a different Stream, resulting in only the latest one being functional.
  /// To address this issue, we use a property form to ensure a unique and
  /// consistent Stream for each instance.
  @visibleForTesting
  late final Stream<RemoteConfigUpdate> onConfigUpdated = _rc.onConfigUpdated;

  /// Filter the Stream of updated parameter information by key.
  Stream<RemoteConfigUpdate> filteredOnConfigUpdated(String key) {
    return onConfigUpdated.where((config) => config.updatedKeys.contains(key));
  }

  @visibleForTesting
  String getString(String key) {
    final value = _rc.getString(key);
    return value;
  }

  @visibleForTesting
  int getInt(String key) {
    final value = _rc.getInt(key);
    return value;
  }

  @visibleForTesting
  double getDouble(String key) {
    final value = _rc.getDouble(key);
    return value;
  }

  @visibleForTesting
  bool getBool(String key) {
    final value = _rc.getBool(key);
    return value;
  }

  /// Returns a JSON string converted to a [Map] type.
  @visibleForTesting
  Map<String, Object?> getJson(String key) {
    final value = _rc.getString(key);
    return json.decode(value) as Map<String, dynamic>;
  }

  /// Returns a List JSON string converted to a [List] type.
  @visibleForTesting
  List<Map<String, Object?>> getListJson(String key) {
    final value = _rc.getString(key);
    final list = json.decode(value) as List<dynamic>;
    return list.map((dynamic e) => e as Map<String, Object?>).toList();
  }

  /// Class Object from JSON.
  @visibleForTesting
  T getData<T extends Object>({
    required String key,
    required T Function(Map<String, Object?>) fromJson,
  }) {
    final json = getJson(key);
    return fromJson(json);
  }

  /// Returns a [RemoteParameter] of type [String].
  RemoteParameter<String> getStringParameter(
    String key, {
    required ValueChanged<String> onConfigUpdated,
  }) {
    return RemoteParameter<String>(
      value: getString(key),
      subscription: filteredOnConfigUpdated(key).listen((event) async {
        await activate();
        onConfigUpdated(getString(key));
      }),
    );
  }

  /// Returns a [RemoteParameter] of type [int].
  RemoteParameter<int> getIntParameter(
    String key, {
    required ValueChanged<int> onConfigUpdated,
  }) {
    return RemoteParameter<int>(
      value: getInt(key),
      subscription: filteredOnConfigUpdated(key).listen((event) async {
        await activate();
        onConfigUpdated(getInt(key));
      }),
    );
  }

  /// Returns a [RemoteParameter] of type [double].
  RemoteParameter<double> getDoubleParameter(
    String key, {
    required ValueChanged<double> onConfigUpdated,
  }) {
    return RemoteParameter<double>(
      value: getDouble(key),
      subscription: filteredOnConfigUpdated(key).listen((event) async {
        await activate();
        onConfigUpdated(getDouble(key));
      }),
    );
  }

  /// Returns a [RemoteParameter] of type [bool].
  RemoteParameter<bool> getBoolParameter(
    String key, {
    required ValueChanged<bool> onConfigUpdated,
  }) {
    return RemoteParameter<bool>(
      value: getBool(key),
      subscription: filteredOnConfigUpdated(key).listen((event) async {
        await activate();
        onConfigUpdated(getBool(key));
      }),
    );
  }

  /// Returns a [RemoteParameter] of type [Map].
  RemoteParameter<Map<String, Object?>> getJsonParameter(
    String key, {
    required void Function(Map<String, Object?> value) onConfigUpdated,
  }) {
    return RemoteParameter<Map<String, Object?>>(
      value: getJson(key),
      subscription: filteredOnConfigUpdated(key).listen((event) async {
        await activate();
        onConfigUpdated(getJson(key));
      }),
    );
  }

  /// Returns a [RemoteParameter] of type [List] of [Map].
  RemoteParameter<List<Map<String, Object?>>> getListJsonParameter(
    String key, {
    required ValueChanged<List<Map<String, Object?>>> onConfigUpdated,
  }) {
    return RemoteParameter<List<Map<String, Object?>>>(
      value: getListJson(key),
      subscription: filteredOnConfigUpdated(key).listen((event) async {
        await activate();
        onConfigUpdated(getListJson(key));
      }),
    );
  }

  /// Returns a [RemoteParameter] of type [T].
  RemoteParameter<T> getDataParameter<T extends Object>(
    String key, {
    required T Function(Map<String, Object?>) fromJson,
    required ValueChanged<T> onConfigUpdated,
  }) {
    return RemoteParameter<T>(
      value: getData<T>(key: key, fromJson: fromJson),
      subscription: filteredOnConfigUpdated(key).listen((event) async {
        await activate();
        onConfigUpdated(getData(key: key, fromJson: fromJson));
      }),
    );
  }
}
