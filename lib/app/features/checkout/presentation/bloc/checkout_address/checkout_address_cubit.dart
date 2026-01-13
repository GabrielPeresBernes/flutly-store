import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/address.dart';

part 'checkout_address_state.dart';

List<Address> _buildAddresses() => [
  Address(
    title: 'checkout.sample_data.address_home_title'.tr(),
    street: 'checkout.sample_data.address_home_street'.tr(),
    city: 'checkout.sample_data.address_home_city'.tr(),
    zipCode: 'checkout.sample_data.address_home_zip'.tr(),
    country: 'checkout.sample_data.address_home_country'.tr(),
    state: 'checkout.sample_data.address_home_state'.tr(),
  ),
  Address(
    title: 'checkout.sample_data.address_office_title'.tr(),
    street: 'checkout.sample_data.address_office_street'.tr(),
    city: 'checkout.sample_data.address_office_city'.tr(),
    state: 'checkout.sample_data.address_office_state'.tr(),
    zipCode: 'checkout.sample_data.address_office_zip'.tr(),
    country: 'checkout.sample_data.address_office_country'.tr(),
  ),
];

class CheckoutAddressCubit extends Cubit<CheckoutAddressState> {
  CheckoutAddressCubit() : super(const CheckoutAddressInitial());

  Future<void> getAddresses() async {
    emit(const CheckoutAddressLoading());

    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 500));

    emit(CheckoutAddressLoaded(addresses: _buildAddresses()));
  }
}
