import 'package:firebase_auth/firebase_auth.dart';

/// Error class for identifying errors that occur during authentication.
/// Generated from FirebaseAuthException.
sealed class AuthException implements Exception {
  factory AuthException.fromError(Object e) {
    if (e is! FirebaseAuthException) {
      return const AuthUndefinedError();
    }
    return switch (e.code) {
      // When Google authentication is cancelled, 'cancel' is returned.
      // When Apple authentication is cancelled, 'canceled' is returned.
      'cancel' || 'canceled' => const AuthCancelled(),
      'requires-recent-login' => const AuthRequiresRecentSignIn(),
      'invalid-phone-number' => const AuthInvalidPhoneNumber(),
      'credential-already-in-use' => const AuthCredentialAlreadyInUse(),
      'network-request-failed' => const AuthFailedNetworkRequest(),
      // 'email-already-in-use' => const ,
      // 'provider-already-linked' => const ,
      // 'too-many-requests' => const ,
      // 'account-exists-with-different-credential' => const ,
      // 'invalid-credential' => const ,
      // 'user-disabled' => const ,
      _ => const AuthUndefinedError(),
    };
  }
}

class AuthCancelled implements AuthException {
  const AuthCancelled();
}

class AuthRequiresRecentSignIn implements AuthException {
  const AuthRequiresRecentSignIn();
}

class AuthInvalidPhoneNumber implements AuthException {
  const AuthInvalidPhoneNumber();
}

class AuthCredentialAlreadyInUse implements AuthException {
  const AuthCredentialAlreadyInUse();
}

class AuthFailedNetworkRequest implements AuthException {
  const AuthFailedNetworkRequest();
}

class AuthUndefinedError implements AuthException {
  const AuthUndefinedError();
}

class AuthRequiresSignIn implements AuthException {
  const AuthRequiresSignIn();
}
