import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:meta/meta.dart';

import 'remote_parameter.dart';

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
  @visibleForTesting
  Stream<RemoteConfigUpdate> get onConfigUpdated {
    return _rc.onConfigUpdated;
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
  RemoteParameter<String> getStringParameter(String key) {
    return RemoteParameter<String>(
      value: getString(key),
      onConfigUpdated: onConfigUpdated.where(
        (config) => config.updatedKeys.contains(key),
      ),
      activateAndRefetch: () async {
        await fetchAndActivate();
        return getString(key);
      },
    );
  }

  /// Returns a [RemoteParameter] of type [int].
  RemoteParameter<int> getIntParameter(String key) {
    return RemoteParameter<int>(
      value: getInt(key),
      onConfigUpdated: onConfigUpdated.where(
        (config) => config.updatedKeys.contains(key),
      ),
      activateAndRefetch: () async {
        await fetchAndActivate();
        return getInt(key);
      },
    );
  }

  /// Returns a [RemoteParameter] of type [double].
  RemoteParameter<double> getDoubleParameter(String key) {
    return RemoteParameter<double>(
      value: getDouble(key),
      onConfigUpdated: onConfigUpdated.where(
        (config) => config.updatedKeys.contains(key),
      ),
      activateAndRefetch: () async {
        await fetchAndActivate();
        return getDouble(key);
      },
    );
  }

  /// Returns a [RemoteParameter] of type [bool].
  RemoteParameter<bool> getBoolParameter(String key) {
    return RemoteParameter<bool>(
      value: getBool(key),
      onConfigUpdated: onConfigUpdated.where(
        (config) => config.updatedKeys.contains(key),
      ),
      activateAndRefetch: () async {
        await fetchAndActivate();
        return getBool(key);
      },
    );
  }

  /// Returns a [RemoteParameter] of type [Map].
  RemoteParameter<Map<String, Object?>> getJsonParameter(String key) {
    return RemoteParameter<Map<String, Object?>>(
      value: getJson(key),
      onConfigUpdated: onConfigUpdated.where(
        (config) => config.updatedKeys.contains(key),
      ),
      activateAndRefetch: () async {
        await fetchAndActivate();
        return getJson(key);
      },
    );
  }

  /// Returns a [RemoteParameter] of type [List] of [Map].
  RemoteParameter<List<Map<String, Object?>>> getListJsonParameter(String key) {
    return RemoteParameter<List<Map<String, Object?>>>(
      value: getListJson(key),
      onConfigUpdated: onConfigUpdated.where(
        (config) => config.updatedKeys.contains(key),
      ),
      activateAndRefetch: () async {
        await fetchAndActivate();
        return getListJson(key);
      },
    );
  }

  /// Returns a [RemoteParameter] of type [T].
  RemoteParameter<T> getDataParameter<T extends Object>({
    required String key,
    required T Function(Map<String, Object?>) fromJson,
  }) {
    return RemoteParameter<T>(
      value: getData<T>(key: key, fromJson: fromJson),
      onConfigUpdated: onConfigUpdated.where(
        (config) => config.updatedKeys.contains(key),
      ),
      activateAndRefetch: () async {
        await fetchAndActivate();
        return getData<T>(key: key, fromJson: fromJson);
      },
    );
  }
}
