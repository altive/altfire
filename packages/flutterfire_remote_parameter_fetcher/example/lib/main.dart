import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_remote_parameter_fetcher/remote_parameter_fetcher.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final rpf = RemoteParameterFetcher();
  await rpf.setDefaults({
    'int_parameter': 123,
  });

  runApp(MainApp(rpf: rpf));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key, required this.rpf});

  final RemoteParameterFetcher rpf;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final rpf = widget.rpf;

  late RemoteParameter<int> _intRemoteParameter;

  late int _intParameterValue;

  @override
  void initState() {
    super.initState();
    _intRemoteParameter = rpf.getIntParameter(
      'int_parameter',
      onConfigUpdated: (value) {
        debugPrint('remoteParameter value changed: $value');
        _intParameterValue = value;
      },
    );
    _intParameterValue = _intRemoteParameter.value;
  }

  @override
  Future<void> dispose() async {
    await _intRemoteParameter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('FlutterFireRemoteParameterFetcher')),
        body: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Text('RemoteParameter value: $_intParameterValue'),
          ),
        ),
      ),
    );
  }
}
