import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../../core/router/router.dart';
import '../../../../../shared/widgets/products/medium_product_card_widget.dart';
import '../../../../../shared/widgets/products/product_list_title_widget.dart';
import '../../../../catalog/infra/routes/catalog_route.dart';
import '../../../../product/domain/entities/product.dart';

class PopularProductsLoadedWidget extends StatelessWidget {
  const PopularProductsLoadedWidget({
    super.key,
    required this.products,
  });

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProductListTitleWidget(
          title: 'cart.popular.title'.tr(),
          onTap: () => context.router.push(
            const CatalogRoute(),
          ),
        ),
        const SizedBox(height: 20),
        AnimationLimiter(
          child: SizedBox(
            height: 232,
            child: ListView.separated(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final product = products[index];

                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 300),
                  child: SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: MediumProductCardWidget(
                        title: product.title,
                        image: product.thumbnail,
                        price: product.price,
                        id: product.id,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
