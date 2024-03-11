import 'app_info_mixin.dart';

class AppInfoUtils with AppInfoMixin {
  static final AppInfoUtils instance = AppInfoUtils._();

  factory AppInfoUtils() => instance;

  AppInfoUtils._();
}
