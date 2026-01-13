import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/router.dart';
import '../../../../shared/bloc/app_cubit.dart';
import '../../../../shared/constants/bottom_navigator_tabs.dart';
import '../../../../shared/errors/app_exception.dart';
import '../../../../shared/extensions/text_theme_extension.dart';
import '../../../../shared/widgets/error_message_widget.dart';
import '../../../../shared/widgets/navigation_bars/app_top_navigation_bar.dart';
import '../../infra/routes/checkout_route_params.dart';
import '../widgets/checkout_item_widget.dart';
import '../widgets/summary_address_widget.dart';
import '../widgets/summary_delivery_widget.dart';
import '../widgets/summary_item_widget.dart';
import '../widgets/summary_payment_widget.dart';
import '../widgets/summary_total_widget.dart';

class CheckoutConfirmationPage extends StatelessWidget {
  const CheckoutConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final order = context.router.getParams<CheckoutRouteParams>()?.order;

    return Scaffold(
      appBar: AppTopNavigationBar(
        showLogo: true,
        showLeading: false,
        actions: [
          AppBarAction(
            icon: 'close',
            onPressed: () {
              context.router.pop();
              context.read<AppCubit>().navigateToTab(
                BottomNavigatorTab.home,
                shouldReset: true,
              );
            },
          ),
        ],
      ),
      body: order == null
          ? ErrorMessageWidget(
              error: AppException(message: 'checkout.confirmation.not_found'.tr()),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'checkout.confirmation.thank_you'.tr(),
                      style: context.bodyMedium.copyWith(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      'checkout.confirmation.order_number'.tr(
                        namedArgs: {'id': order.id},
                      ),
                      style: context.titleLarge,
                    ),
                    const SizedBox(height: 20),
                    SummaryAddressWidget(address: order.address),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(height: 1),
                    ),
                    SummaryDeliveryWidget(shipping: order.shipping),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(height: 1),
                    ),
                    SummaryPaymentWidget(payment: order.payment),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(height: 1),
                    ),
                    SummaryItemWidget(
                      title: 'checkout.confirmation.items_title'.tr(),
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: order.products.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) => CheckoutItemWidget(
                          product: order.products[index],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(height: 1),
                    ),
                    SummaryTotalWidget(
                      totalItems: order.totalItems,
                      totalPrice: order.totalPrice,
                      shipping: order.shipping,
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
    );
  }
}
