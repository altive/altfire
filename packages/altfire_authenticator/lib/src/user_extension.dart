import '../altfire_authenticator.dart';

/// Extension methods for the [User] class.
extension UserExtension on User {
  /// Whether the user has a Google account.
  bool get hasGoogleSigning => providerData.any(
        (userInfo) => userInfo.providerId == SigningMethod.google.providerId,
      );

  /// Whether the user has an Apple account.
  bool get hasAppleSigning => providerData.any(
        (userInfo) => userInfo.providerId == SigningMethod.apple.providerId,
      );

  /// Whether the user has a phone number.
  bool get hasPhoneSigning => providerData.any(
        (userInfo) => userInfo.providerId == SigningMethod.phone.providerId,
      );
}
