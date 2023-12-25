import 'package:firebase_auth/firebase_auth.dart';

import '../authenticator.dart';
import 'authenticatable.dart';

class PhoneAuthenticator implements Authenticatable {
  PhoneAuthenticator(this._auth);

  final FirebaseAuth _auth;

  User get _user => _auth.currentUser!;

  /// 既に電話番号でサインイン済みなら`true`
  @override
  bool get alreadySigned => _auth.currentUser?.hasPhoneSigning ?? false;

  /// 電話番号を検証し認証コードを送信する。
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential credential)
        verificationCompleted,
    required void Function(FirebaseAuthException exception) verificationFailed,
    required void Function(String verificationId, int? forceResendingToken)
        codeSent,
    required void Function(String verificationId) codeAutoRetrievalTimeout,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  /// SMS認証コードを使ってサインインする。
  @override
  Future<UserCredential> signIn([AuthCredential? credential]) async {
    if (credential == null) {
      throw ArgumentError.notNull('credential');
    }
    return _auth.signInWithCredential(credential);
  }

  /// 電話番号認証で再認証する。
  @override
  Future<UserCredential> reauthenticate([AuthCredential? credential]) {
    if (credential == null) {
      throw ArgumentError.notNull('credential');
    }
    return _user.reauthenticateWithCredential(credential);
  }

  /// 電話番号認証を連携する。
  @override
  Future<UserCredential> link([AuthCredential? credential]) {
    if (credential == null) {
      throw ArgumentError.notNull('credential');
    }
    return _user.linkWithCredential(credential);
  }

  /// 電話番号認証の連携を解除する。
  @override
  Future<User> unlink() {
    return _user.unlink(SigningMethod.phone.providerId);
  }
}
