part of 'checkout_address_cubit.dart';

sealed class CheckoutAddressState {
  const CheckoutAddressState();
}

final class CheckoutAddressInitial extends CheckoutAddressState {
  const CheckoutAddressInitial();
}

final class CheckoutAddressLoading extends CheckoutAddressState {
  const CheckoutAddressLoading();
}

final class CheckoutAddressLoaded extends CheckoutAddressState {
  const CheckoutAddressLoaded({required this.addresses});

  final List<Address> addresses;
}
