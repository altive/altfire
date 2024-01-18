import 'package:altfire_tracker/altfire_tracker.dart';
import 'package:altfire_tracker_example/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MaterialApp(
      home: HomePage(tracker: Tracker()),
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
      appBar: AppBar(title: const Text('altfire tracker')),
      body: Center(
        child: FilledButton(
          child: const Text('Log event'),
          onPressed: () {
            tracker.logEvent('example_event');

            try {
              throw Exception('example exception');
            } catch (error, stackTrace) {
              tracker.recordError(error, stackTrace);
            }
          },
        ),
      ),
    );
  }
}
