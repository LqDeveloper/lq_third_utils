import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'web_view_manager.dart';

/// [InAppWebView文档](https://inappwebview.dev/docs/intro)
/// InAppWebView的通用封装
class AppWebView extends StatelessWidget {
  ///加载的Url
  final String? urlStr;

  ///加载的文件路径
  final String? filePath;

  ///加载Html字符串
  final String? html;

  ///针对html字符串
  final String? baseUrl;

  ///是否允许垂直方向的滚动
  final bool enableVerticalScroll;

  ///是否允许显示垂直滚动条
  final bool verticalScrollBarEnabled;

  ///是否可以横向滚动
  final bool enableHorizontalScroll;

  ///是否显示横向滚动条
  final bool horizontalScrollBarEnabled;

  ///是否支持放大缩小
  final bool supportZoom;

  final bool? loadWithOverviewMode;

  final int? initialScale;

  final bool? useWideViewPort;

  ///设置 WebView 是否应使用浏览器缓存。默认值为true。
  final bool cacheEnabled;

  ///用于保持此 WebView 的活动。
  final InAppWebViewKeepAlive? keepAlive;

  ///WebView设置
  final InAppWebViewSettings? initialSettings;

  ///初始化脚本
  final UnmodifiableListView<UserScript>? initialUserScripts;

  ///下拉刷新控制器
  final PullToRefreshController? pullToRefreshController;

  ///当title发生改变
  final void Function(InAppWebViewController controller, String? title)?
      onTitleChanged;

  ///指定处理手势
  final Set<Factory<OneSequenceGestureRecognizer>>? gestureRecognizers;

  ///WebView创建
  final void Function(InAppWebViewController? controller)? onWebViewCreated;

  ///Window创建
  final Future<bool?> Function(InAppWebViewController controller,
      CreateWindowAction createWindowAction)? onCreateWindow;

  ///Window关闭
  final void Function(InAppWebViewController controller)? onCloseWindow;

  ///加载完成资源
  final void Function(
          InAppWebViewController controller, LoadedResource resource)?
      onLoadResource;

  ///跳转拦截
  final Future<NavigationActionPolicy?> Function(
      InAppWebViewController? controller,
      NavigationAction navigationAction)? shouldOverrideUrlLoading;

  ///开始加载
  final void Function(InAppWebViewController? controller, Uri? url)?
      onLoadStart;

  ///停止加载
  final void Function(InAppWebViewController? controller, Uri? url)? onLoadStop;

  ///加载错误
  final void Function(InAppWebViewController controller,
      WebResourceRequest request, WebResourceError error)? onReceivedError;

  final void Function(
      InAppWebViewController controller,
      WebResourceRequest request,
      WebResourceResponse errorResponse)? onReceivedHttpError;

  ///JS Console打印
  final void Function(
          InAppWebViewController controller, ConsoleMessage consoleMessage)?
      onConsoleMessage;

  ///加载进度
  final void Function(InAppWebViewController? controller, int progress)?
      onProgressChanged;

  ///滚动监听
  final void Function(InAppWebViewController? controller, int x, int y)?
      onScrollChanged;

  final Future<bool?> Function(InAppWebViewController controller, WebUri? url,
      PlatformPrintJobController? printJobController)? onPrintRequest;

  final Future<ClientCertResponse?> Function(InAppWebViewController controller,
      URLAuthenticationChallenge challenge)? onReceivedClientCertRequest;

  final Future<HttpAuthResponse?> Function(InAppWebViewController controller,
      URLAuthenticationChallenge challenge)? onReceivedHttpAuthRequest;

  final Future<ServerTrustAuthResponse?> Function(
      InAppWebViewController controller,
      URLAuthenticationChallenge challenge)? onReceivedServerTrustAuthRequest;

  const AppWebView.url({
    super.key,
    required this.urlStr,
    this.enableVerticalScroll = true,
    this.verticalScrollBarEnabled = true,
    this.enableHorizontalScroll = true,
    this.horizontalScrollBarEnabled = true,
    this.supportZoom = false,
    this.initialScale = 0,
    this.loadWithOverviewMode,
    this.useWideViewPort,
    this.cacheEnabled = true,
    this.keepAlive,
    this.initialSettings,
    this.initialUserScripts,
    this.pullToRefreshController,
    this.onTitleChanged,
    this.onCreateWindow,
    this.onCloseWindow,
    this.onLoadResource,
    this.gestureRecognizers,
    this.onWebViewCreated,
    this.shouldOverrideUrlLoading,
    this.onLoadStart,
    this.onLoadStop,
    this.onReceivedError,
    this.onReceivedHttpError,
    this.onConsoleMessage,
    this.onProgressChanged,
    this.onScrollChanged,
    this.onPrintRequest,
    this.onReceivedClientCertRequest,
    this.onReceivedHttpAuthRequest,
    this.onReceivedServerTrustAuthRequest,
  })  : filePath = null,
        html = null,
        baseUrl = null;

  const AppWebView.file({
    super.key,
    required this.filePath,
    this.enableVerticalScroll = true,
    this.verticalScrollBarEnabled = true,
    this.enableHorizontalScroll = true,
    this.horizontalScrollBarEnabled = true,
    this.loadWithOverviewMode,
    this.supportZoom = false,
    this.initialScale = 0,
    this.useWideViewPort,
    this.cacheEnabled = true,
    this.keepAlive,
    this.initialSettings,
    this.initialUserScripts,
    this.pullToRefreshController,
    this.onTitleChanged,
    this.onCreateWindow,
    this.onCloseWindow,
    this.onLoadResource,
    this.gestureRecognizers,
    this.onWebViewCreated,
    this.shouldOverrideUrlLoading,
    this.onLoadStart,
    this.onLoadStop,
    this.onReceivedError,
    this.onReceivedHttpError,
    this.onConsoleMessage,
    this.onProgressChanged,
    this.onScrollChanged,
    this.onPrintRequest,
    this.onReceivedClientCertRequest,
    this.onReceivedHttpAuthRequest,
    this.onReceivedServerTrustAuthRequest,
  })  : urlStr = null,
        html = null,
        baseUrl = null;

  const AppWebView.html({
    super.key,
    required this.html,
    this.baseUrl,
    this.enableVerticalScroll = true,
    this.verticalScrollBarEnabled = true,
    this.enableHorizontalScroll = true,
    this.horizontalScrollBarEnabled = true,
    this.loadWithOverviewMode,
    this.supportZoom = false,
    this.initialScale = 0,
    this.useWideViewPort,
    this.cacheEnabled = true,
    this.keepAlive,
    this.initialSettings,
    this.initialUserScripts,
    this.pullToRefreshController,
    this.onTitleChanged,
    this.onCreateWindow,
    this.onCloseWindow,
    this.onLoadResource,
    this.gestureRecognizers,
    this.onWebViewCreated,
    this.shouldOverrideUrlLoading,
    this.onLoadStart,
    this.onLoadStop,
    this.onReceivedError,
    this.onReceivedHttpError,
    this.onConsoleMessage,
    this.onProgressChanged,
    this.onScrollChanged,
    this.onPrintRequest,
    this.onReceivedClientCertRequest,
    this.onReceivedHttpAuthRequest,
    this.onReceivedServerTrustAuthRequest,
  })  : urlStr = null,
        filePath = null;

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
        //加载url
        initialUrlRequest:
            urlStr == null ? null : URLRequest(url: WebUri(urlStr!)),
        //加载文件
        initialFile: filePath,
        //加载html字符串
        initialData: html == null
            ? null
            : InAppWebViewInitialData(
                data: html!, baseUrl: WebUri(baseUrl ?? 'about:blank')),
        keepAlive: keepAlive,
        initialSettings: _getSetting(),
        initialUserScripts: initialUserScripts,
        onWebViewCreated: onWebViewCreated,
        pullToRefreshController: pullToRefreshController,
        onTitleChanged: onTitleChanged,
        onCreateWindow: onCreateWindow,
        onCloseWindow: onCloseWindow,
        onLoadResource: onLoadResource,
        gestureRecognizers: gestureRecognizers,
        shouldOverrideUrlLoading: shouldOverrideUrlLoading,
        onLoadStart: onLoadStart,
        onLoadStop: onLoadStop,
        onReceivedError: onReceivedError,
        onReceivedHttpError: onReceivedHttpError,
        onConsoleMessage: onConsoleMessage,
        onProgressChanged: onProgressChanged,
        onScrollChanged: onScrollChanged,
        onPrintRequest: onPrintRequest,
        onReceivedClientCertRequest: onReceivedClientCertRequest,
        onReceivedHttpAuthRequest: onReceivedHttpAuthRequest,
        onReceivedServerTrustAuthRequest: onReceivedServerTrustAuthRequest);
  }

  InAppWebViewSettings _getSetting() {
    final settings =
        initialSettings ?? WebViewManager.instance.globalSetting.copy();
    settings.disableVerticalScroll = !enableVerticalScroll;
    settings.initialScale = initialScale;
    settings.useWideViewPort = useWideViewPort;
    settings.loadWithOverviewMode = loadWithOverviewMode;
    settings.verticalScrollBarEnabled = verticalScrollBarEnabled;
    settings.disableHorizontalScroll = !enableHorizontalScroll;
    settings.horizontalScrollBarEnabled = horizontalScrollBarEnabled;
    settings.supportZoom = supportZoom;
    settings.cacheEnabled = cacheEnabled;
    return settings;
  }
}
