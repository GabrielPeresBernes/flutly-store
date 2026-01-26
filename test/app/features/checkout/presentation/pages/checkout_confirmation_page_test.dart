import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/core/router/router.dart';
import 'package:flutly_store/app/features/cart/domain/entities/cart_product.dart';
import 'package:flutly_store/app/features/checkout/domain/entities/address.dart';
import 'package:flutly_store/app/features/checkout/domain/entities/order.dart';
import 'package:flutly_store/app/features/checkout/domain/entities/payment_card.dart';
import 'package:flutly_store/app/features/checkout/domain/entities/shipping.dart';
import 'package:flutly_store/app/features/checkout/infra/routes/checkout_route_params.dart';
import 'package:flutly_store/app/features/checkout/presentation/pages/checkout_confirmation_page.dart';
import 'package:flutly_store/app/features/checkout/presentation/widgets/checkout_item_widget.dart';
import 'package:flutly_store/app/features/checkout/presentation/widgets/summary_address_widget.dart';
import 'package:flutly_store/app/features/checkout/presentation/widgets/summary_delivery_widget.dart';
import 'package:flutly_store/app/features/checkout/presentation/widgets/summary_payment_widget.dart';
import 'package:flutly_store/app/features/checkout/presentation/widgets/summary_total_widget.dart';
import 'package:flutly_store/app/shared/bloc/app_cubit.dart';
import 'package:flutly_store/app/shared/constants/bottom_navigator_tabs.dart';
import 'package:flutly_store/app/shared/widgets/app_icon_widget.dart';
import 'package:flutly_store/app/shared/widgets/error_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../utils/test_utils.dart';

class MockRouterProvider extends Mock implements RouterProvider {}

class MockAppCubit extends MockCubit<AppState> implements AppCubit {}

void main() {
  late RouterProvider routerProvider;
  late AppCubit appCubit;

  const address = Address(
    title: 'Home',
    street: 'Main St',
    city: 'Springfield',
    state: 'SP',
    zipCode: '00000',
    country: 'BR',
  );

  const shipping = Shipping(
    name: 'Express',
    cost: 0,
    duration: '2 days',
  );

  const payment = PaymentCard(
    name: 'User',
    last4Digits: '1234',
    expirationDate: '12/30',
    token: 'token',
    brand: CardBrand.visa,
  );

  const order = Order(
    id: '12345',
    address: address,
    shipping: shipping,
    payment: payment,
    products: [
      CartProduct(
        id: 1,
        quantity: 1,
        thumbnail: 'thumb.png',
        name: 'Item',
        price: 10.0,
      ),
    ],
    totalPrice: 10.0,
    totalItems: 1,
  );

  setUpAll(() async {
    await TestUtils.setUpLocalization();
    registerFallbackValue(BottomNavigatorTab.home);
  });

  setUp(() {
    routerProvider = MockRouterProvider();
    appCubit = MockAppCubit();

    when(() => routerProvider.canPop()).thenReturn(false);

    when(() => routerProvider.pop()).thenReturn(null);

    when(
      () =>
          appCubit.navigateToTab(any(), shouldReset: any(named: 'shouldReset')),
    ).thenAnswer((_) async {});

    whenListen(
      appCubit,
      Stream.fromIterable([const AppInitial()]),
      initialState: const AppInitial(),
    );
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    CheckoutRouteParams? params,
  }) {
    when(
      () => routerProvider.getParams<CheckoutRouteParams>(),
    ).thenReturn(params);

    return TestUtils.pumpApp(
      tester,
      providers: [
        BlocProvider<AppCubit>.value(value: appCubit),
      ],
      child: CoreRouterScope(
        coreRouter: CoreRouter(routes: const [], provider: routerProvider),
        child: const CheckoutConfirmationPage(),
      ),
    );
  }

  testWidgets('renders error when order is missing', (tester) async {
    await pumpApp(tester);
    await tester.pumpAndSettle();

    expect(find.byType(ErrorMessageWidget), findsOneWidget);
  });

  testWidgets('renders order summary when order exists', (tester) async {
    await pumpApp(tester, params: const CheckoutRouteParams(order: order));
    await tester.pumpAndSettle();

    expect(find.textContaining(order.id), findsOneWidget);
    expect(find.byType(SummaryAddressWidget), findsOneWidget);
    expect(find.byType(SummaryDeliveryWidget), findsOneWidget);
    expect(find.byType(SummaryPaymentWidget), findsOneWidget);
    expect(find.byType(SummaryTotalWidget), findsOneWidget);
    expect(find.byType(CheckoutItemWidget), findsOneWidget);
  });

  testWidgets('close action pops and navigates home', (tester) async {
    await pumpApp(tester, params: const CheckoutRouteParams(order: order));
    await tester.pumpAndSettle();

    final closeIcon = find.byWidgetPredicate(
      (widget) =>
          widget is AppIconWidget && widget.icon == 'assets/icons/close.svg',
    );
    await tester.tap(
      find.ancestor(of: closeIcon, matching: find.byType(IconButton)),
    );
    await tester.pump();

    verify(() => routerProvider.pop()).called(1);
    verify(
      () => appCubit.navigateToTab(
        BottomNavigatorTab.home,
        shouldReset: true,
      ),
    ).called(1);
  });
}
