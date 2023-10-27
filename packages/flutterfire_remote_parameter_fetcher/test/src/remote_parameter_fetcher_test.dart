import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterfire_remote_parameter_fetcher/remote_parameter_fetcher.dart';

import '../data_class.dart';

void main() {
  group('setDefaults', () {
    test('Error occurs when setting a Class instance as a value', () {
      final mockRC = _FakeRemoteConfig();
      final target = RemoteParameterFetcher(rc: mockRC);

      expect(
        () async =>
            target.setDefaults({'key': const DataClass(value: 'value')}),
        throwsAssertionError,
      );
    });

    test('Error occurs when setting a List type as a value', () {
      final mockRC = _FakeRemoteConfig();
      final target = RemoteParameterFetcher(rc: mockRC);

      expect(
        () async => target.setDefaults({
          'key': ['ABC', 'DEF'],
        }),
        throwsAssertionError,
      );
    });

    test('Error occurs when setting a Map type as a value', () {
      final mockRC = _FakeRemoteConfig();
      final target = RemoteParameterFetcher(rc: mockRC);

      expect(
        () async => target.setDefaults({
          'key': {'key': 'value'},
        }),
        throwsAssertionError,
      );
    });
  });

  group('getString', () {
    test('Can retrieve the Remote string corresponding to the key', () {
      final mockRC = _FakeRemoteConfig();
      final target = RemoteParameterFetcher(rc: mockRC);

      const key = 'string_001';

      final value = target.getString(key);
      expect(value, equals('string_value'));
    });
  });

  group('getInt', () {
    test('Can retrieve the Remote integer corresponding to the key', () {
      final mockRC = _FakeRemoteConfig();
      final target = RemoteParameterFetcher(rc: mockRC);

      const key = 'int_001';

      final value = target.getInt(key);
      expect(value, equals(1));
    });
  });

  group('getDouble', () {
    test(
      'Can retrieve the Remote floating-point number corresponding to the key',
      () {
        final mockRC = _FakeRemoteConfig();
        final target = RemoteParameterFetcher(rc: mockRC);

        const key = 'double_001';

        final value = target.getDouble(key);
        expect(value, equals(0.1));
      },
    );
  });

  group('getBool', () {
    test('Can retrieve the boolean value corresponding to the key', () {
      final mockRC = _FakeRemoteConfig();
      final target = RemoteParameterFetcher(rc: mockRC);

      const key = 'bool_001';

      final value = target.getBool(key);
      expect(value, isTrue);
    });
  });

  group('getJson', () {
    test('Can retrieve the JSON (Map) corresponding to the key', () {
      final mockRC = _FakeRemoteConfig();
      final target = RemoteParameterFetcher(rc: mockRC);

      const key = 'json_001';

      final value = target.getJson(key);
      expect(value, <String, Object?>{
        'value_1': '01',
        'value_2': 2,
        'value_3': 3.0,
        'value_4': true,
      });
    });
  });

  group('getListJson', () {
    test('Can retrieve the list of JSON (Map) corresponding to the key', () {
      final mockRC = _FakeRemoteConfig();
      final target = RemoteParameterFetcher(rc: mockRC);

      const key = 'list_json_001';

      final value = target.getListJson(key);
      expect(
        value,
        [
          {
            'value_1a': '01a',
            'value_2a': 2,
            'value_3a': 3.0,
            'value_4a': true,
          },
          {
            'value_1b': '01b',
            'value_2b': 20,
            'value_3b': 3.5,
            'value_4b': false,
          }
        ],
      );
    });
  });

  group('getData', () {
    test('Can retrieve the class object corresponding to the key', () {
      final mockRC = _FakeRemoteConfig();
      final target = RemoteParameterFetcher(rc: mockRC);

      const key = 'data_001';

      final value = target.getData(key: key, fromJson: DataClass.fromJson);

      expect(value, const DataClass(value: 'tokyo'));
    });
  });
}

class _FakeRemoteConfig extends Fake implements FirebaseRemoteConfig {
  @override
  String getString(String key) {
    switch (key) {
      case 'string_001':
        return 'string_value';

      case 'json_001':
        return '''
      {
        "value_1": "01",
        "value_2": 2,
        "value_3": 3.0,
        "value_4": true
      }
      ''';

      case 'list_json_001':
        return '''
      [
        {
          "value_1a": "01a",
          "value_2a": 2,
          "value_3a": 3.0,
          "value_4a": true
        },
        {
          "value_1b": "01b",
          "value_2b": 20,
          "value_3b": 3.5,
          "value_4b": false
        }
      ]
      ''';

      case 'data_001':
        return '''
      {
        "value": "tokyo"
      }
      ''';
    }
    throw UnimplementedError();
  }

  @override
  int getInt(String key) {
    return 1;
  }

  @override
  double getDouble(String key) {
    return 0.1;
  }

  @override
  bool getBool(String key) {
    return true;
  }
}
