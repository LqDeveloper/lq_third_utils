import 'file_utils.dart';

/// 获取App常用的存储路径
class AppPath {
  AppPath._();

  /// - `NSCachesDirectory` on iOS and macOS.
  /// - `Context.getCacheDir` on Android.
  static String? _cacheDir;

  /// 缓存文件路径
  static String? get cacheDir => _cacheDir;

  static String? _appDocDir;

  /// - `NSDocumentDirectory` 在 iOS 和 macOS.
  /// - The Flutter engine's `PathUtils.getDataDirectory` API 在Android.
  static String? get appDocDir => _appDocDir;

  /// 需要在main方法中初始化
  static Future initPath() async {
    _cacheDir = await FileUtils.getTempDir();
    _appDocDir = await FileUtils.getAppDocDir();
  }
}
