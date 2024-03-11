import 'package:hive/hive.dart';

/// Hive管理Mixin
mixin HiveMixin<E> implements Box<E> {
  late Box<E> _box;

  /// 使用之前必须先调用这个方法初始化
  Future initBox(String? tag) async {
    String name = runtimeType.toString();
    if (tag != null) {
      name += '_$tag';
    }
    _box = await Hive.openBox<E>(name);
  }

  /// box中的所有值。这些值与其键的顺序相同。
  @override
  Iterable<E> get values => _box.values;

  /// 返回一个可迭代对象，其中包含从与 [startKey]（含）
  /// 关联的值到与 [endKey]（含）关联的值的所有值。
  /// 如果 [startKey] 不存在，则返回一个空的可迭代对象。
  /// 如果 [endKey] 不存在或位于 [startKey] 之前，则忽略它。这些值与其键的顺序相同。
  @override
  Iterable<E> valuesBetween({dynamic startKey, dynamic endKey}) =>
      _box.valuesBetween(startKey: startKey, endKey: endKey);

  /// 返回与给定 [键] 关联的值。如果该键不存在，则返回“null”。
  /// 如果指定了 [defaultValue]，则在键不存在的情况下返回该值。
  @override
  E? get(dynamic key, {E? defaultValue}) =>
      _box.get(key, defaultValue: defaultValue);

  /// 返回与第 n 个键关联的值。
  @override
  E? getAt(int index) => _box.getAt(index);

  /// 返回一个映射，其中包含框的所有键值对。
  @override
  Map<dynamic, E> toMap() => _box.toMap();

  /// box的名称。名称始终为小写。
  @override
  String get name => _box.name;

  /// 此box当前是否打开。对box的大多数操作都需要打开它。
  @override
  bool get isOpen => _box.isOpen;

  /// 框在文件系统中的位置。在浏览器中，这是空的。
  @override
  String? get path => _box.path;

  /// 这个盒子是否懒惰。这相当于“盒子是懒惰的盒子”。
  @override
  bool get lazy => _box.lazy;

  /// box里的所有key。key按字母升序排序。
  @override
  Iterable<dynamic> get keys => _box.keys;

  /// Box中的条目数。
  @override
  int get length => _box.length;

  /// 如果此box中没有条目，则返回“true”。
  @override
  bool get isEmpty => _box.isEmpty;

  /// 如果此box中至少有一个条目，则返回 true。
  @override
  bool get isNotEmpty => _box.isEmpty;

  /// 获取box中的第 n 个key。
  @override
  dynamic keyAt(int index) => _box.keyAt(index);

  /// 返回更改事件的广播流。如果提供了 [key] 参数，则仅广播指定键的事件。
  @override
  Stream<BoxEvent> watch({dynamic key}) => _box.watch(key: key);

  /// 检查box是否包含 [键]。
  @override
  bool containsKey(dynamic key) => _box.containsKey(key);

  /// 保存 [键] - [值] 对。
  @override
  Future<void> put(dynamic key, E value) => _box.put(key, value);

  /// 将 [值] 与第 n 个键相关联。如果密钥不存在，则会引发异常。
  @override
  Future<void> putAt(int index, E value) => _box.putAt(index, value);

  /// 将所有键值对保存在 [条目] 映射中。
  @override
  Future<void> putAll(Map<dynamic, E> entries) => _box.putAll(entries);

  /// 使用自动增量键保存 [值]。
  @override
  Future<int> add(E value) => _box.add(value);

  /// 使用自动增量键保存所有 [值]。
  @override
  Future<Iterable<int>> addAll(Iterable<E> values) => _box.addAll(values);

  /// 从box中删除给定的 [键]。如果它不存在，则什么都不会发生。
  @override
  Future<void> delete(dynamic key) => _box.delete(key);

  /// 从框中删除第 n 个键。如果它不存在，则什么都不会发生
  @override
  Future<void> deleteAt(int index) => _box.deleteAt(index);

  /// 从框中删除所有给定的 [键]。如果某个键不存在，则跳过该键。
  @override
  Future<void> deleteAll(Iterable<dynamic> keys) => _box.deleteAll(keys);

  /// 手动压缩。这个很少使用。您应该考虑改为提供自定义压缩策略。
  @override
  Future<void> compact() => _box.compact();

  /// 从框中删除所有条目。
  @override
  Future<int> clear() => _box.clear();

  /// 关闭box。请注意，这将关闭此box的所有实例。您必须确保在此之后不会在其他任何地方访问该box。
  @override
  Future<void> close() => _box.close();

  /// 删除包含该box的文件并关闭该box。在浏览器中，正在删除索引数据库数据库。
  @override
  Future<void> deleteFromDisk() => _box.deleteFromDisk();

  /// 将box的所有挂起更改刷新到磁盘。
  @override
  Future<void> flush() => _box.flush();
}
