import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';

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
  Stream<RemoteConfigUpdate> get onConfigUpdated {
    return _rc.onConfigUpdated;
  }

  String getString(String key) {
    final value = _rc.getString(key);
    return value;
  }

  int getInt(String key) {
    final value = _rc.getInt(key);
    return value;
  }

  double getDouble(String key) {
    final value = _rc.getDouble(key);
    return value;
  }

  bool getBool(String key) {
    final value = _rc.getBool(key);
    return value;
  }

  /// Returns a JSON string converted to a [Map] type.
  Map<String, Object?> getJson(String key) {
    final value = _rc.getString(key);
    return json.decode(value) as Map<String, dynamic>;
  }

  /// Returns a List JSON string converted to a [List] type.
  List<Map<String, Object?>> getListJson(String key) {
    final value = _rc.getString(key);
    final list = json.decode(value) as List<dynamic>;
    return list.map((dynamic e) => e as Map<String, Object?>).toList();
  }

  /// Class Object from JSON.
  T getData<T extends Object>({
    required String key,
    required T Function(Map<String, Object?>) fromJson,
  }) {
    final json = getJson(key);
    return fromJson(json);
  }
}
