import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../models/core_route.dart';
import '../models/core_route_base.dart';
import '../models/core_route_params.dart';
import '../models/core_route_stack.dart';
import '../widgets/indexed_stacked_route_branch_container.dart';
import 'router_provider.dart';

/// GoRouter implementation of the RouterProvider interface.
class GoRouterProvider implements RouterProvider {
  GoRouterProvider(this._routes) {
    _goRouter = GoRouter(
      routes: _routes.map(_buildRoute).toList(),
    );
  }

  late final GoRouter _goRouter;

  final List<CoreRouteBase> _routes;

  final Map<Type, CoreRouteParams? Function(Map<String, dynamic>)> _decoders =
      {};

  RouteBase _buildRoute(CoreRouteBase coreRoute) {
    if (coreRoute is CoreRoute) {
      _decoders.putIfAbsent(
        coreRoute.paramsType,
        () => coreRoute.paramsDecoder,
      );

      return GoRoute(
        path: coreRoute.path,
        builder: (context, state) =>
            coreRoute.builder(context, _getParams(state, coreRoute)),
        pageBuilder: !Platform.isIOS && coreRoute.transitionAnimation != null
            ? (context, state) => _buildPage(context, coreRoute, state)
            : null,
        routes: coreRoute.subRoutes.map(_buildRoute).toList(),
      );
    }

    if (coreRoute is CoreRouteStack) {
      return StatefulShellRoute(
        branches: coreRoute.branches
            .map(
              (branch) => StatefulShellBranch(
                routes: branch.routes.map(_buildRoute).toList(),
              ),
            )
            .toList(),
        builder: (_, state, navigationShell) => coreRoute.builder(
          navigationShell,
          navigationShell.currentIndex,
          (index) => navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          ),
        ),
        navigatorContainerBuilder: (_, navigationShell, children) =>
            IndexedStackedRouteBranchContainer(
              currentIndex: navigationShell.currentIndex,
              children: children,
            ),
      );
    }

    throw Exception('Unsupported route type: ${coreRoute.runtimeType}');
  }

  @override
  GoRouter get routerConfig => _goRouter;

  @override
  void go(CoreRoute route, {CoreRouteParams? params}) =>
      _goRouter.go(route.path, extra: params?.toJson());

  @override
  void push(CoreRoute route, {CoreRouteParams? params}) =>
      _goRouter.push(route.path, extra: params?.toJson());

  @override
  void replace(CoreRoute route, {CoreRouteParams? params}) =>
      _goRouter.replace(route.path, extra: params?.toJson());

  @override
  void pop() => _goRouter.pop();

  @override
  bool canPop() => _goRouter.canPop();

  @override
  T? getParams<T extends CoreRouteParams>() {
    final extra = _goRouter.state.extra;

    if (extra == null) {
      return null;
    }

    if (extra is! Map<String, dynamic>) {
      throw Exception('Extra data is not of type Map<String, dynamic>.');
    }

    final decoder = _decoders[T];

    if (decoder == null) {
      throw Exception('No decoder registered for $T');
    }

    return decoder(extra)! as T;
  }

  CoreRouteParams? _getParams(GoRouterState state, CoreRoute coreRoute) =>
      state.extra == null
      ? null
      : coreRoute.paramsDecoder.call(state.extra! as Map<String, dynamic>);

  Page<dynamic> _buildPage(
    BuildContext context,
    CoreRoute coreRoute,
    GoRouterState state,
  ) => switch (coreRoute.transitionAnimation!) {
    TransitionAnimation.sharedAxisScaled => CustomTransitionPage<void>(
      key: state.pageKey,
      child: coreRoute.builder(context, _getParams(state, coreRoute)),
      transitionsBuilder: (_, animation, secondaryAnimation, child) =>
          SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.scaled,
            child: child,
          ),
    ),
  };
}
