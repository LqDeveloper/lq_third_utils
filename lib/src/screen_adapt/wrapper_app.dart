import 'package:flutter/material.dart';

import 'package:nested/nested.dart';

import 'base_wrapper.dart';

/// 统一使用这个类去管理第三方Widget包裹根节点
class WrapperApp extends StatelessWidget {
  final List<BaseWrapper> children;
  final Widget child;

  const WrapperApp({
    super.key,
    required this.children,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Nested(
      children: children,
      child: child,
    );
  }
}
