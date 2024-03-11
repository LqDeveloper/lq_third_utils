import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart' hide SizeExtension;

extension NumExtension on num {
  ///宽度
  double get w => ScreenUtil().setWidth(this);

  ///高度
  double get h => ScreenUtil().setHeight(this);

  ///字体
  double get sp => ScreenUtil().setSp(this);

  ///屏幕宽度的倍数
  double get sw => ScreenUtil().screenWidth * this;

  ///屏幕高度的倍数
  double get sh => ScreenUtil().screenHeight * this;
}

extension InsetsExtension on EdgeInsets {
  EdgeInsets get w => copyWith(
        top: top.w,
        bottom: bottom.w,
        right: right.w,
        left: left.w,
      );

  EdgeInsets get h => copyWith(
        top: top.h,
        bottom: bottom.h,
        right: right.h,
        left: left.h,
      );
}

extension RaduisExtension on BorderRadius {
  BorderRadius get w => copyWith(
        bottomLeft: bottomLeft.w,
        bottomRight: bottomRight.w,
        topLeft: topLeft.w,
        topRight: topRight.w,
      );

  BorderRadius get h => copyWith(
        bottomLeft: bottomLeft.h,
        bottomRight: bottomRight.h,
        topLeft: topLeft.h,
        topRight: topRight.h,
      );
}
