import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/widgets/buttons/app_elevated_button_widget.dart';
import '../../../cart/presentation/bloc/cart_cubit.dart';
import '../bloc/checkout/checkout_cubit.dart';
import '../bloc/checkout_address/checkout_address_cubit.dart';
import '../bloc/checkout_navigation/checkout_navigation_cubit.dart';
import '../bloc/checkout_payment/checkout_payment_cubit.dart';
import '../bloc/checkout_shipping/checkout_shipping_cubit.dart';

class CheckoutActionButtonWidget extends StatelessWidget {
  const CheckoutActionButtonWidget({
    super.key,
    required this.step,
  });

  final CheckoutStep step;

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();

    final addressCubit = context.watch<CheckoutAddressCubit>();
    final shippingCubit = context.watch<CheckoutShippingCubit>();
    final paymentCubit = context.watch<CheckoutPaymentCubit>();

    final isLoading =
        addressCubit.state is CheckoutAddressLoading ||
        shippingCubit.state is CheckoutShippingLoading ||
        paymentCubit.state is CheckoutPaymentLoading;

    return AppElevatedButtonWidget(
      isLoading: isLoading,
      label: step.action,
      suffixIcon: step != CheckoutStep.review ? 'chevron_right' : 'lock',
      onPressed: () {
        if (isLoading) {
          return;
        }

        if (step == CheckoutStep.review) {
          context.read<CheckoutCubit>().placeOrder(cartCubit.cart);
        }

        context.read<CheckoutNavigationCubit>().goToNextStep();
      },
    );
  }
}
