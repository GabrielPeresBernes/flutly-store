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

class LargeProductCardWidget extends StatelessWidget {
  const LargeProductCardWidget({
    super.key,
    required this.title,
    required this.image,
    required this.id,
  });

  final String title;
  final String image;
  final int id;

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
            width: 330,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    children: [
                      Text(title, style: context.headlineSmall),
                      const Spacer(),
                      Row(
                        spacing: 12,
                        children: [
                          Text(
                            'Shop now',
                            style: context.labelMedium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          const AppIconWidget.svgAsset(
                            'arrow_right',
                            size: 20,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                ProductHeroWidget(
                  tag: uniqueTag,
                  child: AppNetworkImageWidget(image, width: 140, height: 140),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
