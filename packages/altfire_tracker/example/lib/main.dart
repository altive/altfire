import 'dart:isolate';
import 'dart:ui';

import 'package:altfire_tracker/altfire_tracker.dart';
import 'package:altfire_tracker_example/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final tracker = Tracker();
  FlutterError.onError = tracker.onFlutterError;
  PlatformDispatcher.instance.onError = tracker.onPlatformError;
  Isolate.current.addErrorListener(tracker.isolateErrorListener());
  tracker.setUserId('example_user_id');

  runApp(
    MaterialApp(
      home: HomePage(tracker: tracker),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.tracker,
  });

  final Tracker tracker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('altfire_tracker example')),
      body: Center(
        child: FilledButton(
          child: const Text('Log event'),
          onPressed: () {
            tracker.logEvent('example_event', parameters: {
              'example_key': 'example_value',
            });

            try {
              throw Exception('example exception');
            } catch (e, stackTrace) {
              tracker.recordError(e, stackTrace);
            }
          },
        ),
      ),
    );
  }
}
