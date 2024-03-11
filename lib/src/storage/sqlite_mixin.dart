import 'dart:async';

import 'package:sqflite/sqflite.dart';

mixin SqliteMixin {
  Database? _database;

  /// 数据初始化
  /// dbName:数据库名称
  /// version：数据库版本
  /// path：数据库存储路径，默认路径如下：
  ///        Androidm默认路径：data/data/<package_name>/databases
  ///        iOS默认路径： Documents
  /// onCreate：当数据库创建完成时回调（只会调用一次），一般用于创建表
  /// onUpgrade：当数据库升级回调，用于数据迁移
  /// onDowngrade：当数据降级回调，用于数据迁移
  Future<void> initDB({
    required String dbName,
    required int version,
    String? path,
    FutureOr<void> Function(int version)? onCreate,
    FutureOr<void> Function(int oldVersion, int newVersion)? onUpgrade,
    FutureOr<void> Function(int oldVersion, int newVersion)? onDowngrade,
  }) async {
    if (dbName.isEmpty) {
      return;
    }
    String fullPath = '';
    if (path == null || path.isEmpty) {
      final defPath = await getDatabasesPath();
      fullPath = '$defPath/$dbName.db';
    } else {
      fullPath = '$path/$dbName.db';
    }
    _database = await openDatabase(fullPath, version: version,
        onCreate: (db, int version) {
      _database = db;
      onCreate?.call(version);
    }, onUpgrade: (db, int oldVersion, int newVersion) {
      _database = db;
      onUpgrade?.call(oldVersion, newVersion);
    }, onDowngrade: (db, int oldVersion, int newVersion) {
      _database = db;
      onDowngrade?.call(oldVersion, newVersion);
    });
  }

  ///判断表是否存在
  Future<bool> tableExists(String? tableName) async {
    if (tableName == null || tableName.isEmpty) {
      return false;
    }
    final res = await _database?.rawQuery(
      "SELECT * FROM sqlite_master WHERE TYPE = 'table' AND NAME = '$tableName'",
    );
    return res == null || res.isNotEmpty;
  }

  ///执行没有返回值的sql语句
  ///示例：
  /// await _database.execute('CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)');
  Future<void> execute(
    String sql, [
    List<Object?>? arguments,
  ]) async {
    await _database?.execute(sql, arguments);
  }

  /// 执行sql语句插入操作，返回row的ID
  /// 示例：
  /// int id1 = await _database.rawInsert('INSERT INTO Test(name, value, num) VALUES("some name", 1234, 456.789)');
  Future<int> rawInsert(
    String sql, [
    List<Object?>? arguments,
  ]) async {
    final result = await _database?.rawInsert(sql, arguments);
    return result ?? -1;
  }

  ///以Map作为参数执行插入操作，返回row的ID
  ///示例：
  /// ```
  ///    var value = {
  ///      'age': 18,
  ///      'name': 'value'
  ///    };
  ///    int id = await db.insert(
  ///      'table',
  ///      value,
  ///      conflictAlgorithm: ConflictAlgorithm.replace,
  ///    );
  /// ```
  Future<int> insert(
    String table,
    Map<String, Object?> values, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    final result = await _database?.insert(table, values,
        nullColumnHack: nullColumnHack, conflictAlgorithm: conflictAlgorithm);
    return result ?? -1;
  }

  ///执行查询操作
  ///
  /// [table] 查询的表名
  ///
  /// [distinct]  设置为true时，会确保每一列是唯一的 when set to true ensures each row is unique.
  ///
  /// The [columns] 需要返回的列的，如果传null则返回所有的列
  ///
  /// [where] 筛选语句 where column = ?
  ///
  /// [whereArgs] 对应上面 where中的 ？ 的值，顺序要和上面？的顺序一致
  ///
  /// [groupBy] 声明如何对行进行分组。传递 null 将导致行不被分组。
  ///
  /// [having] 如果使用行分组，则声明将哪些行组包含在光标中。通过NULL将导致所有行组都包括在内，在不使用行分组时需要。
  ///
  /// [orderBy] 声明如何排序，通过null将使用默认排序顺序，该顺序可能是无序的。
  ///
  /// [limit] 限制查询返回的行数。
  ///
  /// [offset] 指定开始位置
  ///
  /// 示例：
  /// ```
  ///  List<Map> maps = await db.query(tableTodo,
  ///      columns: ['columnId', 'columnDone', 'columnTitle'],
  ///      where: 'columnId = ?',
  ///      whereArgs: [id]);
  /// ```
  Future<List<Map<String, Object?>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final result = await _database?.query(table,
        distinct: distinct,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset);
    return result ?? [];
  }

  /// 执行Sql语句查询
  /// 示例
  /// ```
  /// List<Map> list = await database.rawQuery('SELECT * FROM Test');
  /// ```
  Future<List<Map<String, Object?>>> rawQuery(String sql,
      [List<Object?>? arguments]) async {
    final result = await _database?.rawQuery(sql, arguments);
    return result ?? [];
  }

  /// 执行sql更新，返回所做的更改数。
  /// 示例
  /// ```
  /// int count = await database.rawUpdate(
  ///   'UPDATE Test SET name = ?, value = ? WHERE name = ?',
  ///   ['updated name', '9876', 'some name']);
  /// ```
  Future<int> rawUpdate(String sql, [List<Object?>? arguments]) async {
    final result = await _database?.rawUpdate(sql, arguments);
    return result ?? -1;
  }

  /// 更加方便的更新数据，返回所做的更改数。
  ///
  /// table: 表名
  ///
  /// [where] 筛选语句 where column = ?
  ///
  /// [whereArgs] 对应上面 where中的 ？ 的值，顺序要和上面？的顺序一致
  ///
  /// [conflictAlgorithm] 指定在发生冲突的情况下使用的算法。
  ///
  /// 示例
  /// ```
  /// int count = await db.update(tableTodo, todo.toMap(),
  ///    where: '$columnId = ?', whereArgs: [todo.id]);
  /// ```
  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  }) async {
    final result = await _database?.update(table, values,
        where: where,
        whereArgs: whereArgs,
        conflictAlgorithm: conflictAlgorithm);
    return result ?? -1;
  }

  /// 执行sql语句删除
  ///
  /// 示例
  /// ```
  /// int count = await database
  ///   .rawDelete('DELETE FROM Test WHERE name = ?', ['another name']);
  /// ```
  Future<int> rawDelete(String sql, [List<Object?>? arguments]) async {
    final result = await _database?.rawDelete(sql, arguments);
    return result ?? -1;
  }

  /// 更加方便的删除
  ///
  /// table: 表名
  ///
  /// [where] 筛选语句 where column = ?
  ///
  /// [whereArgs] 对应上面 where中的 ？ 的值，顺序要和上面？的顺序一致
  ///
  /// 返回影响的行数
  /// ```
  ///  int count = await db.delete(tableTodo, where: 'columnId = ?', whereArgs: [id]);
  /// ```
  Future<int> delete(String table,
      {String? where, List<Object?>? whereArgs}) async {
    final result =
        await _database?.delete(table, where: where, whereArgs: whereArgs);
    return result ?? -1;
  }
}
