import 'core_route.dart';
import 'core_route_base.dart';

/// A branch of core routes containing multiple [CoreRoute]s.
class CoreRouteBranch extends CoreRouteBase {
  const CoreRouteBranch({required this.routes});

  final List<CoreRoute> routes;
}
