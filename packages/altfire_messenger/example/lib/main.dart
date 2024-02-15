import 'dart:async';

import 'package:altfire_messenger/altfire_messenger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final messenger = Messenger();

  runApp(HomePage(messenger: messenger));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.messenger});

  final Messenger messenger;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('altfire_messenger example'),
        ),
        body: Center(
          child: FilledButton(
            child: const Text('Request permission'),
            onPressed: () {
              unawaited(messenger.requestPermission());
            },
          ),
        ),
      ),
    );
  }
}
