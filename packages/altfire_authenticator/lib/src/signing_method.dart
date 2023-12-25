import 'package:firebase_auth/firebase_auth.dart';

enum SigningMethod {
  apple,
  google,
  phone,
  ;

  String get providerId {
    switch (this) {
      case SigningMethod.apple:
        return AppleAuthProvider.PROVIDER_ID;
      case SigningMethod.google:
        return GoogleAuthProvider.PROVIDER_ID;
      case SigningMethod.phone:
        return PhoneAuthProvider.PROVIDER_ID;
    }
  }
}
