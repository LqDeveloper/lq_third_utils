import 'package:hive_flutter/hive_flutter.dart';

import './storage/hive_utils.dart';
import './storage/key_chain_utils.dart';
import './storage/sp_utils.dart';
import './utils/app_path.dart';
import './utils/device_utils.dart';
import './utils/package_utils.dart';

/// 工具类统一初始化
class UtilsInit {
  UtilsInit._();

  /// 需要在main方法中调用
  static Future allReady({String? subDir}) {
    KeychainUtils.instance.initKeychain();
    return Future.wait([
      AppPath.initPath(),
      DeviceUtils.initDeviceInfo(),
      PackageUtils.initPackageInfo(),
      SPUtils.initDefaultSP(),
      Hive.initFlutter(subDir).then((value) => HiveUtils.initDefaultBox()),
    ]);
  }
}
