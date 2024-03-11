import 'sqlite_mixin.dart';

/// Sqlite管理工具类
class SqliteUtils with SqliteMixin {
  static final SqliteUtils instance = SqliteUtils._();

  factory SqliteUtils() => instance;

  SqliteUtils._();
}
