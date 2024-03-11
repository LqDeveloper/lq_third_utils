import 'sp_mixin.dart';

/// SharedPreferences管理工具类
class SPUtils with SPMixin {
  static final SPUtils instance = SPUtils._();

  factory SPUtils() => instance;

  SPUtils._();

  /// 使用之前必须先调用这个方法初始化
  static Future initDefaultSP() => instance.initSP();
}
