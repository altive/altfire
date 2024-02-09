import 'package:altfire_authenticator/altfire_authenticator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final authenticator = Authenticator();
  runApp(MainApp(authenticator: authenticator));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key, required this.authenticator});

  final Authenticator authenticator;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('altfire_authenticator example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Sign in with :', style: TextStyle(fontSize: 20)),
              FilledButton(
                child: const Text('Google'),
                onPressed: () async {
                  await authenticator.signInWithGoogle();
                },
              ),
              FilledButton(
                child: const Text('Apple'),
                onPressed: () async {
                  await authenticator.signInWithApple();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
