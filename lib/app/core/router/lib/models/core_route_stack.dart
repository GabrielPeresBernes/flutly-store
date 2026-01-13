import 'package:flutter/widgets.dart';

import 'core_route_base.dart';
import 'core_route_branch.dart';

/// A stack of core route branches with a custom builder.
class CoreRouteStack extends CoreRouteBase {
  const CoreRouteStack({
    required this.builder,
    required this.branches,
  });

  final Widget Function(
    Widget body,
    int currentIndex,
    void Function(int index) navigateToBranch,
  )
  builder;

  final List<CoreRouteBranch> branches;
}
