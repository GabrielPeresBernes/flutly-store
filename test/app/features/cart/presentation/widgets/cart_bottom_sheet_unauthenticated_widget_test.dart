import 'package:flutly_store/app/core/router/router.dart';
import 'package:flutly_store/app/features/auth/infra/routes/auth_route.dart';
import 'package:flutly_store/app/features/cart/presentation/widgets/cart_bottom_sheet_unauthenticated_widget.dart';
import 'package:flutly_store/app/shared/widgets/buttons/app_elevated_button_widget.dart';
import 'package:flutly_store/app/shared/widgets/buttons/app_outlined_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../utils/test_utils.dart';

class MockRouterProvider extends Mock implements RouterProvider {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route<dynamic> {}

void main() {
  late RouterProvider routerProvider;
  late NavigatorObserver navigatorObserver;

  setUpAll(() async {
    await TestUtils.setUpLocalization();
    registerFallbackValue(FakeRoute());
  });

  setUp(() {
    routerProvider = MockRouterProvider();
    navigatorObserver = MockNavigatorObserver();

    when(() => routerProvider.canPop()).thenReturn(false);
    when(() => routerProvider.push(const AuthRoute())).thenReturn(null);
  });

  Future<void> pumpApp(WidgetTester tester) => TestUtils.pumpApp(
    tester,
    child: CoreRouterScope(
      coreRouter: CoreRouter(routes: const [], provider: routerProvider),
      child: Navigator(
        observers: [navigatorObserver],
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: CartBottomSheetUnauthenticatedWidget(),
          ),
        ),
      ),
    ),
  );

  testWidgets('renders title, message, and action buttons', (tester) async {
    await pumpApp(tester);
    await tester.pumpAndSettle();

    expect(find.text('Sign In Required'), findsOneWidget);
    expect(
      find.text('You need to be signed in to proceed to checkout.'),
      findsOneWidget,
    );

    final signInButton = tester.widget<AppElevatedButtonWidget>(
      find.byType(AppElevatedButtonWidget),
    );
    expect(signInButton.label, 'Sign In');

    final guestButton = tester.widget<AppOutlinedButtonWidget>(
      find.byType(AppOutlinedButtonWidget),
    );
    expect(guestButton.label, 'Continue as Guest');
  });

  testWidgets('tapping sign in pops and navigates to auth', (tester) async {
    await pumpApp(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(AppElevatedButtonWidget));
    await tester.pumpAndSettle();

    verify(() => navigatorObserver.didPop(any(), any())).called(1);
    verify(() => routerProvider.push(const AuthRoute())).called(1);
  });

  testWidgets('tapping continue as guest only pops', (tester) async {
    await pumpApp(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(AppOutlinedButtonWidget));
    await tester.pumpAndSettle();

    verify(() => navigatorObserver.didPop(any(), any())).called(1);
    verifyNever(() => routerProvider.push(const AuthRoute()));
  });
}
