import 'package:flutter/widgets.dart';

import '../models/core_route.dart';
import '../models/core_route_params.dart';

/// Interface for router providers.
abstract interface class RouterProvider {
  /// Gets the router configuration.
  RouterConfig<Object> get routerConfig;

  /// Navigates to the specified [route] with optional [params].
  void go(CoreRoute route, {CoreRouteParams? params});

  /// Pushes the specified [route] onto the navigation stack
  /// with optional [params].
  void push(CoreRoute route, {CoreRouteParams? params});

  /// Replaces the current route with the specified [route]
  /// and optional [params].
  void replace(CoreRoute route, {CoreRouteParams? params});

  /// Pops the current route off the navigation stack.
  void pop();

  /// Checks if the navigation stack can be popped.
  bool canPop();

  /// Retrieves the parameters of the current route as an instance of [T].
  T? getParams<T extends CoreRouteParams>();
}
