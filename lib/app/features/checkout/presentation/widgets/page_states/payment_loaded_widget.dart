import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/extensions/text_theme_extension.dart';
import '../../../../../shared/theme/tokens/color_tokens.dart';
import '../../../../../shared/utils/payment_utils.dart';
import '../../../../../shared/widgets/app_icon_widget.dart';
import '../../../../../shared/widgets/app_list_tile_widget.dart';
import '../../../domain/entities/payment_card.dart';
import '../../bloc/checkout/checkout_cubit.dart';

class PaymentLoadedWidget extends StatelessWidget {
  const PaymentLoadedWidget({
    super.key,
    required this.paymentCards,
  });

  final List<PaymentCard> paymentCards;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CheckoutCubit>();

    return BlocBuilder<CheckoutCubit, CheckoutState>(
      buildWhen: (previous, current) => current is CheckoutPaymentSelected,
      builder: (context, state) {
        var selectedPaymentCard = paymentCards.first;

        if (state is CheckoutPaymentSelected) {
          selectedPaymentCard = state.paymentCard;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: paymentCards.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, index) {
                final card = paymentCards[index];
                final isSelected = card == selectedPaymentCard;

                return AppListTileWidget(
                  isSelected: isSelected,
                  actionIcon: 'edit',
                  onTap: () => cubit.selectPayment(card),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(card.name, style: context.bodySmall),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          AppIconWidget.svgAsset(
                            PaymentUtils.getCardBrandIcon(card.brand),
                            size: 20,
                          ),
                          const SizedBox(width: 20),
                          Text(
                            'checkout.summary.card_mask'.tr(
                              namedArgs: {'last4': card.last4Digits},
                            ),
                            style: context.bodyMedium.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            card.expirationDate,
                            style: context.bodyMedium.copyWith(
                              color: AppColors.gray100,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 5),
            TextButton(
              onPressed: () {},
              child: Text('checkout.actions.new_card'.tr()),
            ),
          ],
        );
      },
    );
  }
}
