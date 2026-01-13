import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../../shared/extensions/text_theme_extension.dart';
import '../../../../../shared/widgets/products/small_product_card_widget.dart';
import '../../../../product/domain/entities/product.dart';

class SearchPopularProductsLoadedWidget extends StatelessWidget {
  const SearchPopularProductsLoadedWidget({super.key, required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'search.sections.popular_products'.tr(),
          style: context.bodyLarge,
        ),
        const SizedBox(height: 20),
        AnimationLimiter(
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 300),
                child: SlideAnimation(
                  horizontalOffset: 50,
                  child: FadeInAnimation(
                    child: SmallProductCardWidget(
                      title: product.title,
                      price: product.price,
                      image: product.thumbnail,
                      rating: product.rating ?? 0,
                      id: product.id,
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 20),
          ),
        ),
      ],
    );
  }
}
