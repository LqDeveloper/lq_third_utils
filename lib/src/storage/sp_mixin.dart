import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

typedef SPKeyValueCallBack = void Function(String key, Object? value);

/// SharedPreferences管理Mixin
mixin SPMixin {
  late SharedPreferences _preferences;

  ///必须在使用之前调用
  Future<void> initSP() async {
    _preferences = await SharedPreferences.getInstance();
  }

  ///存储字符串
  Future<bool> _putString(String? key, String? value) async {
    if (key == null || key.isEmpty) {
      return false;
    }
    if (value == null || value.isEmpty) {
      return await _preferences.setString(key, '');
    }
    return await _preferences.setString(key, value);
  }

  ///获取字符串
  String _getString(String? key, {String defValue = ''}) {
    if (key == null || key.isEmpty) {
      return defValue;
    }
    final result = _preferences.getString(key);
    if (result == null) {
      return defValue;
    }
    return result;
  }

  /// 判断是否存在key的数据
  bool hasKey(String? key) {
    if (key == null || key.isEmpty) {
      return false;
    }
    return _preferences.getKeys().contains(key);
  }

  /// 存储sp中key的字符串
  Future<bool> putString(
    String? key,
    String? value,
  ) {
    return _putString(key, value);
  }

  /// 获取sp中key的字符串
  String getString(String? key, {String defValue = ""}) {
    return _getString(key, defValue: defValue);
  }

  /// 存储sp中key的布尔值
  Future<bool> putBool(String? key, bool? value) async {
    if (key == null || key.isEmpty || value == null) {
      return false;
    }
    return await _preferences.setBool(key, value);
  }

  /// 获取sp中key的布尔值
  bool getBool(String? key, {bool defValue = false}) {
    if (key == null || key.isEmpty) {
      return defValue;
    }
    return _preferences.getBool(key) ?? defValue;
  }

  /// 存储sp中key的int值
  Future<bool> putInt(String? key, int? value) async {
    if (key == null || key.isEmpty || value == null) {
      return false;
    }
    return await _preferences.setInt(key, value);
  }

  /// 获取sp中key的int值
  int getInt(String? key, {int defValue = 0}) {
    if (key == null || key.isEmpty) {
      return defValue;
    }
    return _preferences.getInt(key) ?? defValue;
  }

  /// 存储sp中key的double值
  Future<bool> putDouble(String? key, double? value) async {
    if (key == null || key.isEmpty || value == null) {
      return false;
    }
    return await _preferences.setDouble(key, value);
  }

  /// 获取sp中key的double值
  double getDouble(String? key, {double defValue = 0.0}) {
    if (key == null || key.isEmpty) {
      return defValue;
    }
    return _preferences.getDouble(key) ?? defValue;
  }

  /// put string list.
  /// 存储sp中key的list<String>值
  Future<bool> putStringList(String? key, List<String>? value) async {
    if (key == null || key.isEmpty) {
      return false;
    }
    if (value == null || value.isEmpty) {
      return await _preferences.setStringList(key, []);
    }
    return await _preferences.setStringList(key, value);
  }

  /// 获取sp中key的list<String>值
  List<String> getStringList(
    String? key, {
    List<String> defValue = const [],
  }) {
    if (key == null || key.isEmpty) {
      return defValue;
    }
    final result = _preferences.getStringList(key);
    if (result == null) {
      return defValue;
    }
    if (result.isEmpty) {
      return result;
    }
    return result;
  }

  /// 存储sp中key的map值
  Future<bool> putStringMap(String? key, Map? value) async {
    if (key == null || key.isEmpty) {
      return false;
    }
    if (value == null) {
      return await _preferences.setString(key, '');
    }
    final String jsonMapString = jsonEncode(value);
    return await _putString(key, jsonMapString);
  }

  /// 获取sp中key的map值
  Map getStringMap(String? key, {Map defValue = const {}}) {
    if (key == null || key.isEmpty) {
      return defValue;
    }
    final String jsonString = _getString(key, defValue: '');
    if (jsonString.isEmpty) {
      return defValue;
    }
    return json.decode(jsonString);
  }

  /// 移除sp中key的值
  Future<bool> remove(String? key) async {
    if (key == null || key.isEmpty) {
      return false;
    }
    return await _preferences.remove(key);
  }

  /// 清除sp
  Future<bool> clear() {
    return _preferences.clear();
  }

  /// 遍历sp
  void forEach(SPKeyValueCallBack callBack) {
    final Set<String> keys = _preferences.getKeys();
    final Iterator<String> iterator = keys.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current;
      final Object? value = _preferences.get(key);
      callBack(key, value);
    }
  }

  ///获取存储的所有值
  Map<String, dynamic> get allKayValueMap {
    final Map<String, dynamic> map = {};
    final Set<String> keys = _preferences.getKeys();
    final Iterator<String> iterator = keys.iterator;
    while (iterator.moveNext()) {
      final String key = iterator.current;
      final Object? value = _preferences.get(key);
      map[key] = value;
    }
    return map;
  }
}
