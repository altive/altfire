import 'dart:async';

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

  group('onConfigUpdated', () {
    test('Can retrieve the Stream of RemoteConfigUpdate', () async {
      final mockRC = _FakeRemoteConfig();
      final target = RemoteParameterFetcher(rc: mockRC);

      final stream = target.onConfigUpdated;
      expect(stream, isA<Stream<RemoteConfigUpdate>>());
    });
  });

  group('filteredOnConfigUpdated', () {
    test('Can retrieve the Stream of RemoteConfigUpdate filtered by key',
        () async {
      final mockRC = _FakeRemoteConfig();
      final target = RemoteParameterFetcher(rc: mockRC);

      const key = 'string_001';

      final stream = target.filteredOnConfigUpdated(key);
      expect(stream, isA<Stream<RemoteConfigUpdate>>());
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

  group('getStringParameter', () {
    test(
      'Can retrieve the RemoteParameter<String> corresponding to the key',
      () async {
        final mockRC = _FakeRemoteConfig();
        final target = RemoteParameterFetcher(rc: mockRC);

        const key = 'string_001';
        var updatedValue = '';

        final parameter = target.getStringParameter(
          key,
          onConfigUpdated: (value) {
            updatedValue = value;
          },
        );

        expect(parameter, isA<RemoteParameter<String>>());
        expect(parameter.value, equals('string_value'));

        mockRC.configUpdatesController.add(
          RemoteConfigUpdate(<String>{key}),
        );

        await pumpEventQueue();

        expect(updatedValue, equals('string_value'));
      },
    );
  });

  group('getIntParameter', () {
    test(
      'Can retrieve the RemoteParameter<int> corresponding to the key',
      () async {
        final mockRC = _FakeRemoteConfig();
        final target = RemoteParameterFetcher(rc: mockRC);

        const key = 'int_001';
        var updatedValue = 0;

        final value = target.getIntParameter(
          key,
          onConfigUpdated: (value) {
            updatedValue = value;
          },
        );

        expect(value, isA<RemoteParameter<int>>());
        expect(value.value, equals(1));

        mockRC.configUpdatesController.add(
          RemoteConfigUpdate(<String>{key}),
        );

        await pumpEventQueue();

        expect(updatedValue, equals(1));
      },
    );
  });

  group('getDoubleParameter', () {
    test(
      'Can retrieve the RemoteParameter<double> corresponding to the key',
      () async {
        final mockRC = _FakeRemoteConfig();
        final target = RemoteParameterFetcher(rc: mockRC);

        const key = 'double_001';
        var updatedValue = 0.0;

        final value = target.getDoubleParameter(
          key,
          onConfigUpdated: (value) {
            updatedValue = value;
          },
        );

        expect(value, isA<RemoteParameter<double>>());
        expect(value.value, equals(0.1));

        mockRC.configUpdatesController.add(
          RemoteConfigUpdate(<String>{key}),
        );

        await pumpEventQueue();

        expect(updatedValue, equals(0.1));
      },
    );
  });

  group('getBoolParameter', () {
    test(
      'Can retrieve the RemoteParameter<bool> corresponding to the key',
      () async {
        final mockRC = _FakeRemoteConfig();
        final target = RemoteParameterFetcher(rc: mockRC);

        const key = 'bool_001';
        var updatedValue = false;

        final value = target.getBoolParameter(
          key,
          onConfigUpdated: (value) {
            updatedValue = value;
          },
        );

        expect(value, isA<RemoteParameter<bool>>());
        expect(value.value, isTrue);

        mockRC.configUpdatesController.add(
          RemoteConfigUpdate(<String>{key}),
        );

        await pumpEventQueue();

        expect(updatedValue, isTrue);
      },
    );
  });

  group('getJsonParameter', () {
    test(
      'Can retrieve the RemoteParameter<Map<String, Object?>> '
      'corresponding to the key',
      () async {
        final mockRC = _FakeRemoteConfig();
        final target = RemoteParameterFetcher(rc: mockRC);

        const key = 'json_001';
        var updatedValue = <String, Object?>{};

        final value = target.getJsonParameter(
          key,
          onConfigUpdated: (value) {
            updatedValue = value;
          },
        );

        expect(value, isA<RemoteParameter<Map<String, Object?>>>());
        expect(value.value, <String, Object?>{
          'value_1': '01',
          'value_2': 2,
          'value_3': 3.0,
          'value_4': true,
        });

        mockRC.configUpdatesController.add(
          RemoteConfigUpdate(<String>{key}),
        );

        await pumpEventQueue();

        expect(updatedValue, <String, Object?>{
          'value_1': '01',
          'value_2': 2,
          'value_3': 3.0,
          'value_4': true,
        });
      },
    );
  });

  group('getListJsonParameter', () {
    test(
      'Can retrieve the RemoteParameter<List<Map<String, Object?>>> '
      'corresponding to the key',
      () async {
        final mockRC = _FakeRemoteConfig();
        final target = RemoteParameterFetcher(rc: mockRC);

        const key = 'list_json_001';
        var updatedValue = <Map<String, Object?>>[];

        final value = target.getListJsonParameter(
          key,
          onConfigUpdated: (value) {
            updatedValue = value;
          },
        );

        expect(value, isA<RemoteParameter<List<Map<String, Object?>>>>());
        expect(
          value.value,
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

        mockRC.configUpdatesController.add(
          RemoteConfigUpdate(<String>{key}),
        );

        await pumpEventQueue();

        expect(
          updatedValue,
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
      },
    );
  });

  group('getDataParameter', () {
    test(
      'Can retrieve the RemoteParameter<Object> corresponding to the key',
      () async {
        final mockRC = _FakeRemoteConfig();
        final target = RemoteParameterFetcher(rc: mockRC);

        const key = 'data_001';
        var updatedValue = const DataClass(value: '');

        final value = target.getDataParameter(
          key,
          fromJson: DataClass.fromJson,
          onConfigUpdated: (value) {
            updatedValue = value;
          },
        );

        expect(value, isA<RemoteParameter<DataClass>>());
        expect(value.value, const DataClass(value: 'tokyo'));

        mockRC.configUpdatesController.add(
          RemoteConfigUpdate(<String>{key}),
        );

        await pumpEventQueue();

        expect(updatedValue, const DataClass(value: 'tokyo'));
      },
    );
  });
}

class _FakeRemoteConfig extends Fake implements FirebaseRemoteConfig {
  final configUpdatesController = StreamController<RemoteConfigUpdate>();

  @override
  Stream<RemoteConfigUpdate> get onConfigUpdated =>
      configUpdatesController.stream;

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

  @override
  Future<bool> activate() async {
    return true;
  }

  void dispose() {
    unawaited(configUpdatesController.close());
  }
}
