import 'package:altfire_authenticator/authenticator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Constructor', () {
    test('AuthCancelled instance is created from the "cancel"', () {
      final e = FirebaseAuthException(code: 'cancel');
      final sut = AuthException.fromError(e);
      expect(sut, isA<AuthCancelled>());
    });

    test('AuthCancelled instance is created from the "canceled"', () {
      final e = FirebaseAuthException(code: 'cancel');
      final sut = AuthException.fromError(e);
      expect(sut, isA<AuthCancelled>());
    });

    test(
      'AuthCancelled instance is created from the "requires-recent-login"',
      () {
        final e = FirebaseAuthException(code: 'requires-recent-login');
        final sut = AuthException.fromError(e);
        expect(sut, isA<AuthRequiresRecentSignIn>());
      },
    );

    test(
      'AuthCancelled instance is created from the "invalid-phone-number"',
      () {
        final e = FirebaseAuthException(code: 'invalid-phone-number');
        final sut = AuthException.fromError(e);
        expect(sut, isA<AuthInvalidPhoneNumber>());
      },
    );

    test(
      'AuthCancelled instance is created from the "credential-already-in-use"',
      () {
        final e = FirebaseAuthException(code: 'credential-already-in-use');
        final sut = AuthException.fromError(e);
        expect(sut, isA<AuthCredentialAlreadyInUse>());
      },
    );

    test(
      'AuthCancelled instance is created from the "network-request-failed"',
      () {
        final e = FirebaseAuthException(code: 'network-request-failed');
        final sut = AuthException.fromError(e);
        expect(sut, isA<AuthFailedNetworkRequest>());
      },
    );
  });
}
