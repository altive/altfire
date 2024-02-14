import 'package:altfire_authenticator/altfire_authenticator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final authenticator = Authenticator();
  runApp(
    MainApp(
      authenticator: authenticator,
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key, required this.authenticator});

  final Authenticator authenticator;
  @override
  State<StatefulWidget> createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  String? uid;

  @override
  void initState() {
    widget.authenticator.userChanges.listen((user) {
      setState(() {
        uid = user?.uid;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('altfire_authenticator example'),
        ),
        body: uid == null
            ? Center(
                child: ElevatedButton(
                  child: const Text('Sign in with Google'),
                  onPressed: () async {
                    await widget.authenticator.signInWithGoogle();
                  },
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('uid: $uid'),
                    ElevatedButton(
                      child: const Text('Sign out'),
                      onPressed: () async {
                        await widget.authenticator.signOut();
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
