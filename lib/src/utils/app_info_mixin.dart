import 'device_utils.dart';
import 'package_utils.dart';

/// 设备和App信息Mixin
mixin AppInfoMixin {
  /// 应用名称.  iOS中的`CFBundleDisplayName`, Android中的`application/label`.
  String get appName => PackageUtils.appName;

  /// 包名. iOS中的 bundleIdentifier`, Android中的`getPackageName`.
  String get packageName => PackageUtils.packageName;

  /// 包版本. iOS中的`CFBundleShortVersionString`, Android中的`versionName`.
  String get version => PackageUtils.version;

  /// 构建版本. iOS中的`CFBundleVersion` on iOS, Android中的`versionCode`.
  String get buildNumber => PackageUtils.buildNumber;

  /// 应用签名. iOS中未空字符串, Android上的签名密钥签名（十六进制）.
  String get buildSignature => PackageUtils.buildSignature;

  ///设备唯一ID，卸载会更新
  String get deviceId => DeviceUtils.deviceId;

  ///设备唯一ID，卸载不会更新
  Future<String> uniqueDeviceId() async => await DeviceUtils.uniqueDeviceId();

  ///设备平台
  String get platform => DeviceUtils.platform;

  ///设备的型号
  String get model => DeviceUtils.model;

  ///是模拟器还是真实设备
  bool get isPhysicalDevice => DeviceUtils.isPhysicalDevice;

  ///操作系统名称
  String get systemName => DeviceUtils.systemName;

  ///操作系统版本
  String get systemVersion => DeviceUtils.systemVersion;

  ///手机品牌
  String get brand => DeviceUtils.brand;
}
