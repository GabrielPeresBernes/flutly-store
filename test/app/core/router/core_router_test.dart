import 'package:flutly_store/app/core/router/lib/core_router.dart';
import 'package:flutly_store/app/core/router/lib/models/core_route.dart';
import 'package:flutly_store/app/core/router/lib/models/core_route_base.dart';
import 'package:flutly_store/app/core/router/lib/models/core_route_params.dart';
import 'package:flutly_store/app/core/router/lib/providers/go_router_provider.dart';
import 'package:flutly_store/app/core/router/lib/providers/router_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRouterProvider extends Mock implements RouterProvider {}

class _TestParams extends CoreRouteParams {
  const _TestParams();

  @override
  Map<String, dynamic> toJson() => const <String, dynamic>{};
}

class _TestRoute extends CoreRoute<_TestParams> {
  const _TestRoute();

  @override
  String get path => '/';

  @override
  Widget builder(BuildContext context, _TestParams? params) =>
      const SizedBox.shrink();
}

void main() {
  test('uses provided router provider', () {
    final provider = MockRouterProvider();

    final router = CoreRouter(
      routes: const <CoreRouteBase>[],
      provider: provider,
    );

    expect(router.router, provider);
  });

  test('defaults to GoRouterProvider when no provider is passed', () {
    final router = CoreRouter(
      routes: const <CoreRouteBase>[_TestRoute()],
    );

    expect(router.router, isA<GoRouterProvider>());
  });
}
