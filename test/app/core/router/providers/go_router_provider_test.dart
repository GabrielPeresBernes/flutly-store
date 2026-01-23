import 'package:animations/animations.dart';
import 'package:flutly_store/app/core/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestParams extends CoreRouteParams {
  const _TestParams(this.id);

  final int id;

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{'id': id};
}

class _TestRoute extends CoreRoute<_TestParams> {
  const _TestRoute([this._transition]);

  final TransitionAnimation? _transition;

  @override
  String get path => '/';

  @override
  TransitionAnimation? get transitionAnimation => _transition;

  @override
  _TestParams? paramsDecoder(Map<String, dynamic> json) =>
      _TestParams(json['id'] as int);

  @override
  Widget builder(BuildContext context, _TestParams? params) =>
      const SizedBox.shrink();
}

Widget _buildApp(GoRouterProvider provider) {
  return MaterialApp.router(routerConfig: provider.routerConfig);
}

void main() {
  late CoreRoute<CoreRouteParams> route;
  late CoreRoute<CoreRouteParams> customRoute;
  late CoreRouteStack routeStack;

  setUpAll(() {
    route = const _TestRoute();
    customRoute = const _TestRoute(TransitionAnimation.sharedAxisScaled);
    routeStack = CoreRouteStack(
      builder: (_, __, ___) => const SizedBox.shrink(),
      branches: [
        CoreRouteBranch(routes: [route]),
      ],
    );
  });

  testWidgets('getParams returns null when no extra is set', (tester) async {
    final provider = GoRouterProvider(<CoreRoute>[route]);

    await tester.pumpWidget(_buildApp(provider));
    await tester.pumpAndSettle();

    final params = provider.getParams<_TestParams>();

    expect(params, isNull);
  });

  testWidgets('getParams decodes params after navigation', (tester) async {
    final provider = GoRouterProvider(<CoreRoute>[route]);

    await tester.pumpWidget(_buildApp(provider));
    await tester.pumpAndSettle();

    provider.go(route, params: const _TestParams(42));

    await tester.pumpAndSettle();

    final params = provider.getParams<_TestParams>();

    expect(params?.id, 42);
  });

  testWidgets('provider builds page with custom animation', (tester) async {
    final provider = GoRouterProvider(<CoreRoute>[customRoute]);

    await tester.pumpWidget(_buildApp(provider));
    await tester.pumpAndSettle();

    provider.go(customRoute, params: const _TestParams(42));

    await tester.pump();

    // Verify that a SharedAxisTransition is used
    expect(find.byType(SharedAxisTransition), findsOneWidget);
  });

  testWidgets('provider builds route stack', (tester) async {
    final provider = GoRouterProvider([routeStack]);

    await tester.pumpWidget(_buildApp(provider));
    await tester.pumpAndSettle();

    provider.go(route, params: const _TestParams(42));

    await tester.pump();

    // Verify that the route stack is built
    expect(find.byType(SizedBox), findsOneWidget);
  });
}
