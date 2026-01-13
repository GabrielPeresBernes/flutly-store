import 'package:flutter/material.dart';

import '../../../../../shared/theme/tokens/color_tokens.dart';
import '../../../../../shared/widgets/shimmer_place_holder_widget.dart';

class PopularProductsLoadingWidget extends StatelessWidget {
  const PopularProductsLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerPlaceHolderWidget(
              color: AppColors.gray200.withValues(alpha: .2),
              width: 120,
              height: 16,
            ),
            ShimmerPlaceHolderWidget(
              color: AppColors.gray200.withValues(alpha: .2),
              width: 50,
              height: 16,
            ),
          ],
        ),
        const SizedBox(height: 22),
        SizedBox(
          height: 232,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return ShimmerPlaceHolderWidget(
                color: AppColors.gray200.withValues(alpha: .2),
                width: 156,
                height: 232,
                borderRadius: 10,
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemCount: 3,
          ),
        ),
      ],
    );
  }
}
