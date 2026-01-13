import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/router/router.dart';
import '../../../../../shared/widgets/products/medium_product_card_widget.dart';
import '../../../../../shared/widgets/products/product_list_title_widget.dart';
import '../../../../catalog/infra/routes/catalog_route.dart';
import '../../../domain/entities/product.dart';

class RecommendationLoadedWidget extends StatelessWidget {
  const RecommendationLoadedWidget({
    super.key,
    required this.products,
  });

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProductListTitleWidget(
          title: 'product.sections.recommendations'.tr(),
          onTap: () => context.router.push(
            const CatalogRoute(),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 232,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final product = products[index];
              return MediumProductCardWidget(
                title: product.title,
                image: product.thumbnail,
                price: product.price,
                id: product.id,
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemCount: products.length,
          ),
        ),
      ],
    );
  }
}
