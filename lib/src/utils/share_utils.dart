import 'package:flutter/material.dart';

import 'package:meta/meta.dart';
import 'package:share_plus/share_plus.dart';

///分享工具
class ShareUtils {
  ShareUtils._();

  ///分享链接
  static Future<void> shareUri(Uri uri) {
    return Share.shareUri(uri);
  }

  ///分享链接
  static Future<void> shareUriStr(String? uriStr) async {
    if (uriStr == null || uriStr.isEmpty) {
      return;
    }
    final uri = Uri.tryParse(uriStr);
    if (uri == null) {
      return;
    }
    return shareUri(uri);
  }

  ///分享文本
  ///text:要分享的文本
  ///subject：如果用户选择发送电子邮件，可选的 [subject] 参数可用于填充主题。
  ///sharePositionOrigin:可选的 [sharePositionOrigin] 参数可用于指定共享表的全局原点矩形，以便在 iPad 和 Mac 上弹出。对其他设备没有影响。
  static Future<void> share(
    String text, {
    String? subject,
    Rect? sharePositionOrigin,
  }) {
    return Share.share(
      text,
      subject: subject,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  ///分享文本返回分享文本
  ///text:要分享的文本
  ///subject：如果用户选择发送电子邮件，可选的 [subject] 参数可用于填充主题。
  ///sharePositionOrigin:可选的 [sharePositionOrigin] 参数可用于指定共享表的全局原点矩形，以便在 iPad 和 Mac 上弹出。对其他设备没有影响。
  static Future<ShareActionResult> shareWithResult(
    String text, {
    String? subject,
    Rect? sharePositionOrigin,
  }) async {
    final result = await Share.shareWithResult(
      text,
      subject: subject,
      sharePositionOrigin: sharePositionOrigin,
    );
    return ShareActionResult(
        result.raw, ShareActionStatus.fromStatus(result.status));
  }

  ///分享文件
  static Future<ShareActionResult> shareXFiles(
    List<XFile> files, {
    String? subject,
    String? text,
    Rect? sharePositionOrigin,
  }) async {
    final result = await Share.shareXFiles(
      files,
      subject: subject,
      text: text,
      sharePositionOrigin: sharePositionOrigin,
    );
    return ShareActionResult(
        result.raw, ShareActionStatus.fromStatus(result.status));
  }

  ///分享文件
  static Future<ShareActionResult> shareXFilesWithPath(
    List<String> filePaths, {
    String? subject,
    String? text,
    Rect? sharePositionOrigin,
  }) async {
    final result = await Share.shareXFiles(
      filePaths.map((e) => XFile(e)).toList(),
      subject: subject,
      text: text,
      sharePositionOrigin: sharePositionOrigin,
    );

    return ShareActionResult(
        result.raw, ShareActionStatus.fromStatus(result.status));
  }
}

class ShareActionResult {
  final String raw;

  final ShareActionStatus status;

  const ShareActionResult(this.raw, this.status);
}

enum ShareActionStatus {
  success,
  dismissed,
  unavailable;

  bool get isSuccess => this == ShareActionStatus.success;

  bool get isUnavailable => this == ShareActionStatus.unavailable;

  @internal
  static ShareActionStatus fromStatus(ShareResultStatus status) {
    switch (status) {
      case ShareResultStatus.success:
        return ShareActionStatus.success;
      case ShareResultStatus.dismissed:
        return ShareActionStatus.dismissed;
      case ShareResultStatus.unavailable:
        return ShareActionStatus.unavailable;
    }
  }
}
