import 'package:flutter/widgets.dart';

import '../../router.dart';

/// Extension on [BuildContext] to access the [RouterProvider].
extension CoreRouterExtension on BuildContext {
  RouterProvider get router => CoreRouterScope.of(this).router;
}
