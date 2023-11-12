import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutterfire_remote_parameter_fetcher/src/remote_parameter.dart';

void main() {
  group('RemoteParameter', () {
    test('should initialize with correct value', () async {
      final controller = StreamController<void>();
      addTearDown(controller.close);
      final rp = RemoteParameter<int>(
        value: 10,
        subscription: controller.stream.listen((event) {}),
      );

      expect(rp.value, 10);
    });

    test('should update value when stream emits', () async {
      final controller = StreamController<int>();
      addTearDown(controller.close);
      var value = 10;
      RemoteParameter<int>(
        value: value,
        subscription: controller.stream.listen((event) {
          value = event;
        }),
      );

      controller.add(20);

      await pumpEventQueue();

      expect(value, 20);
    });

    test('should close subscription when dispose is called', () async {
      final controller = StreamController<int>();
      addTearDown(controller.close);
      var value = 10;
      final rp = RemoteParameter<int>(
        value: 10,
        subscription: controller.stream.listen((event) {
          value = event;
        }),
      );

      controller.add(20);
      await pumpEventQueue();
      expect(value, 20);

      await rp.dispose();

      controller.add(30);
      await pumpEventQueue();
      expect(value, 20);
    });
  });
}
