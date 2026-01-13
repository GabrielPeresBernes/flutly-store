import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/extensions/text_theme_extension.dart';
import '../../bloc/checkout/checkout_cubit.dart';
import '../../bloc/checkout_payment/checkout_payment_cubit.dart';
import '../page_states/payment_loaded_widget.dart';
import '../page_states/payment_loading_widget.dart';

class CheckoutPaymentBodyWidget extends StatefulWidget {
  const CheckoutPaymentBodyWidget({super.key});

  @override
  State<CheckoutPaymentBodyWidget> createState() =>
      _CheckoutPaymentBodyWidgetState();
}

class _CheckoutPaymentBodyWidgetState extends State<CheckoutPaymentBodyWidget> {
  @override
  void initState() {
    context.read<CheckoutPaymentCubit>().getPaymentCards();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CheckoutCubit>();

    return BlocListener<CheckoutPaymentCubit, CheckoutPaymentState>(
      listenWhen: (previous, current) => current is CheckoutPaymentLoaded,
      listener: (context, state) => cubit.selectPayment(
        (state as CheckoutPaymentLoaded).paymentCards.first,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('checkout.sections.credit_card'.tr(), style: context.bodyLarge),
          const SizedBox(height: 10),
          BlocBuilder<CheckoutPaymentCubit, CheckoutPaymentState>(
            builder: (context, state) {
              return switch (state) {
                CheckoutPaymentInitial() ||
                CheckoutPaymentLoading() => const PaymentLoadingWidget(),
                CheckoutPaymentLoaded(:final paymentCards) =>
                  PaymentLoadedWidget(
                    paymentCards: paymentCards,
                  ),
              };
            },
          ),
        ],
      ),
    );
  }
}
