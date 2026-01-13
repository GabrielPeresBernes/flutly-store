import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../shared/extensions/text_theme_extension.dart';
import '../../../../shared/theme/tokens/color_tokens.dart';
import '../../domain/entities/cart.dart';

class CartSummaryWidget extends StatelessWidget {
  const CartSummaryWidget({super.key, required this.cart});

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    final itemLabel = cart.totalItems == 1
        ? 'cart.summary.item'.tr()
        : 'cart.summary.items'.tr();

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'cart.summary.total'.tr(
              namedArgs: {
                'count': cart.totalItems.toString(),
                'itemLabel': itemLabel,
              },
            ),
            style: context.labelSmall.copyWith(color: AppColors.gray100),
          ),
          Text(
            'cart.summary.price_usd'.tr(
              namedArgs: {'price': cart.totalPrice.toStringAsFixed(2)},
            ),
            style: context.labelLarge,
          ),
        ],
      ),
    );
  }
}
