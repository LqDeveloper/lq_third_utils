import 'dart:convert';

import 'package:crypto/crypto.dart';

/// 常用Hash类型
enum HashType {
  sha1,
  sha224,
  sha256,
  sha384,
  sha512,
  sha512224,
  sha512256,
  md5;
}

/// Hash编码工具类
class CryptoUtils {
  CryptoUtils._();

  static List<int> _encode(String? value) {
    if (value == null || value.isEmpty) {
      return [];
    }
    return utf8.encode(value);
  }

  static Hash _hash(HashType hashType) {
    switch (hashType) {
      case HashType.sha1:
        return sha1;
      case HashType.sha224:
        return sha224;
      case HashType.sha256:
        return sha256;
      case HashType.sha384:
        return sha384;
      case HashType.sha512:
        return sha512;
      case HashType.sha512224:
        return sha512224;
      case HashType.sha512256:
        return sha512256;
      case HashType.md5:
        return md5;
    }
  }

  static Digest? _digest({
    required HashType hashType,
    required String? data,
    bool isHmac = false,
    List<int> key = const [],
  }) {
    if (data == null || data.isEmpty) {
      return null;
    }
    final bytes = _encode(data);
    final hashObj = _hash(hashType);
    if (isHmac && key.isNotEmpty) {
      final hmac = Hmac(hashObj, key);
      return hmac.convert(bytes);
    } else {
      return hashObj.convert(bytes);
    }
  }

  static List<int> hashBytes({
    required HashType hashType,
    required String? data,
    bool isHmac = false,
    List<int> key = const [],
  }) {
    return _digest(hashType: hashType, data: data, isHmac: isHmac, key: key)
            ?.bytes ??
        [];
  }

  /// Hash 编码
  static String hashHexStr({
    required HashType hashType,
    required String? data,
    bool isHmac = false,
    List<int> key = const [],
  }) {
    return _digest(hashType: hashType, data: data, isHmac: isHmac, key: key)
            ?.toString() ??
        '';
  }
}
