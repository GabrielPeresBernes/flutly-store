part of 'checkout_shipping_cubit.dart';

sealed class CheckoutShippingState {
  const CheckoutShippingState();
}

final class CheckoutShippingInitial extends CheckoutShippingState {
  const CheckoutShippingInitial();
}

final class CheckoutShippingLoading extends CheckoutShippingState {
  const CheckoutShippingLoading();
}

final class CheckoutShippingLoaded extends CheckoutShippingState {
  const CheckoutShippingLoaded({required this.shippings});

  final List<Shipping> shippings;
}
