import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/features/cart/domain/entities/cart.dart';
import 'package:flutly_store/app/features/cart/domain/entities/cart_product.dart';
import 'package:flutly_store/app/features/cart/presentation/bloc/cart/cart_cubit.dart';
import 'package:flutly_store/app/features/checkout/domain/entities/address.dart';
import 'package:flutly_store/app/features/checkout/domain/entities/payment_card.dart';
import 'package:flutly_store/app/features/checkout/domain/entities/shipping.dart';
import 'package:flutly_store/app/features/checkout/presentation/bloc/checkout/checkout_cubit.dart';
import 'package:flutly_store/app/features/checkout/presentation/widgets/bottom_sheets/checkout_review_body_widget.dart';
import 'package:flutly_store/app/features/checkout/presentation/widgets/summary_address_widget.dart';
import 'package:flutly_store/app/features/checkout/presentation/widgets/summary_delivery_widget.dart';
import 'package:flutly_store/app/features/checkout/presentation/widgets/summary_payment_widget.dart';
import 'package:flutly_store/app/features/checkout/presentation/widgets/summary_total_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../utils/test_utils.dart';

class MockCheckoutCubit extends MockCubit<CheckoutState>
    implements CheckoutCubit {}

class MockCartCubit extends MockCubit<CartState> implements CartCubit {}

void main() {
  late CheckoutCubit checkoutCubit;
  late CartCubit cartCubit;

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

  const cart = Cart(
    totalPrice: 20.0,
    totalItems: 2,
    products: {
      1: CartProduct(
        id: 1,
        quantity: 2,
        thumbnail: 'thumb.png',
        name: 'Item',
        price: 10.0,
      ),
    },
  );

  setUpAll(() async {
    await TestUtils.setUpLocalization();
  });

  setUp(() {
    checkoutCubit = MockCheckoutCubit();
    cartCubit = MockCartCubit();

    when(() => checkoutCubit.validateCheckout()).thenAnswer((_) async {});
    when(() => cartCubit.cart).thenReturn(cart);
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
      child: const CheckoutReviewBodyWidget(),
    );
  }

  testWidgets('shows loading while checkout is validating', (tester) async {
    await pumpApp(
      tester,
      checkoutStream: Stream.value(const CheckoutInitial()),
      initialCheckoutState: const CheckoutInitial(),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    verify(() => checkoutCubit.validateCheckout()).called(1);
  });

  testWidgets('renders summary widgets when checkout is validated', (
    tester,
  ) async {
    await pumpApp(
      tester,
      checkoutStream: Stream.value(
        const CheckoutValidated(
          address: address,
          shipping: shipping,
          payment: payment,
        ),
      ),
      initialCheckoutState: const CheckoutValidated(
        address: address,
        shipping: shipping,
        payment: payment,
      ),
    );
    await tester.pump();

    expect(find.byType(SummaryAddressWidget), findsOneWidget);
    expect(find.byType(SummaryDeliveryWidget), findsOneWidget);
    expect(find.byType(SummaryPaymentWidget), findsOneWidget);
    expect(find.byType(SummaryTotalWidget), findsOneWidget);
  });
}
