import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/errors/app_exception.dart';
import '../../../../../shared/utils/number_utils.dart';
import '../../../../cart/domain/entities/cart.dart';
import '../../../domain/entities/address.dart';
import '../../../domain/entities/order.dart';
import '../../../domain/entities/payment_card.dart';
import '../../../domain/entities/shipping.dart';

part 'checkout_state.dart';

enum OrderStatus {
  verifying('checkout.order_status.verifying'),
  processing('checkout.order_status.processing'),
  finalizing('checkout.order_status.finalizing'),
  completed('checkout.order_status.completed');

  const OrderStatus(this.labelKey);

  final String labelKey;

  String get label => labelKey.tr();
}

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit() : super(const CheckoutInitial());

  Address? _selectedAddress;
  Shipping? _selectedShipping;
  PaymentCard? _selectedPayment;

  void selectAddress(Address address) {
    _selectedAddress = address;
    emit(CheckoutAddressSelected(address: address));
  }

  void selectShipping(Shipping shipping) {
    _selectedShipping = shipping;
    emit(CheckoutShippingSelected(shipping: shipping));
  }

  void selectPayment(PaymentCard paymentCard) {
    _selectedPayment = paymentCard;
    emit(CheckoutPaymentSelected(paymentCard: paymentCard));
  }

  Future<void> validateCheckout() async {
    if (_selectedAddress == null ||
        _selectedShipping == null ||
        _selectedPayment == null) {
      emit(
        CheckoutIncompleteFailure(
          exception: AppException(
            message: tr('checkout.validation.missing_info'),
          ),
        ),
      );
      return;
    }

    emit(
      CheckoutValidated(
        address: _selectedAddress!,
        shipping: _selectedShipping!,
        payment: _selectedPayment!,
      ),
    );
  }

  Future<void> placeOrder(Cart cart) async {
    emit(const CheckoutPlacingOrderUpdate(status: OrderStatus.verifying));

    // Simulate order placement process
    for (final status in OrderStatus.values.skip(1)) {
      await Future<void>.delayed(const Duration(seconds: 2));

      if (status == OrderStatus.completed) {
        emit(
          CheckoutPlacingOrderUpdate(
            status: status,
            order: Order(
              id: NumberUtils.getRandomInt(5).toString(),
              address: _selectedAddress!,
              shipping: _selectedShipping!,
              payment: _selectedPayment!,
              products: cart.products.values.toList(),
              totalPrice: cart.totalPrice,
              totalItems: cart.totalItems,
            ),
          ),
        );
        return;
      }

      emit(CheckoutPlacingOrderUpdate(status: status));
    }
  }
}
