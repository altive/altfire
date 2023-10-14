import 'package:firebase_auth/firebase_auth.dart';

abstract class Authenticatable {
  /// すでにサインイン済みかどうか。
  bool get alreadySigned;

  /// サインイン。
  ///
  /// 電話番号認証ではサインイン処理が2STEPに分かれており、
  /// [AuthCredential]を外から渡す必要があるため、
  /// オプショナル引数として[AuthCredential]を受け取る形にしている。
  Future<UserCredential> signIn([AuthCredential? credential]);

  /// 再認証する。
  ///
  /// 電話番号認証ではサインイン処理が2STEPに分かれており、
  /// [AuthCredential]を外から渡す必要があるため、
  /// オプショナル引数として[AuthCredential]を受け取る形にしている。
  Future<UserCredential> reauthenticate([AuthCredential? credential]);

  /// ユーザーにAppleを紐付ける。
  ///
  /// 電話番号認証ではサインイン処理が2STEPに分かれており、
  /// [AuthCredential]を外から渡す必要があるため、
  /// オプショナル引数として[AuthCredential]を受け取る形にしている。
  Future<UserCredential> link([AuthCredential? credential]);

  /// Apple IDをリンク解除。
  Future<User> unlink();
}
