import 'package:firebase_auth/firebase_auth.dart';

/// 認証で発生したエラーを判別するためのエラークラス。
/// FirebaseAuthExceptionから生成する。
sealed class AuthException implements Exception {
  factory AuthException.fromError(FirebaseAuthException e) {
    return switch (e.code) {
      // Google認証でキャンセルした場合は「cancel」が返ってくる
      // Apple認証でキャンセルした場合は「canceled」が返ってくる
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

  @override
  String toString() => message;

  String get message;
}

class AuthCancelled implements AuthException {
  const AuthCancelled();

  @override
  String get message => '認証がキャンセルされました';
}

class AuthRequiresRecentSignIn implements AuthException {
  const AuthRequiresRecentSignIn();

  @override
  String get message => '再ログインが必要です';
}

class AuthInvalidPhoneNumber implements AuthException {
  const AuthInvalidPhoneNumber();

  @override
  String get message => '電話番号が不正です';
}

class AuthCredentialAlreadyInUse implements AuthException {
  const AuthCredentialAlreadyInUse();

  @override
  String get message => 'この認証情報はすでに使用されています';
}

class AuthFailedNetworkRequest implements AuthException {
  const AuthFailedNetworkRequest();

  @override
  String get message => 'ネットワークエラーが発生しました';
}

class AuthUndefinedError implements AuthException {
  const AuthUndefinedError();

  @override
  String get message => '予期せぬエラーが発生しました';
}

class AuthRequiresSignIn implements AuthException {
  const AuthRequiresSignIn();

  @override
  String get message => '予期せぬエラーが発生しました';
}
