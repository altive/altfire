// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authenticator_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authenticatorHash() => r'32c6823ef101f53205b9acc89ad3f3c0710ca1bd';

/// See also [authenticator].
@ProviderFor(authenticator)
final authenticatorProvider = Provider<Authenticator>.internal(
  authenticator,
  name: r'authenticatorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authenticatorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AuthenticatorRef = ProviderRef<Authenticator>;
String _$uidHash() => r'c9fdef338d1416bbfc9e52bd2a188108a2549364';

/// See also [uid].
@ProviderFor(uid)
final uidProvider = Provider<String?>.internal(
  uid,
  name: r'uidProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$uidHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UidRef = ProviderRef<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
