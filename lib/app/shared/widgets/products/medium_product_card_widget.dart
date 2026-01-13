import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

import '../../../core/router/router.dart';
import '../../../features/product/infra/routes/product_route.dart';
import '../../../features/product/infra/routes/product_route_params.dart';
import '../../extensions/text_theme_extension.dart';
import '../../theme/tokens/color_tokens.dart';
import '../app_icon_widget.dart';
import '../app_network_image_widget.dart';
import 'product_hero_widget.dart';

class MediumProductCardWidget extends StatelessWidget {
  const MediumProductCardWidget({
    super.key,
    required this.id,
    required this.title,
    required this.image,
    this.price,
    this.rating,
  });

  final int id;
  final String title;
  final String image;
  final double? price;
  final double? rating;

  @override
  Widget build(BuildContext context) {
    final uniqueTag = UniqueKey().toString();

    return ClipSmoothRect(
      radius: SmoothBorderRadius(
        cornerRadius: 10,
        cornerSmoothing: .5,
      ),
      child: Material(
        color: AppColors.white,
        child: InkWell(
          splashFactory: InkRipple.splashFactory,
          onTap: () => context.router.push(
            const ProductRoute(),
            params: ProductRouteParams(
              id: id,
              title: title,
              thumbnail: image,
              tag: uniqueTag,
            ),
          ),
          child: Container(
            width: 155,
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductHeroWidget(
                  tag: uniqueTag,
                  child: Center(
                    child: AppNetworkImageWidget(
                      image,
                      width: 120,
                      height: 120,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  title,
                  style: context.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (price != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'USD ${price!.toStringAsFixed(2)}',
                      style: context.labelSmall,
                    ),
                  ),
                if (rating != null)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const AppIconWidget.svgAsset(
                            'star_filled',
                            size: 16,
                          ),
                          const SizedBox(width: 5),
                          Text('$rating', style: context.bodySmall),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
