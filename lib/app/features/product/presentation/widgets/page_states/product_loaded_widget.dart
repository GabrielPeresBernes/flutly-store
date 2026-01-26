import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/extensions/layout_extension.dart';
import '../../../../../shared/extensions/show_app_bottom_sheet_extension.dart';
import '../../../../../shared/extensions/show_app_snack_bar_extension.dart';
import '../../../../../shared/extensions/text_theme_extension.dart';
import '../../../../../shared/theme/tokens/color_tokens.dart';
import '../../../../../shared/widgets/buttons/app_elevated_button_widget.dart';
import '../../../../cart/presentation/bloc/cart/cart_cubit.dart';
import '../../../domain/entities/product_extended.dart';
import '../../bloc/product/product_cubit.dart';
import '../../bloc/recommendation/product_recommendation_cubit.dart';
import '../product_added_bottom_sheet_widget.dart';
import '../product_rating_widget.dart';
import 'recommendation_failure_widget.dart';
import 'recommendation_loaded_widget.dart';
import 'recommendation_loading_widget.dart';

class ProductLoadedWidget extends StatelessWidget {
  const ProductLoadedWidget({
    super.key,
    required this.product,
  });

  final ProductExtended product;

  @override
  Widget build(BuildContext context) {
    final productCubit = context.read<ProductCubit>();

    return BlocListener<CartCubit, CartState>(
      listener: (context, state) async {
        if (state is CartUpdated && state.uiID == productCubit.instanceId) {
          return context.showAppBottomSheet(
            child: ProductAddedBottomSheetWidget(product: product),
          );
        }

        if (state is CartUpdateFailure &&
            state.uiID == productCubit.instanceId) {
          context.showAppSnackBar(
            message: state.exception.message,
            type: SnackBarType.error,
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.brand,
                  style: context.labelLarge.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(product.title, style: context.headlineLarge),
                const SizedBox(height: 6),
                ProductRatingWidget(product: product),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        'product.pricing.price_usd'.tr(
                          namedArgs: {'price': product.price.toString()},
                        ),
                        style: context.labelLarge,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 20,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'product.pricing.discount'.tr(
                          namedArgs: {
                            'percent': product.discountPercentage
                                .round()
                                .toString(),
                          },
                        ),
                        style: context.labelSmall.copyWith(
                          fontSize: 10,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                AppElevatedButtonWidget(
                  label: 'product.actions.add_to_cart'.tr(),
                  onPressed: () => context.read<CartCubit>().addProduct(
                    id: product.id,
                    thumbnail: product.thumbnail,
                    name: product.title,
                    price: product.price,
                    uiID: productCubit.instanceId,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'product.labels.description'.tr(),
                  style: context.labelLarge,
                ),
                const SizedBox(height: 12),
                Text(product.description, style: context.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(24, 28, 24, context.bottomBarOffset),
            decoration: const BoxDecoration(color: AppColors.gray400),
            child:
                BlocBuilder<
                  ProductRecommendationCubit,
                  ProductRecommendationState
                >(
                  builder: (context, state) {
                    return switch (state) {
                      ProductRecommendationLoading() ||
                      ProductRecommendationInitial() =>
                        const RecommendationLoadingWidget(),

                      ProductRecommendationFailure(:final exception) =>
                        RecommendationFailureWidget(
                          exception: exception,
                          productId: product.id,
                        ),

                      ProductRecommendationLoaded(:final products) =>
                        RecommendationLoadedWidget(products: products),
                    };
                  },
                ),
          ),
        ],
      ),
    );
  }
}
