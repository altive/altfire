import 'package:altfire_authenticator/altfire_authenticator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'authenticator_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final authenticator = Authenticator();
  runApp(
    ProviderScope(
      overrides: [
        authenticatorProvider.overrideWithValue(authenticator),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authenticator = ref.watch(authenticatorProvider);
    final uid = ref.watch(uidProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('altfire_authenticator example'),
        ),
        body: uid == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      child: const Text('Sign in with Google'),
                      onPressed: () async {
                        await authenticator.signInWithGoogle();
                        ref.invalidate(uidProvider);
                      },
                    ),
                  ],
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('uid: $uid'),
                    FilledButton(
                      child: const Text('Sign out'),
                      onPressed: () async {
                        await authenticator.signOut();
                        ref.invalidate(uidProvider);
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
