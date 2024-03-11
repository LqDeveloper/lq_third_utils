import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// App文件管理工具类
abstract class FileUtils {
  /// 获取一个临时目录(缓存)，系统可以随时清除。
  static Future<String?> getTempDir() async {
    try {
      final Directory tempDir = await getTemporaryDirectory();
      return tempDir.path;
    } on Exception catch (_) {
      return null;
    }
  }

  /// 获取应用程序的目录，用于存储只有它可以访问的文件。只有当应用程序被删除时，系统才会清除目录。
  static Future<String?> getAppDocDir() async {
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      return appDocDir.path;
    } on Exception catch (_) {
      return null;
    }
  }

  ///获取存在文件中的数据
  ///使用async、await，返回是一个Future对象
  static Future<String?> readStringDir(String? filePath) async {
    if (filePath == null || filePath.isEmpty) {
      return null;
    }
    try {
      final file = File(filePath);
      if (file.existsSync()) {
        return await file.readAsString();
      }
      return null;
    } on Exception catch (_) {
      return null;
    }
  }

  /// 写入json文件
  static Future<File?> writeJsonToFile(Object? obj, String? filePath) async {
    if (obj == null || filePath == null || filePath.isEmpty) {
      return null;
    }
    try {
      final file = File(filePath);
      if (file.existsSync()) {
        return await file.writeAsString(json.encode(obj));
      } else {
        file.createSync(recursive: true);
        return await file.writeAsString(json.encode(obj));
      }
    } on Exception catch (_) {
      return null;
    }
  }

  ///创建文件
  static Future<bool> createFile(String? filePath) async {
    if (filePath == null) {
      return false;
    }
    try {
      final file = File(filePath);
      if (!file.existsSync()) {
        file.createSync(recursive: true);
      }
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  ///删除文件
  static Future<bool> deleteFile(String? filePath) async {
    if (filePath == null) {
      return false;
    }
    try {
      final file = File(filePath);
      if (file.existsSync()) {
        await file.delete();
      }
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  ///删除某个文件夹
  static Future<void> deleteDir(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await deleteDir(child);
        await child.delete();
      }
    }
  }

  /// getTemporaryDirectory
  /// 指向设备上临时目录的路径，该目录没有备份，适合存储下载文件的缓存。
  /// 此目录中的文件可以随时清除。这不会返回一个新的临时目录。
  /// 相反，调用者负责在这个目录中创建(和清理)文件或目录。这个目录的作用域是调用应用程序。
  /// 在iOS上，它使用“NSCachesDirectory”API。
  /// 在Android上，它在上下文中使用“getCacheDir”API。
  static Future<Directory?> _initTempDir() async {
    try {
      return await getTemporaryDirectory();
    } on Exception catch (_) {
      return null;
    }
  }

  /// getApplicationSupportDirectory  支持iOS
  /// Flutter引擎在Android上的“PathUtils.getFilesDir”API。
  /// 应用程序可以放置应用程序支持文件的目录的路径。
  /// 对不希望向用户公开的文件使用此选项。您的应用程序不应将此目录用于用户数据文件。
  /// 在iOS上，它使用“NSApplicationSupportDirectory”API。如果此目录不存在，则自动创建。
  /// 在Android上，此函数抛出一个[UnsupportedError]。
  static Future<Directory?> _initSupportDir() async {
    //应用程序支持文件的目录的路径
    try {
      return await getApplicationSupportDirectory();
    } on Exception catch (_) {
      return null;
    }
  }

  /// getApplicationDocumentsDirectory 支持iOS和Android
  /// 获取应用程序的目录，用于存储只有它可以访问的文件。只有当应用程序被删除时，系统才会清除目录。
  /// 在iOS上，它使用“NSDocumentDirectory”API。如果数据不是用户生成的，请考虑使用[GetApplicationSupportDirectory]。
  /// 在Android上，这在上下文中使用了“getDataDirectory”API。如果数据对用户可见，请考虑改用getExternalStorageDirectory。
  static Future<Directory?> _initAppDocDir() async {
    //获取应用程序的目录，用于存储只有它可以访问的文件。只有当应用程序被删除时，系统才会清除目录。
    try {
      return await getApplicationDocumentsDirectory();
    } on Exception catch (_) {
      return null;
    }
  }

  /// getExternalStorageDirectory 支持Android 不支持iOS
  /// 应用程序可以访问顶层存储的目录的路径。在发出这个函数调用之前，应该确定当前操作系统，因为这个功能只在Android上可用。
  /// 在iOS上，这个函数抛出一个[UnsupportedError]，因为它不可能访问应用程序的沙箱之外。
  /// 在Android上，它使用“getExternalStorageDirectory”API。
  static Future<Directory?> _initStorageDir() async {
    //应用程序可以访问顶层存储的目录的路径。
    try {
      return await getExternalStorageDirectory();
    } on Exception catch (_) {
      return null;
    }
  }

  /// 同步创建文件夹
  static Directory? createDir(String? path) {
    if (path == null || path.isEmpty) {
      return null;
    }
    final Directory dir = Directory(path);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return dir;
  }

  /// 异步创建文件夹
  static Future<Directory?> createDirSync(String? path) async {
    if (path == null || path.isEmpty) {
      return null;
    }
    Directory dir = Directory(path);
    final bool exist = await dir.exists();
    if (!exist) {
      dir = await dir.create(recursive: true);
    }
    return dir;
  }

  /// 获取设备上临时目录的路径，该目录没有备份，适合存储下载文件的缓存。
  /// fileName 文件名
  /// dirName 文件夹名
  static Future<String> getTempPath({
    String? fileName,
    String? dirName,
  }) async {
    final Directory? tempDir = await _initTempDir();
    if (tempDir == null) {
      return "";
    }
    final StringBuffer sb = StringBuffer(tempDir.path);
    if (dirName != null && dirName.isNotEmpty) {
      sb.write("/$dirName");
      await createDirSync(sb.toString());
    }
    if (fileName != null && fileName.isNotEmpty) {
      sb.write("/$fileName");
    }
    return sb.toString();
  }

  /// 获取应用程序的目录，用于存储只有它可以访问的文件。只有当应用程序被删除时，系统才会清除目录。
  /// fileName 文件名
  /// dirName 文件夹名
  static Future<String> getAppDocPath({
    String? fileName,
    String? dirName,
  }) async {
    final Directory? appDocDir = await _initAppDocDir();
    if (appDocDir == null) {
      return "";
    }
    final StringBuffer sb = StringBuffer(appDocDir.path);
    if (dirName != null && dirName.isNotEmpty) {
      sb.write("/$dirName");
      await createDirSync(sb.toString());
    }
    if (fileName != null && fileName.isNotEmpty) {
      sb.write("/$fileName");
    }
    return sb.toString();
  }

  /// 应用程序可以访问顶层存储的目录的路径 支持Android 不支持iOS
  /// fileName 文件名
  /// dirName 文件夹名
  static Future<String> getStoragePath({
    String? fileName,
    String? dirName,
  }) async {
    final Directory? storageDir = await _initStorageDir();
    if (storageDir == null) {
      return "";
    }
    final StringBuffer sb = StringBuffer(storageDir.path);
    if (dirName != null && dirName.isNotEmpty) {
      sb.write("/$dirName");
      await createDirSync(sb.toString());
    }
    if (fileName != null && fileName.isNotEmpty) {
      sb.write("/$fileName");
    }
    return sb.toString();
  }

  /// 在临时目录下创建文件夹
  /// 在iOS上，它使用“NSCachesDirectory”API。
  /// 在Android上，它在上下文中使用“getCacheDir”API。
  static Future<Directory?> createTempDir(String? dirName) async {
    if (dirName == null || dirName.isEmpty) {
      return null;
    }
    final Directory? tempDir = await _initTempDir();
    if (tempDir == null) {
      return null;
    }
    return await createDirSync("${tempDir.path}/$dirName");
  }

  /// 在iOS Document文件加下，Android的Data的文件夹下创建文件夹
  /// 在iOS上，它使用“NSDocumentDirectory”API。如果数据不是用户生成的，请考虑使用[GetApplicationSupportDirectory]。
  /// 在Android上，这在上下文中使用了“getDataDirectory”API
  static Future<Directory?> createAppDocDir(String? dirName) async {
    if (dirName == null || dirName.isEmpty) {
      return null;
    }
    final Directory? appDocDir = await _initAppDocDir();
    if (appDocDir == null) {
      return null;
    }
    return await createDirSync("${appDocDir.path}/$dirName");
  }

  ///在Android getExternalStorageDirectory 的路径下创建文件夹  dirName 文件夹名 支持Android 不支持iOS
  static Future<Directory?> createStorageDir(String? dirName) async {
    if (dirName == null || dirName.isEmpty) {
      return null;
    }
    final Directory? storageDir = await _initStorageDir();
    if (storageDir == null) {
      return null;
    }
    return await createDirSync("${storageDir.path}/$dirName");
  }

  ///在iOS NSApplicationSupportDirectory 的路径下创建文件夹  dirName 文件夹名 支持iOSAndroid
  static Future<Directory?> createSupportDir(String? dirName) async {
    if (dirName == null || dirName.isEmpty) {
      return null;
    }
    final Directory? supportDir = await _initSupportDir();
    if (supportDir == null) {
      return null;
    }
    return await createDirSync("${supportDir.path}/$dirName");
  }

  ///获取Cache文件下文件大小 getTemporaryDirectory 获取应用缓存目录，
  ///等同IOS的NSCachesDirectory和Android的getCacheDir方法
  static Future<double> loadCacheDirSize() async {
    final Directory tempDirectory = await getTemporaryDirectory();
    double size = 0;
    if (tempDirectory.existsSync()) {
      size += await getTotalSizeOfFilesInDir(tempDirectory);
    }
    return size;
  }

  ///清空缓存文件夹
  static Future<void> clearCacheDir() async {
    final Directory tempDirectory = await getTemporaryDirectory();
    if (tempDirectory.existsSync()) {
      await deleteDir(tempDirectory);
    }
  }

  ///获取指定文件夹下文件的大小
  static Future<double> getTotalSizeOfFilesInDir(
    final FileSystemEntity file,
  ) async {
    if (file is File) {
      final int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      double total = 0;
      for (final FileSystemEntity child in children) {
        total += await getTotalSizeOfFilesInDir(child);
      }
      return total;
    }
    return 0;
  }

  ///将文件大小格式化为 'B', 'KB', 'MB', 'GB'
  static String formatSize(num value) {
    if (value == 0) {
      return '0';
    }
    final List<String> unitArr = ['B', 'KB', 'MB', 'GB'];
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    final String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }
}
