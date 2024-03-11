import 'hive_mixin.dart';

/// Hive管理工具类
class HiveUtils with HiveMixin {
  static final HiveUtils instance = HiveUtils._();

  factory HiveUtils() => instance;

  HiveUtils._();

  /// 使用之前必须先调用这个方法初始化
  static Future initDefaultBox() => instance.initBox('default');
}
