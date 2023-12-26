import 'dart:async';

import 'package:altfire_configurator/altfire_configurator.dart';
import 'package:flutter/material.dart';

int example() {
  // expect_lint: dispose_config
  final intConfig1 = Config<int>(
    value: 1,
    subscription: StreamController<int>().stream.listen((event) {}),
  );
  return intConfig1.value;
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late Config<int> _intConfig1;
  // expect_lint: dispose_config
  late Config<int> _intConfig2;

  final streamController = StreamController<int>();

  @override
  void initState() {
    _intConfig1 = Config(
      value: 1,
      subscription: streamController.stream.listen((event) {}),
    );
    _intConfig2 = Config(
      value: 2,
      subscription: streamController.stream.listen((event) {}),
    );
    debugPrint(_intConfig1.value.toString());
    debugPrint(_intConfig2.value.toString());
    super.initState();
  }

  @override
  Future<void> dispose() async {
    await _intConfig1.dispose();
    await streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
