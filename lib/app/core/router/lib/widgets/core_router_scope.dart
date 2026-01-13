import 'package:flutter/widgets.dart';

import '../core_router.dart';

/// Inherited widget to provide access to [CoreRouter] throughout the widget tree.
class CoreRouterScope extends InheritedWidget {
  const CoreRouterScope({
    required this.coreRouter,
    required super.child,
    super.key,
  });

  final CoreRouter coreRouter;

  static CoreRouter of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CoreRouterScope>();
    assert(scope != null, 'CoreRouterScope not found in context');
    return scope!.coreRouter;
  }

  static CoreRouter? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<CoreRouterScope>()?.coreRouter;

  @override
  bool updateShouldNotify(CoreRouterScope oldWidget) =>
      coreRouter != oldWidget.coreRouter;
}
