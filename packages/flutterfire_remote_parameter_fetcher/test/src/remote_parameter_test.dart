import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutterfire_remote_parameter_fetcher/src/remote_parameter.dart';

void main() {
  group('RemoteParameter', () {
    test('should initialize with correct value', () async {
      final rp = RemoteParameter<int>(
        value: 10,
        onConfigUpdated: const Stream<void>.empty(),
        activateAndRefetch: () async => 10,
      );

      expect(rp.value, 10);
    });

    test('should call listener when value changes', () async {
      final controller = StreamController<void>();
      addTearDown(controller.close);

      final rp = RemoteParameter<int>(
        value: 10,
        onConfigUpdated: controller.stream,
        activateAndRefetch: () async => 20,
      );

      int? updatedValue;
      rp.addListener((value) {
        updatedValue = value;
      });

      controller.add(null);

      await Future<void>.delayed(Duration.zero);

      expect(updatedValue, 20);
      expect(rp.value, 20);
    });

    test('should not call listener when removed', () async {
      final controller = StreamController<void>();
      addTearDown(controller.close);

      final rp = RemoteParameter<int>(
        value: 10,
        onConfigUpdated: controller.stream,
        activateAndRefetch: () async => 20,
      );

      var updatedValue = 10;
      void listener(int value) {
        updatedValue = value;
      }

      rp.addListener(listener);

      await rp.removeListener(listener);
      controller.add(null);
      await Future<void>.delayed(Duration.zero);

      expect(rp.value, 10);
      expect(updatedValue, 10);
    });

    test('should refetch value when config updates', () async {
      final controller = StreamController<void>();
      addTearDown(controller.close);

      var refetchCalled = false;
      final rp = RemoteParameter<int>(
        value: 10,
        onConfigUpdated: controller.stream,
        activateAndRefetch: () async {
          refetchCalled = true;
          return 20;
        },
      )..addListener((_) {});

      controller.add(null);

      await Future<void>.delayed(Duration.zero);

      expect(refetchCalled, true);
      expect(rp.value, 20);
    });
  });
}
