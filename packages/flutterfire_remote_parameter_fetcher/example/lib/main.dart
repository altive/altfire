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

  late final _intRemoteParameter = rpf.getIntParameter('int_parameter');

  late int _intParameterValue;

  void listen(int value) {
    debugPrint('remoteParameter value changed: $value');
    _intParameterValue = value;
  }

  @override
  void initState() {
    super.initState();
    _intParameterValue = _intRemoteParameter.value;
    _intRemoteParameter.addListener(listen);
  }

  @override
  void dispose() {
    // TODO(riscait): adding
    // remoteParameter.removeListener(listen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('FlutterFireRemoteParameterFetcher')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('RemoteParameter value: $_intParameterValue'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () async {
                await _intRemoteParameter.activateAndRefetch();
              },
              child: const Text('Activate and refetch'),
            ),
          ],
        ),
      ),
    );
  }
}
