import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/core/router/router.dart';
import 'package:flutly_store/app/features/cart/domain/entities/cart_product.dart';
import 'package:flutly_store/app/features/cart/presentation/bloc/cart/cart_cubit.dart';
import 'package:flutly_store/app/features/checkout/domain/entities/address.dart';
import 'package:flutly_store/app/features/checkout/domain/entities/order.dart';
import 'package:flutly_store/app/features/checkout/domain/entities/payment_card.dart';
import 'package:flutly_store/app/features/checkout/domain/entities/shipping.dart';
import 'package:flutly_store/app/features/checkout/infra/routes/checkout_route.dart';
import 'package:flutly_store/app/features/checkout/infra/routes/checkout_route_params.dart';
import 'package:flutly_store/app/features/checkout/presentation/bloc/checkout/checkout_cubit.dart';
import 'package:flutly_store/app/features/checkout/presentation/widgets/bottom_sheets/checkout_placing_order_body_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../utils/test_utils.dart';

class MockCheckoutCubit extends MockCubit<CheckoutState>
    implements CheckoutCubit {}

class MockCartCubit extends MockCubit<CartState> implements CartCubit {}

class MockRouterProvider extends Mock implements RouterProvider {}

void main() {
  late CheckoutCubit checkoutCubit;
  late CartCubit cartCubit;
  late RouterProvider routerProvider;

  const order = Order(
    id: '12345',
    address: Address(
      title: 'Home',
      street: 'Main St',
      city: 'Springfield',
      state: 'SP',
      zipCode: '00000',
      country: 'BR',
    ),
    shipping: Shipping(
      name: 'Express',
      cost: 0,
      duration: '2 days',
    ),
    payment: PaymentCard(
      name: 'User',
      last4Digits: '1234',
      expirationDate: '12/30',
      token: 'token',
      brand: CardBrand.visa,
    ),
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
    registerFallbackValue(const CheckoutRoute());
  });

  setUp(() {
    checkoutCubit = MockCheckoutCubit();
    cartCubit = MockCartCubit();
    routerProvider = MockRouterProvider();

    when(() => cartCubit.clearCart()).thenAnswer((_) async {});

    when(
      () => routerProvider.push(any(), params: any(named: 'params')),
    ).thenReturn(null);
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    required Stream<CheckoutState> checkoutStream,
    required CheckoutState initialCheckoutState,
  }) {
    whenListen(
      checkoutCubit,
      checkoutStream,
      initialState: initialCheckoutState,
    );
    whenListen(
      cartCubit,
      Stream.value(const CartInitial()),
      initialState: const CartInitial(),
    );

    return TestUtils.pumpApp(
      tester,
      providers: [
        BlocProvider<CheckoutCubit>.value(value: checkoutCubit),
        BlocProvider<CartCubit>.value(value: cartCubit),
      ],
      child: CoreRouterScope(
        coreRouter: CoreRouter(routes: const [], provider: routerProvider),
        child: const CheckoutPlacingOrderBodyWidget(),
      ),
    );
  }

  testWidgets('shows processing message for ongoing status', (tester) async {
    await pumpApp(
      tester,
      checkoutStream: Stream.value(
        const CheckoutPlacingOrderUpdate(
          status: OrderStatus.processing,
        ),
      ),
      initialCheckoutState: const CheckoutPlacingOrderUpdate(
        status: OrderStatus.processing,
      ),
    );
    await tester.pump();

    expect(
      find.text("We're confirming your order details..."),
      findsOneWidget,
    );
  });

  testWidgets('navigates to confirmation and clears cart on completion', (
    tester,
  ) async {
    await pumpApp(
      tester,
      checkoutStream: Stream.value(
        const CheckoutPlacingOrderUpdate(
          status: OrderStatus.completed,
          order: order,
        ),
      ),
      initialCheckoutState: const CheckoutPlacingOrderUpdate(
        status: OrderStatus.verifying,
      ),
    );
    await tester.pumpAndSettle();

    await tester.pump(const Duration(milliseconds: 1500));

    verify(() => cartCubit.clearCart()).called(1);
    final captured = verify(
      () => routerProvider.push(
        captureAny(),
        params: captureAny(named: 'params'),
      ),
    ).captured;
    expect(captured.first, isA<CheckoutRoute>());
    final params = captured[1] as CheckoutRouteParams;
    expect(params.order.id, order.id);
  });
}
