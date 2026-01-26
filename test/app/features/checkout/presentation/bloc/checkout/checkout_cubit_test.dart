import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/features/cart/domain/entities/cart.dart';
import 'package:flutly_store/app/features/cart/domain/entities/cart_product.dart';
import 'package:flutly_store/app/features/checkout/domain/entities/address.dart';
import 'package:flutly_store/app/features/checkout/domain/entities/payment_card.dart';
import 'package:flutly_store/app/features/checkout/domain/entities/shipping.dart';
import 'package:flutly_store/app/features/checkout/presentation/bloc/checkout/checkout_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../utils/test_utils.dart';

void main() {
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
    cost: 10.0,
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

  blocTest<CheckoutCubit, CheckoutState>(
    'selectAddress emits address selected',
    build: CheckoutCubit.new,
    act: (cubit) => cubit.selectAddress(address),
    expect: () => [
      isA<CheckoutAddressSelected>().having(
        (state) => state.address,
        'address',
        address,
      ),
    ],
  );

  blocTest<CheckoutCubit, CheckoutState>(
    'selectShipping emits shipping selected',
    build: CheckoutCubit.new,
    act: (cubit) => cubit.selectShipping(shipping),
    expect: () => [
      isA<CheckoutShippingSelected>().having(
        (state) => state.shipping,
        'shipping',
        shipping,
      ),
    ],
  );

  blocTest<CheckoutCubit, CheckoutState>(
    'selectPayment emits payment selected',
    build: CheckoutCubit.new,
    act: (cubit) => cubit.selectPayment(payment),
    expect: () => [
      isA<CheckoutPaymentSelected>().having(
        (state) => state.paymentCard,
        'payment',
        payment,
      ),
    ],
  );

  blocTest<CheckoutCubit, CheckoutState>(
    'validateCheckout emits failure when data is incomplete',
    build: CheckoutCubit.new,
    act: (cubit) => cubit.validateCheckout(),
    expect: () => [
      isA<CheckoutIncompleteFailure>(),
    ],
  );

  blocTest<CheckoutCubit, CheckoutState>(
    'validateCheckout emits validated when all data is selected',
    build: CheckoutCubit.new,
    act: (cubit) async {
      cubit.selectAddress(address);
      cubit.selectShipping(shipping);
      cubit.selectPayment(payment);
      await cubit.validateCheckout();
    },
    expect: () => [
      isA<CheckoutAddressSelected>(),
      isA<CheckoutShippingSelected>(),
      isA<CheckoutPaymentSelected>(),
      isA<CheckoutValidated>()
          .having((state) => state.address, 'address', address)
          .having((state) => state.shipping, 'shipping', shipping)
          .having((state) => state.payment, 'payment', payment),
    ],
  );

  blocTest<CheckoutCubit, CheckoutState>(
    'placeOrder emits status updates and completes with order',
    build: () =>
        CheckoutCubit(checkoutStepDelay: const Duration(milliseconds: 10)),
    act: (cubit) async {
      cubit.selectAddress(address);
      cubit.selectShipping(shipping);
      cubit.selectPayment(payment);
      await cubit.placeOrder(cart);
    },
    wait: const Duration(milliseconds: 50),
    expect: () => [
      isA<CheckoutAddressSelected>(),
      isA<CheckoutShippingSelected>(),
      isA<CheckoutPaymentSelected>(),
      isA<CheckoutPlacingOrderUpdate>().having(
        (state) => state.status,
        'status',
        OrderStatus.verifying,
      ),
      isA<CheckoutPlacingOrderUpdate>().having(
        (state) => state.status,
        'status',
        OrderStatus.processing,
      ),
      isA<CheckoutPlacingOrderUpdate>().having(
        (state) => state.status,
        'status',
        OrderStatus.finalizing,
      ),
      isA<CheckoutPlacingOrderUpdate>()
          .having((state) => state.status, 'status', OrderStatus.completed)
          .having((state) => state.order?.totalItems, 'totalItems', 2)
          .having((state) => state.order?.totalPrice, 'totalPrice', 20.0)
          .having((state) => state.order?.products.length, 'products', 1)
          .having((state) => state.order?.id.length, 'idLength', 5),
    ],
  );
}
