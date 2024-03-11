import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebCookie extends Cookie {
  WebCookie({
    required super.name,
    required super.value,
    super.expiresDate,
    super.isSessionOnly,
    super.domain,
    super.sameSite,
    super.isSecure,
    super.isHttpOnly,
    super.path,
  });
}
