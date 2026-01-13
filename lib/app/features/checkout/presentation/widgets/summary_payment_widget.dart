import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../shared/extensions/text_theme_extension.dart';
import '../../../../shared/theme/tokens/color_tokens.dart';
import '../../../../shared/utils/payment_utils.dart';
import '../../../../shared/widgets/app_icon_widget.dart';
import '../../domain/entities/payment_card.dart';
import 'summary_item_widget.dart';

class SummaryPaymentWidget extends StatelessWidget {
  const SummaryPaymentWidget({
    super.key,
    required this.payment,
  });

  final PaymentCard payment;

  @override
  Widget build(BuildContext context) {
    return SummaryItemWidget(
      title: 'checkout.sections.payment'.tr(),
      child: Row(
        children: [
          AppIconWidget.svgAsset(
            PaymentUtils.getCardBrandIcon(payment.brand),
            size: 20,
          ),
          const SizedBox(width: 20),
          Text(
            'checkout.summary.card_mask'.tr(
              namedArgs: {'last4': payment.last4Digits},
            ),
            style: context.bodyMedium,
          ),
          const SizedBox(width: 20),
          Text(
            payment.expirationDate,
            style: context.bodyMedium.copyWith(
              color: AppColors.gray100,
            ),
          ),
        ],
      ),
    );
  }
}
