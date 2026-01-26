import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/router.dart';
import '../../../../shared/extensions/text_theme_extension.dart';
import '../../../../shared/theme/tokens/color_tokens.dart';
import '../../../../shared/widgets/app_icon_widget.dart';
import '../../../../shared/widgets/app_network_image_widget.dart';
import '../../../../shared/widgets/products/product_hero_widget.dart';
import '../../../product/product.dart';
import '../../domain/entities/cart_product.dart';
import '../bloc/cart/cart_cubit.dart';
import 'cart_item_quantity_widget.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({
    super.key,
    required this.product,
  });

  final CartProduct product;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartCubit>();
    final uniqueTag = UniqueKey().toString();

    return SizedBox(
      height: 87,
      child: Stack(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => context.router.push(
                  const ProductRoute(),
                  params: ProductRouteParams(
                    id: product.id,
                    title: product.name,
                    thumbnail: product.thumbnail,
                    tag: uniqueTag,
                  ),
                ),
                child: ProductHeroWidget(
                  tag: uniqueTag,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    width: 87,
                    height: 87,
                    decoration: BoxDecoration(
                      color: AppColors.gray400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: AppNetworkImageWidget(product.thumbnail),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: context.bodyLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'cart.summary.price_usd'.tr(
                        namedArgs: {'price': product.price.toString()},
                      ),
                      style: context.labelMedium,
                    ),
                    const Spacer(),
                    BlocBuilder<CartCubit, CartState>(
                      buildWhen: (previous, current) =>
                          (current is CartUpdating &&
                              current.productId == product.id) ||
                          (current is CartUpdated &&
                              current.product.id == product.id) ||
                          (current is CartUpdateFailure &&
                              current.productId == product.id),
                      builder: (context, state) {
                        final isUpdating = state is CartUpdating;

                        final updatedQuantity =
                            state is CartUpdated &&
                                state.product.id == product.id
                            ? state.product.quantity
                            : product.quantity;

                        return CartItemQuantityWidget(
                          onIncrement: () => cubit.incrementProduct(product),
                          onDecrement: updatedQuantity > 1
                              ? () => cubit.decrementProduct(product)
                              : null,
                          isLoading: isUpdating,
                          quantity: updatedQuantity,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            bottom: -6,
            child: IconButton(
              onPressed: () => cubit.removeProduct(product),
              icon: const AppIconWidget.svgAsset('trash', size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
