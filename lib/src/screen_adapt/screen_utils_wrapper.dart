import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'base_wrapper.dart';

class ScreenUtilsWrapper extends BaseWrapper {
  ///支持分屏
  final bool splitScreenMode;

  ///	是否按照宽度和高度的最小值来适配文本
  final bool minTextAdapt;

  final bool? ensureScreenSize;

  /// 设计稿中设备屏幕的尺寸，单位为dp
  final Size designSize;

  const ScreenUtilsWrapper({
    super.key,
    this.designSize = ScreenUtil.defaultSize,
    this.splitScreenMode = false,
    this.minTextAdapt = false,
    this.ensureScreenSize,
  });

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return ScreenUtilInit(
      designSize: designSize,
      splitScreenMode: splitScreenMode,
      minTextAdapt: minTextAdapt,
      ensureScreenSize: ensureScreenSize,
      child: child,
    );
  }
}
