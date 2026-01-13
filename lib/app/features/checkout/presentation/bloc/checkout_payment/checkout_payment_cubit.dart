import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/payment_card.dart';

part 'checkout_payment_state.dart';

class CheckoutPaymentCubit extends Cubit<CheckoutPaymentState> {
  CheckoutPaymentCubit() : super(const CheckoutPaymentInitial());

  List<PaymentCard> _buildPaymentCards() => [
    PaymentCard(
      name: 'checkout.sample_data.payment_personal_name'.tr(),
      last4Digits: '3456',
      expirationDate: '12/32',
      token: 'token1',
      brand: CardBrand.visa,
    ),
    PaymentCard(
      name: 'checkout.sample_data.payment_business_name'.tr(),
      last4Digits: '5678',
      expirationDate: '18/35',
      token: 'token2',
      brand: CardBrand.mastercard,
    ),
  ];

  Future<void> getPaymentCards() async {
    emit(const CheckoutPaymentLoading());

    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 500));

    emit(CheckoutPaymentLoaded(paymentCards: _buildPaymentCards()));
  }
}
