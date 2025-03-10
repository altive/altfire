import 'package:altfire_configurator/altfire_configurator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final configurator = Configurator();
  await configurator.setDefaults({
    'int_parameter': 123,
  });

  runApp(MainApp(configurator: configurator));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key, required this.configurator});

  final Configurator configurator;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final Configurator configurator = widget.configurator;

  late Config<int> _intConfig;

  late int _intConfigValue;

  @override
  void initState() {
    super.initState();
    _intConfig = configurator.getIntConfig(
      'int_parameter',
      onConfigUpdated: (value) {
        debugPrint('Config value changed: $value');
        setState(() {
          _intConfigValue = value;
        });
      },
    );
    _intConfigValue = _intConfig.value;
  }

  @override
  Future<void> dispose() async {
    await _intConfig.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Altfire Configurator')),
        body: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Text('Config value: $_intConfigValue'),
          ),
        ),
      ),
    );
  }
}
