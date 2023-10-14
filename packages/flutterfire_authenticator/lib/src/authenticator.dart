import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'apple_authenticator.dart';
import 'auth_exception.dart';
import 'google_authenticator.dart';
import 'phone_authenticator.dart';

/// [Authenticator] is a wrapper class for [FirebaseAuth].
class Authenticator {
  Authenticator({
    FirebaseAuth? auth,
    AppleAuthenticator? appleAuthenticator,
    GoogleAuthenticator? googleAuthenticator,
    PhoneAuthenticator? phoneAuthenticator,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _appleAuth = appleAuthenticator ??
            AppleAuthenticator(auth ?? FirebaseAuth.instance),
        _googleAuth = googleAuthenticator ??
            GoogleAuthenticator(auth ?? FirebaseAuth.instance),
        _phoneAuth = phoneAuthenticator ??
            PhoneAuthenticator(auth ?? FirebaseAuth.instance);

  final FirebaseAuth _auth;
  final AppleAuthenticator _appleAuth;
  final GoogleAuthenticator _googleAuth;
  final PhoneAuthenticator _phoneAuth;

  /// 現在サインイン中のユーザー。Null Assertionを使用しているので、
  /// `requireUser` にリネームした方が良さそう。
  User get _user => _auth.currentUser!;

  /// 現ユーザーのJWT(JSON Web Token)を非同期で取得する。
  /// 未サインイン時など、現ユーザーが存在しない場合はnullを返す。
  Future<String?>? get fetchJsonWebToken => _auth.currentUser?.getIdToken();

  /// 匿名サインイン
  Future<UserCredential> signInAnonymously() async {
    final userCredential = await _auth.signInAnonymously();
    return userCredential;
  }

  /// Sign in with Apple
  /// `PlatformException`, [FirebaseAuthException], `SignInWithAppleException`,
  /// [Exception] が発生する可能性がある
  Future<UserCredential> signInWithApple() async {
    return _appleAuth.signIn();
  }

  /// Sign in with Google.
  /// `PlatformException`, [Exception] が発生する可能性がある
  Future<UserCredential> signInWithGoogle() async {
    return _googleAuth.signIn();
  }

  /// 電話番号を検証
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required void Function(PhoneAuthCredential credential)
        verificationCompleted,
    required void Function(FirebaseAuthException e) verificationFailed,
    required void Function(String verificationId, int? resendToken) codeSent,
    required void Function(String verificationId) codeAutoRetrievalTimeout,
  }) async {
    await _phoneAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  /// SMS認証サインイン
  Future<UserCredential> signInWithSmsCode({
    required PhoneAuthCredential credential,
  }) async {
    return _phoneAuth.signIn(credential);
  }

  /// Link with Apple.
  Future<UserCredential> linkWithApple() async {
    return _appleAuth.link();
  }

  /// Link with Google.
  Future<UserCredential> linkWithGoogle() async {
    return _googleAuth.link();
  }

  /// Unlink from Apple.
  Future<User> unlinkFromApple() async {
    return _appleAuth.unlink();
  }

  /// Unlink from Google.
  Future<User> unlinkFromGoogle() async {
    return _googleAuth.unlink();
  }

  /// サインアウト
  Future<bool> signOut() async {
    try {
      await _auth.signOut();
      return true;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  /// アカウントを削除する
  Future<void> deleteAccount() async {
    try {
      // アカウントを削除実行
      await _user.delete();
    } on FirebaseAuthException catch (exception) {
      final e = AuthException.fromError(exception);
      if (e is AuthRequiresReLogin) {
        // 再認証の後、再度実行する
        await _reauthenticate();
        await _user.delete();
      } else {
        throw e;
      }
    }
  }

  /// 再認証を実施する
  Future<UserCredential> _reauthenticate() async {
    if (_googleAuth.alreadySigned) {
      return _googleAuth.reauthenticate();
    } else if (_appleAuth.alreadySigned) {
      return _appleAuth.reauthenticate();
    } else {
      throw UnimplementedError('未対応のSigningMethodがあります。');
    }
  }
}
