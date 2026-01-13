import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

import '../../../core/router/router.dart';
import '../../../features/product/product.dart';
import '../../extensions/text_theme_extension.dart';
import '../../theme/tokens/color_tokens.dart';
import '../app_icon_widget.dart';
import '../app_network_image_widget.dart';
import 'product_hero_widget.dart';

class SmallProductCardWidget extends StatelessWidget {
  const SmallProductCardWidget({
    super.key,
    required this.title,
    required this.price,
    required this.image,
    this.id,
    this.rating,
  });

  final String title;
  final double price;
  final String image;
  final int? id;
  final double? rating;

  @override
  Widget build(BuildContext context) {
    final uniqueTag = UniqueKey().toString();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: id == null
          ? null
          : () => context.router.push(
              const ProductRoute(),
              params: ProductRouteParams(
                id: id!,
                title: title,
                thumbnail: image,
                tag: uniqueTag,
              ),
            ),
      child: SizedBox(
        height: 75,
        child: Row(
          children: [
            ProductHeroWidget(
              tag: uniqueTag,
              child: Container(
                padding: const EdgeInsets.all(4),
                width: 75,
                height: 75,
                decoration: ShapeDecoration(
                  color: AppColors.gray400,
                  shape: SmoothRectangleBorder(
                    borderRadius: SmoothBorderRadius(
                      cornerRadius: 10,
                      cornerSmoothing: .5,
                    ),
                  ),
                ),
                child: AppNetworkImageWidget(image),
              ),
            ),
            const SizedBox(width: 15),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.bodyLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text('USD $price', style: context.labelMedium),
                  const Spacer(),
                  if (rating != null)
                    Row(
                      children: [
                        const AppIconWidget.svgAsset('star_filled', size: 16),
                        const SizedBox(width: 5),
                        Text('$rating', style: context.bodySmall),
                      ],
                    ),
                  const SizedBox(height: 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
