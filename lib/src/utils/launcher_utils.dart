import 'package:url_launcher/url_launcher_string.dart';

///跳转到浏览器，发短信，打电话
///发短信，打电话需要额外配置
/// [url_launcher](https://github.com/flutter/packages/tree/main/packages/url_launcher/url_launcher)
class LauncherUtils {
  LauncherUtils._();

  ///当前urlStr是否可以launch
  static Future<bool> canLaunchUrl(String? urlStr) async {
    if (urlStr == null || urlStr.isEmpty) {
      return false;
    }
    final result = await canLaunchUrlString(urlStr);
    return result;
  }

  ///跳转到Url
  static Future<bool> launchUrl(
    String? urlStr, {
    LaunchMode mode = LaunchMode.platformDefault,
    WebViewConfiguration webViewConfiguration = const WebViewConfiguration(),
    String? webOnlyWindowName,
  }) async {
    if (urlStr == null || urlStr.isEmpty) {
      return false;
    }
    try {
      final result = await launchUrlString(
        urlStr,
        mode: mode,
        webViewConfiguration: webViewConfiguration,
        webOnlyWindowName: webOnlyWindowName,
      );
      return result;
    } on Exception catch (_) {
      return false;
    }
  }

  ///跳转之前，先校验Url是否可以跳转
  static Future<bool> checkLaunchUrl(
    String? urlStr, {
    LaunchMode mode = LaunchMode.platformDefault,
    WebViewConfiguration webViewConfiguration = const WebViewConfiguration(),
    String? webOnlyWindowName,
  }) async {
    if (urlStr == null || urlStr.isEmpty) {
      return false;
    }
    final canLaunch = await canLaunchUrl(urlStr);
    if (!canLaunch) {
      return false;
    }
    final result = await launchUrlString(
      urlStr,
      mode: mode,
      webViewConfiguration: webViewConfiguration,
      webOnlyWindowName: webOnlyWindowName,
    );
    return result;
  }
}
