import 'package:flutter/widgets.dart';

import 'core_route_base.dart';
import 'core_route_params.dart';

enum TransitionAnimation {
  sharedAxisScaled,
}

/// A core route with a specific path, parameters, and builder.
abstract class CoreRoute<T extends CoreRouteParams> extends CoreRouteBase {
  const CoreRoute();

  String get path;

  Type get paramsType => T;

  TransitionAnimation? get transitionAnimation => null;

  T? paramsDecoder(Map<String, dynamic> json) => null;

  Widget builder(BuildContext context, T? params);

  List<CoreRoute> get subRoutes => const [];
}
