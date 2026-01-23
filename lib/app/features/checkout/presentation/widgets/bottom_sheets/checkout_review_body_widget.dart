import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cart/presentation/bloc/cart_cubit.dart';
import '../../bloc/checkout/checkout_cubit.dart';
import '../summary_address_widget.dart';
import '../summary_delivery_widget.dart';
import '../summary_payment_widget.dart';
import '../summary_total_widget.dart';

class CheckoutReviewBodyWidget extends StatefulWidget {
  const CheckoutReviewBodyWidget({super.key});

  @override
  State<CheckoutReviewBodyWidget> createState() =>
      _CheckoutReviewBodyWidgetState();
}

class _CheckoutReviewBodyWidgetState extends State<CheckoutReviewBodyWidget> {
  @override
  void initState() {
    context.read<CheckoutCubit>().validateCheckout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartCubit>().cart;

    return BlocBuilder<CheckoutCubit, CheckoutState>(
      builder: (context, state) {
        return switch (state) {
          CheckoutValidated(:final address, :final shipping, :final payment) =>
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SummaryAddressWidget(address: address),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Divider(height: 1),
                ),
                SummaryDeliveryWidget(shipping: shipping),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Divider(height: 1),
                ),
                SummaryPaymentWidget(payment: payment),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Divider(height: 1),
                ),
                SummaryTotalWidget(
                  totalItems: cart.totalItems,
                  totalPrice: cart.totalPrice,
                  shipping: shipping,
                ),
              ],
            ),
          _ => const Center(
            child: CircularProgressIndicator(),
          ),
        };
      },
    );
  }
}
