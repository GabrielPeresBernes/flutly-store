import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/theme/tokens/color_tokens.dart';
import '../../../../shared/widgets/app_network_image_widget.dart';
import '../../domain/entities/product_extended.dart';
import '../bloc/product/product_cubit.dart';

class ProductImageCarouselWidget extends StatelessWidget {
  const ProductImageCarouselWidget({
    super.key,
    required this.thumbnail,
    required this.cubit,
  });

  final String thumbnail;
  final ProductCubit cubit;

  Widget _buildPlaceholderCarousel(String? highResImage) {
    final hasHighResImage = highResImage != null && highResImage.isNotEmpty;

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 2,
      separatorBuilder: (context, index) => const SizedBox(width: 16),
      itemBuilder: (context, index) {
        if (index == 0) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
            width: hasHighResImage
                ? MediaQuery.of(context).size.width - 40
                : 285,
            decoration: ShapeDecoration(
              color: AppColors.gray400,
              shape: SmoothRectangleBorder(
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 10,
                  cornerSmoothing: .5,
                ),
              ),
            ),
            child: AppNetworkImageWidget(
              highResImage ?? thumbnail,
              fit: BoxFit.contain,
              placeholderImageUrl: thumbnail,
            ),
          );
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          width: 285,
          height: double.infinity,
          decoration: ShapeDecoration(
            color: hasHighResImage ? Colors.white : AppColors.gray400,
            shape: SmoothRectangleBorder(
              borderRadius: SmoothBorderRadius(
                cornerRadius: 10,
                cornerSmoothing: .5,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFullCarousel(ProductExtended product) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: product.images.length,
      separatorBuilder: (context, index) => const SizedBox(width: 16),
      itemBuilder: (context, index) => Container(
        width: 285,
        decoration: ShapeDecoration(
          color: AppColors.gray400,
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
              cornerRadius: 10,
              cornerSmoothing: .5,
            ),
          ),
        ),
        child: AppNetworkImageWidget(
          product.images[index],
          fit: BoxFit.contain,
          placeholderImageUrl: index == 0 ? thumbnail : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is ProductFailure) {
          return const SizedBox.shrink();
        }

        return AspectRatio(
          aspectRatio: 1.05,
          child: state is ProductLoaded
              ? state.product.images.length == 1
                    ? _buildPlaceholderCarousel(state.product.images[0])
                    : _buildFullCarousel(state.product)
              : _buildPlaceholderCarousel(null),
        );
      },
    );
  }
}
