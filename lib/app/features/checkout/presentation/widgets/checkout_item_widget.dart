import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../shared/extensions/text_theme_extension.dart';
import '../../../../shared/theme/tokens/color_tokens.dart';
import '../../../../shared/widgets/app_network_image_widget.dart';
import '../../../cart/domain/entities/cart_product.dart';

class CheckoutItemWidget extends StatelessWidget {
  const CheckoutItemWidget({
    super.key,
    required this.product,
  });

  final CartProduct product;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.gray400,
              borderRadius: BorderRadius.circular(10),
            ),
            child: AppNetworkImageWidget(product.thumbnail),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product.name,
                  style: context.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'checkout.summary.price_usd'.tr(
                    namedArgs: {'price': product.price.toString()},
                  ),
                  style: context.bodyMedium,
                ),
                Text(
                  product.quantity.toString(),
                  style: context.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
