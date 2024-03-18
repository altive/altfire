import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:altfire_tracker/altfire_tracker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final tracker = Tracker();
  FlutterError.onError = tracker.onFlutterError;
  PlatformDispatcher.instance.onError = tracker.onPlatformError;
  Isolate.current.addErrorListener(tracker.isolateErrorListener());
  await tracker.setUserId('example_user_id');

  runApp(
    MaterialApp(
      home: HomePage(tracker: tracker),
      initialRoute: '/',
      navigatorObservers: [
        ...tracker.navigatorObservers(),
      ],
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              child: const Text('Log event'),
              onPressed: () {
                unawaited(
                  tracker.logEvent(
                    'example_event',
                    parameters: {
                      'example_key': 'example_value',
                    },
                  ),
                );
              },
            ),
            FilledButton(
              onPressed: () {
                try {
                  throw Exception('example exception');
                } on Exception catch (e, stackTrace) {
                  unawaited(tracker.recordError(e, stackTrace));
                }
              },
              child: const Text('Record Error'),
            ),
            FilledButton(
              onPressed: () {
                throw FlutterError('example unhandled exception');
              },
              child: const Text('Record unhandled Exception'),
            ),
            FilledButton(
              onPressed: () async {
                await Navigator.of(context).push<void>(
                  MaterialPageRoute(
                    builder: (context) {
                      return Scaffold(
                        appBar: AppBar(
                          title: const Text('Track Screen Page'),
                        ),
                        body: Center(
                          child: FilledButton(
                            onPressed: () {
                              tracker.trackScreenView('/example');
                            },
                            child: const Text('Send Screen View Event'),
                          ),
                        ),
                      );
                    },
                    settings: const RouteSettings(name: '/track'),
                  ),
                );
              },
              child: const Text('Track Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
