import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../storage/key_chain_utils.dart';

///设备信息
class DeviceUtils {
  DeviceUtils._();

  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  static late BaseDeviceInfo _deviceInfo;
  static String _androidId = '';

  ///使用之前必须初始化设备信息
  static Future<void> initDeviceInfo() async {
    if (Platform.isAndroid) {
      _deviceInfo = await _deviceInfoPlugin.androidInfo;
      _androidId = (await const AndroidId().getId()) ?? '';
    } else if (Platform.isIOS) {
      _deviceInfo = await _deviceInfoPlugin.iosInfo;
    }
  }

  /// 将设备信息以Map的形式返回
  static Map<String, dynamic> get infoMap => _deviceInfo.data;

  ///当前设备是否是Android
  static bool get isAndroid => Platform.isAndroid;

  ///当前设备是否是iOS
  static bool get isIOS => Platform.isIOS;

  ///对于来自同一供应商且在同一设备上运行的应用程序，此属性的值相同,iOS删除app会重置。
  static String get deviceId =>
      isAndroid ? _androidId : (iosInfo.identifierForVendor ?? '');

  ///唯一ID，iOS会存在钥匙串中，即使删除，也不会发生改变，
  static Future<String> uniqueDeviceId() async {
    if (isAndroid) {
      return _androidId;
    } else {
      final localeId =
          await KeychainUtils.instance.get(key: 'unique_device_id');
      if (localeId == null || localeId.isEmpty) {
        final deviceId = iosInfo.identifierForVendor ?? '';
        await KeychainUtils.instance
            .put(key: 'unique_device_id', value: deviceId);
        return deviceId;
      } else {
        return localeId;
      }
    }
  }

  ///设备平台
  static String get platform => isAndroid ? "Android" : "iOS";

  ///设备的型号。
  static String get model => isAndroid ? androidInfo.model : iosInfo.model;

  ///是模拟器还是真实设备
  static bool get isPhysicalDevice =>
      isAndroid ? androidInfo.isPhysicalDevice : iosInfo.isPhysicalDevice;

  ///操作系统名称
  static String get systemName =>
      isAndroid ? (androidInfo.version.baseOS ?? '') : iosInfo.systemName;

  ///操作系统版本
  static String get systemVersion => isAndroid
      ? (androidInfo.version.sdkInt.toString())
      : iosInfo.systemVersion;

  ///手机品牌
  static String get brand => isAndroid ? androidInfo.brand : 'Apple';

  ///获取Android设备信息
  static AndroidDeviceInfo get androidInfo {
    return _deviceInfo as AndroidDeviceInfo;
  }

  ///获取iOS设备信息
  static IosDeviceInfo get iosInfo {
    return _deviceInfo as IosDeviceInfo;
  }
}
