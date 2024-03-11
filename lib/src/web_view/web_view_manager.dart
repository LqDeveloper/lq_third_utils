import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'web_cookie.dart';

/// 管理WebView的调试和通用InAppWebViewSettings
class WebViewManager {
  static final WebViewManager instance = WebViewManager._();

  factory WebViewManager() => instance;

  WebViewManager._();

  CookieManager get _cookieManager => CookieManager.instance();

  final InAppWebViewSettings globalSetting = InAppWebViewSettings();

  Future<void> setAndroidDebugEnable(bool enable) async {
    if (!kIsWeb && Platform.isAndroid) {
      await InAppWebViewController.setWebContentsDebuggingEnabled(enable);
    }
  }

  Future<void> setCookie({
    required Uri url,
    required String name,
    required String value,
    String path = "/",
    String? domain,
    int? expiresDate,
    int? maxAge,
    bool? isSecure,
    bool? isHttpOnly,
    HTTPCookieSameSitePolicy? sameSite,
    InAppWebViewController? webViewController,
  }) {
    return _cookieManager.setCookie(
      url: WebUri.uri(url),
      name: name,
      value: value,
      path: path,
      domain: domain,
      expiresDate: expiresDate,
      maxAge: maxAge,
      isSecure: isSecure,
      isHttpOnly: isHttpOnly,
      sameSite: sameSite,
      webViewController: webViewController,
    );
  }

  Future<List<WebCookie>> getCookies({
    required Uri url,
    InAppWebViewController? webViewController,
  }) async {
    final list = await _cookieManager.getCookies(
      url: WebUri.uri(url),
      webViewController: webViewController,
    );
    return list
        .map((e) => WebCookie(
              name: e.name,
              value: e.value,
              expiresDate: e.expiresDate,
              isSessionOnly: e.isSessionOnly,
              domain: e.domain,
              sameSite: e.sameSite,
              isSecure: e.isSecure,
              isHttpOnly: e.isHttpOnly,
              path: e.path,
            ))
        .toList();
  }

  Future<WebCookie?> getCookie({
    required Uri url,
    required String name,
    InAppWebViewController? webViewController,
  }) async {
    final cookie = await _cookieManager.getCookie(
      url: WebUri.uri(url),
      name: name,
      webViewController: webViewController,
    );
    if (cookie == null) {
      return null;
    }
    return WebCookie(
      name: cookie.name,
      value: cookie.value,
      expiresDate: cookie.expiresDate,
      isSessionOnly: cookie.isSessionOnly,
      domain: cookie.domain,
      sameSite: cookie.sameSite,
      isSecure: cookie.isSecure,
      isHttpOnly: cookie.isHttpOnly,
      path: cookie.path,
    );
  }

  Future<void> deleteCookie({
    required Uri url,
    required String name,
    String path = "/",
    String? domain,
    InAppWebViewController? webViewController,
  }) {
    return _cookieManager.deleteCookie(
      url: WebUri.uri(url),
      name: name,
      path: path,
      domain: domain,
      webViewController: webViewController,
    );
  }

  Future<void> deleteCookies({
    required Uri url,
    String path = "/",
    String? domain,
    InAppWebViewController? webViewController,
  }) {
    return _cookieManager.deleteCookies(
      url: WebUri.uri(url),
      path: path,
      domain: domain,
      webViewController: webViewController,
    );
  }

  Future<void> deleteAllCookies() {
    return _cookieManager.deleteAllCookies();
  }

  ///清空web缓存
  Future<void> clearWebCache() async {
    final WebStorageManager webStorageManager = WebStorageManager.instance();
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        await webStorageManager.deleteAllData();
      } else if (Platform.isIOS || Platform.isMacOS) {
        final records = await webStorageManager.fetchDataRecords(
            dataTypes: WebsiteDataType.values);
        final recordsToDelete = <WebsiteDataRecord>[];
        for (var record in records) {
          if (record.displayName == 'flutter.dev') {
            recordsToDelete.add(record);
          }
        }
        await webStorageManager.removeDataFor(
            dataTypes: WebsiteDataType.values, dataRecords: recordsToDelete);
      }
    }
  }
}
