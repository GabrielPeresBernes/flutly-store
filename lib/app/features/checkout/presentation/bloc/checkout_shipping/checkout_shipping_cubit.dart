import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/shipping.dart';

part 'checkout_shipping_state.dart';

List<Shipping> _buildShippingMethods() => [
  Shipping(
    cost: 0,
    duration: 'checkout.sample_data.shipping_duration'.tr(),
    name: 'checkout.sample_data.shipping_name'.tr(),
  ),
];

class CheckoutShippingCubit extends Cubit<CheckoutShippingState> {
  CheckoutShippingCubit() : super(const CheckoutShippingInitial());

  Future<void> getShippings() async {
    emit(const CheckoutShippingLoading());

    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 500));

    emit(CheckoutShippingLoaded(shippings: _buildShippingMethods()));
  }
}
