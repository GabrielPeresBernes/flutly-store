import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/extensions/text_theme_extension.dart';
import '../../bloc/checkout/checkout_cubit.dart';
import '../../bloc/checkout_address/checkout_address_cubit.dart';
import '../../bloc/checkout_shipping/checkout_shipping_cubit.dart';
import '../page_states/address_loaded_widget.dart';
import '../page_states/address_loading_widget.dart';
import '../page_states/shipping_loaded_widget.dart';
import '../page_states/shipping_loading_widget.dart';

class CheckoutDeliveryBodyWidget extends StatefulWidget {
  const CheckoutDeliveryBodyWidget({super.key});

  @override
  State<CheckoutDeliveryBodyWidget> createState() =>
      _CheckoutDeliveryBodyWidgetState();
}

class _CheckoutDeliveryBodyWidgetState
    extends State<CheckoutDeliveryBodyWidget> {
  @override
  void initState() {
    context.read<CheckoutAddressCubit>().getAddresses();
    context.read<CheckoutShippingCubit>().getShippings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CheckoutCubit>();

    return MultiBlocListener(
      listeners: [
        BlocListener<CheckoutAddressCubit, CheckoutAddressState>(
          listenWhen: (previous, current) => current is CheckoutAddressLoaded,
          listener: (context, state) => cubit.selectAddress(
            (state as CheckoutAddressLoaded).addresses.first,
          ),
        ),
        BlocListener<CheckoutShippingCubit, CheckoutShippingState>(
          listenWhen: (previous, current) => current is CheckoutShippingLoaded,
          listener: (context, state) => cubit.selectShipping(
            (state as CheckoutShippingLoaded).shippings.first,
          ),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('checkout.sections.address'.tr(), style: context.bodyLarge),
          const SizedBox(height: 10),
          BlocBuilder<CheckoutAddressCubit, CheckoutAddressState>(
            builder: (context, state) {
              return switch (state) {
                CheckoutAddressInitial() ||
                CheckoutAddressLoading() => const AddressLoadingWidget(),
                CheckoutAddressLoaded(:final addresses) => AddressLoadedWidget(
                  addresses: addresses,
                ),
              };
            },
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16, bottom: 25),
            child: Divider(height: 1),
          ),
          Text('checkout.sections.shipping'.tr(), style: context.bodyLarge),
          const SizedBox(height: 10),
          BlocBuilder<CheckoutShippingCubit, CheckoutShippingState>(
            builder: (context, state) {
              return switch (state) {
                CheckoutShippingInitial() ||
                CheckoutShippingLoading() => const ShippingLoadingWidget(),
                CheckoutShippingLoaded(:final shippings) =>
                  ShippingLoadedWidget(
                    shippings: shippings,
                  ),
              };
            },
          ),
        ],
      ),
    );
  }
}
