import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../altfire_authenticator.dart';
import 'authenticatable.dart';

class GoogleAuthenticator implements Authenticatable {
  GoogleAuthenticator(this._auth);

  final FirebaseAuth _auth;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User get _user => _auth.currentUser!;

  @override
  bool get alreadySigned => _auth.currentUser?.hasGoogleSigning ?? false;

  @override
  Future<UserCredential> signIn([AuthCredential? credential]) async {
    final credential = await _retrieveCredential();
    final userCredential = await _auth.signInWithCredential(credential);
    return userCredential;
  }

  @override
  Future<UserCredential> reauthenticate([AuthCredential? credential]) async {
    final credential = await _retrieveCredential();
    return _user.reauthenticateWithCredential(credential);
  }

  @override
  Future<UserCredential> link([AuthCredential? credential]) async {
    final provider = GoogleAuthProvider();
    return _user.linkWithProvider(provider);
  }

  @override
  Future<User> unlink() async {
    return _user.unlink(SigningMethod.google.providerId);
  }

  Future<OAuthCredential> _retrieveCredential() async {
    final googleAccount = await _googleSignIn.signIn();
    if (googleAccount == null) {
      throw FirebaseAuthException(code: 'cancel');
    }
    final googleAuth = await googleAccount.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return credential;
  }
}
