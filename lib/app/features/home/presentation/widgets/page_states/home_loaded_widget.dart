import 'package:flutter/widgets.dart';

import '../../../../../core/router/router.dart';
import '../../../../../shared/widgets/products/large_product_card_widget.dart';
import '../../../../../shared/widgets/products/medium_product_card_widget.dart';
import '../../../../../shared/widgets/products/product_list_title_widget.dart';
import '../../../../catalog/infra/routes/catalog_route.dart';
import '../../../../catalog/infra/routes/catalog_route_params.dart';
import '../../../domain/entities/home_product_list.dart';

class HomeLoadedWidget extends StatelessWidget {
  const HomeLoadedWidget({
    super.key,
    required this.productLists,
  });

  final List<HomeProductList> productLists;

  static Widget _buildLargeProductCardListWidget(
    BuildContext context,
    HomeProductList productList,
  ) => SizedBox(
    height: 190,
    child: ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      scrollDirection: Axis.horizontal,
      itemCount: productList.products.length,
      separatorBuilder: (context, index) => const SizedBox(width: 15),
      itemBuilder: (context, index) {
        final product = productList.products[index];

        return LargeProductCardWidget(
          id: product.id,
          title: product.title,
          image: product.image,
        );
      },
    ),
  );

  static Widget _buildMediumProductCardListWidget(
    BuildContext context,
    HomeProductList productList,
  ) {
    return SizedBox(
      height: 232,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: productList.products.length,
        separatorBuilder: (context, index) => const SizedBox(width: 15),
        itemBuilder: (context, index) {
          final product = productList.products[index];

          return MediumProductCardWidget(
            id: product.id,
            title: product.title,
            image: product.image,
            price: product.price,
          );
        },
      ),
    );
  }

  static Widget _buildProductListTitleWidget(
    BuildContext context,
    HomeProductList productList,
  ) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    child: ProductListTitleWidget(
      title: productList.title,
      onTap: () => context.router.push(
        const CatalogRoute(),
        params: CatalogRouteParams(term: productList.title),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: productLists.length,
      itemBuilder: (context, index) {
        final productList = productLists[index];

        if (productList.type == HomeProductListType.highlight) {
          return _buildLargeProductCardListWidget(context, productList);
        }

        if (productList.type == HomeProductListType.normal) {
          return Column(
            children: [
              _buildProductListTitleWidget(context, productList),
              _buildMediumProductCardListWidget(context, productList),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
