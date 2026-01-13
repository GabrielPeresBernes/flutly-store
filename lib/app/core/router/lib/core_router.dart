import 'models/core_route_base.dart';
import 'providers/go_router_provider.dart';
import 'providers/router_provider.dart';

/// Core Router for managing application routes.
class CoreRouter {
  CoreRouter({
    required this.routes,
    RouterProvider? provider,
  }) : _provider = provider ?? GoRouterProvider(routes);

  final List<CoreRouteBase> routes;

  final RouterProvider _provider;

  RouterProvider get router => _provider;
}
