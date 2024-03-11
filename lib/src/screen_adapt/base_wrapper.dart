import 'package:flutter/material.dart';

import 'package:nested/nested.dart';

/// 第三方类需要继承这个类，方便rootApp节点管理
abstract class BaseWrapper extends SingleChildStatelessWidget {
  const BaseWrapper({super.key});

  @override
  Widget buildWithChild(BuildContext context, Widget? child);
}
