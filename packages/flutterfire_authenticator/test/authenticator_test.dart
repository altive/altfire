import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutterfire_authenticator/authenticator.dart';

void main() {
  test('initialization', () async {
    // TestWidgetsFlutterBinding.ensureInitialized();
    // await Firebase.initializeApp();
    final sut = Authenticator(auth: MockAuth());
    expect(sut, isA<Authenticator>());
  });
}

class MockAuth extends Fake implements FirebaseAuth {}

// TODO(riscait): add more tests
// https://github.com/altive/flutterfire_adapter/issues/20
// related links:
// https://github.com/firebase/flutterfire/blob/master/packages/firebase_auth/firebase_auth/test/firebase_auth_test.dart
// setupFirebaseAuthMocks
// https://github.com/firebase/flutterfire/blob/master/packages/firebase_auth/firebase_auth/test/mock.dart
// setupFirebaseCoreMocks
// https://github.com/firebase/flutterfire/blob/master/packages/firebase_core/firebase_core_platform_interface/lib/src/pigeon/mocks.dart
