import 'package:flutter_secure_storage/flutter_secure_storage.dart';

mixin KeychainMixin {
  late FlutterSecureStorage _storage;

  void initKeychain({FlutterSecureStorage? storage}) {
    if (storage == null) {
      AndroidOptions getAndroidOptions() => const AndroidOptions(
            encryptedSharedPreferences: true,
          );
      _storage = FlutterSecureStorage(aOptions: getAndroidOptions());
    } else {
      _storage = storage;
    }
  }

  Future<void> put({
    required String? key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
  }) async {
    if (key == null || key.isEmpty) {
      return;
    }
    await _storage.write(
      key: key,
      value: value,
      iOptions: iOptions,
      aOptions: aOptions,
    );
  }

  Future<String?> get({
    required String? key,
    String? defValue,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
  }) async {
    if (key == null || key.isEmpty) {
      return defValue;
    }
    final String? value = await _storage.read(
      key: key,
      iOptions: iOptions,
      aOptions: aOptions,
    );
    return value ?? defValue;
  }

  Future<Map<String, String>> getAll({
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
  }) async {
    final Map<String, String> allValues = await _storage.readAll(
      iOptions: iOptions,
      aOptions: aOptions,
    );
    return allValues;
  }

  Future<bool> containsKey({
    required String? key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
  }) async {
    if (key == null || key.isEmpty) {
      return false;
    }
    final isContain = await _storage.containsKey(
      key: key,
      iOptions: iOptions,
      aOptions: aOptions,
    );
    return isContain;
  }

  Future<void> delete({
    required String? key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
  }) async {
    if (key == null || key.isEmpty) {
      return;
    }
    await _storage.delete(
      key: key,
      iOptions: iOptions,
      aOptions: aOptions,
    );
  }

  Future<void> deleteAll({
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
  }) async {
    await _storage.deleteAll(
      iOptions: iOptions,
      aOptions: aOptions,
    );
  }
}
