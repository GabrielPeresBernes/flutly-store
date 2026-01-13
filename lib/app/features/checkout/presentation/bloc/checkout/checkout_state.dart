part of 'checkout_cubit.dart';

sealed class CheckoutState {
  const CheckoutState();
}

final class CheckoutInitial extends CheckoutState {
  const CheckoutInitial();
}

final class CheckoutIncompleteFailure extends CheckoutState {
  const CheckoutIncompleteFailure({required this.exception});

  final AppException exception;
}

final class CheckoutAddressSelected extends CheckoutState {
  const CheckoutAddressSelected({required this.address});

  final Address address;
}

final class CheckoutShippingSelected extends CheckoutState {
  const CheckoutShippingSelected({required this.shipping});

  final Shipping shipping;
}

final class CheckoutPaymentSelected extends CheckoutState {
  const CheckoutPaymentSelected({required this.paymentCard});

  final PaymentCard paymentCard;
}

final class CheckoutFailure extends CheckoutState {
  const CheckoutFailure({required this.exception});

  final AppException exception;
}

final class CheckoutValidated extends CheckoutState {
  const CheckoutValidated({
    required this.address,
    required this.shipping,
    required this.payment,
  });

  final Address address;
  final Shipping shipping;
  final PaymentCard payment;
}

final class CheckoutPlacingOrderUpdate extends CheckoutState {
  const CheckoutPlacingOrderUpdate({
    required this.status,
    this.order,
  });

  final OrderStatus status;
  final Order? order;
}
