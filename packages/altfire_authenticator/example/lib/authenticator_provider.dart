import 'package:altfire_authenticator/altfire_authenticator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authenticator_provider.g.dart';

@Riverpod(keepAlive: true)
Authenticator authenticator(AuthenticatorRef ref) => throw UnimplementedError();

@Riverpod(keepAlive: true)
String? uid(UidRef ref) {
  return ref.watch(authenticatorProvider).user?.uid;
}
