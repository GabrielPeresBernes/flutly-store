import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../shared/extensions/text_theme_extension.dart';
import '../../../../shared/theme/tokens/color_tokens.dart';
import '../../domain/entities/shipping.dart';
import 'summary_item_widget.dart';

class SummaryTotalWidget extends StatelessWidget {
  const SummaryTotalWidget({
    super.key,
    required this.totalItems,
    required this.totalPrice,
    required this.shipping,
  });

  final int totalItems;
  final double totalPrice;
  final Shipping shipping;

  @override
  Widget build(BuildContext context) {
    return SummaryItemWidget(
      title: 'checkout.sections.total'.tr(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'checkout.summary.items'.tr(
                  namedArgs: {'count': totalItems.toString()},
                ),
                style: context.bodyMedium,
              ),
              Text(
                'checkout.summary.price_usd'.tr(
                  namedArgs: {'price': totalPrice.toStringAsFixed(2)},
                ),
                style: context.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('checkout.sections.shipping'.tr(), style: context.bodyMedium),
              if (shipping.cost == 0)
                Text(
                  'checkout.summary.free'.tr(),
                  style: context.labelMedium.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              if (shipping.cost != 0)
                Text(
                  'checkout.summary.price_usd'.tr(
                    namedArgs: {
                      'price': shipping.cost.toStringAsFixed(2),
                    },
                  ),
                  style: context.bodyMedium,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.only(top: 8),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.gray200,
                  width: 0.5,
                ),
              ),
            ),
            child: Text(
              'checkout.summary.price_usd'.tr(
                namedArgs: {'price': totalPrice.toStringAsFixed(2)},
              ),
              style: context.labelMedium,
            ),
          ),
        ],
      ),
    );
  }
}
