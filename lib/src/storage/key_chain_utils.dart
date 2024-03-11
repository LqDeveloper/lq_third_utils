import 'key_chain_mixin.dart';

class KeychainUtils with KeychainMixin {
  static KeychainUtils instance = KeychainUtils._();

  factory KeychainUtils() => instance;

  KeychainUtils._();
}
