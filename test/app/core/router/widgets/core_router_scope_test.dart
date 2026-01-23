import 'package:flutly_store/app/core/router/lib/core_router.dart';
import 'package:flutly_store/app/core/router/lib/widgets/core_router_scope.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoreRouter extends Mock implements CoreRouter {}

void main() {
  testWidgets('of returns the provided CoreRouter', (tester) async {
    final coreRouter = MockCoreRouter();
    CoreRouter? captured;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: CoreRouterScope(
          coreRouter: coreRouter,
          child: Builder(
            builder: (context) {
              captured = CoreRouterScope.of(context);
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    expect(captured, same(coreRouter));
  });

  testWidgets('maybeOf returns null when scope is missing', (tester) async {
    CoreRouter? captured;

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(
          builder: (context) {
            captured = CoreRouterScope.maybeOf(context);
            return const SizedBox();
          },
        ),
      ),
    );

    expect(captured, isNull);
  });

  testWidgets('of asserts when scope is missing', (tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(
          builder: (context) {
            expect(() => CoreRouterScope.of(context), throwsAssertionError);
            return const SizedBox();
          },
        ),
      ),
    );
  });

  test('updateShouldNotify compares CoreRouter instances', () {
    final firstRouter = MockCoreRouter();
    final secondRouter = MockCoreRouter();

    final oldScope = CoreRouterScope(
      coreRouter: firstRouter,
      child: const SizedBox(),
    );

    final newScopeSame = CoreRouterScope(
      coreRouter: firstRouter,
      child: const SizedBox(),
    );

    final newScopeDifferent = CoreRouterScope(
      coreRouter: secondRouter,
      child: const SizedBox(),
    );

    expect(newScopeSame.updateShouldNotify(oldScope), isFalse);
    expect(newScopeDifferent.updateShouldNotify(oldScope), isTrue);
  });
}
