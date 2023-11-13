import '../authenticator.dart';

extension UserExtension on User {
  bool get hasGoogleSigning => providerData.any(
        (userInfo) => userInfo.providerId == SigningMethod.google.providerId,
      );
  bool get hasAppleSigning => providerData.any(
        (userInfo) => userInfo.providerId == SigningMethod.apple.providerId,
      );
  bool get hasPhoneSigning => providerData.any(
        (userInfo) => userInfo.providerId == SigningMethod.phone.providerId,
      );
}
