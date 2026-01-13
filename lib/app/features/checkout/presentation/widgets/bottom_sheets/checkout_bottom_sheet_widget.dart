import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/injector/injector.dart';
import '../../../../../shared/widgets/app_bottom_sheet_widget.dart';
import '../../bloc/checkout/checkout_cubit.dart';
import '../../bloc/checkout_address/checkout_address_cubit.dart';
import '../../bloc/checkout_navigation/checkout_navigation_cubit.dart';
import '../../bloc/checkout_payment/checkout_payment_cubit.dart';
import '../../bloc/checkout_shipping/checkout_shipping_cubit.dart';
import '../checkout_action_button_widget.dart';
import '../checkout_step_progress.dart';
import 'checkout_delivery_body_widget.dart';
import 'checkout_payment_body_widget.dart';
import 'checkout_placing_order_body_widget.dart';
import 'checkout_review_body_widget.dart';

class CheckoutBottomSheetWidget extends StatelessWidget {
  const CheckoutBottomSheetWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              CoreInjector.instance.get<CheckoutNavigationCubit>(),
        ),
        BlocProvider(
          create: (context) => CoreInjector.instance.get<CheckoutCubit>(),
        ),
        BlocProvider(
          create: (context) =>
              CoreInjector.instance.get<CheckoutAddressCubit>(),
        ),
        BlocProvider(
          create: (context) =>
              CoreInjector.instance.get<CheckoutShippingCubit>(),
        ),
        BlocProvider(
          create: (context) =>
              CoreInjector.instance.get<CheckoutPaymentCubit>(),
        ),
      ],
      child: BlocBuilder<CheckoutNavigationCubit, CheckoutNavigationState>(
        builder: (context, state) {
          return AppBottomSheetWidget(
            title: state.step.title,
            showTrailing: state.step != CheckoutStep.placingOrder,
            trailingIcon: state.step == CheckoutStep.delivery
                ? 'close'
                : 'arrow_left',
            onTrailingPressed: () => state.step == CheckoutStep.delivery
                ? Navigator.of(context).pop()
                : context.read<CheckoutNavigationCubit>().goToPreviousStep(),
            body: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.step == CheckoutStep.delivery)
                    const CheckoutDeliveryBodyWidget()
                  else if (state.step == CheckoutStep.payment)
                    const CheckoutPaymentBodyWidget()
                  else if (state.step == CheckoutStep.review)
                    const CheckoutReviewBodyWidget()
                  else if (state.step == CheckoutStep.placingOrder)
                    const CheckoutPlacingOrderBodyWidget(),

                  if (state.step != CheckoutStep.placingOrder)
                    Column(
                      children: [
                        const SizedBox(height: 35),
                        const CheckoutStepProgress(),
                        const SizedBox(height: 12),
                        CheckoutActionButtonWidget(step: state.step),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
