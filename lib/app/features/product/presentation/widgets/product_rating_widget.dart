import 'package:flutter/material.dart';

import '../../../../shared/extensions/text_theme_extension.dart';
import '../../../../shared/widgets/app_icon_widget.dart';
import '../../domain/entities/product_extended.dart';

class ProductRatingWidget extends StatelessWidget {
  const ProductRatingWidget({
    super.key,
    required this.product,
  });

  final ProductExtended product;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: SizedBox(
            height: 16,
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (context, index) => const SizedBox(width: 5),
              itemBuilder: (context, index) {
                if (index < (product.rating?.floor() ?? 0)) {
                  return const AppIconWidget.svgAsset('star_filled', size: 16);
                } else {
                  return const AppIconWidget.svgAsset('star', size: 16);
                }
              },
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text('${product.rating}', style: context.bodySmall),
      ],
    );
  }
}
