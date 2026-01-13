part of 'checkout_payment_cubit.dart';

sealed class CheckoutPaymentState {
  const CheckoutPaymentState();
}

final class CheckoutPaymentInitial extends CheckoutPaymentState {
  const CheckoutPaymentInitial();
}

final class CheckoutPaymentLoading extends CheckoutPaymentState {
  const CheckoutPaymentLoading();
}

final class CheckoutPaymentLoaded extends CheckoutPaymentState {
  const CheckoutPaymentLoaded({required this.paymentCards});

  final List<PaymentCard> paymentCards;
}
