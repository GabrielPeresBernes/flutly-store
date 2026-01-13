import 'package:flutter/material.dart';

import '../../../../../shared/widgets/shimmer_place_holder_widget.dart';

class SearchPopularProductsLoadingWidget extends StatelessWidget {
  const SearchPopularProductsLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ShimmerPlaceHolderWidget(width: 140, height: 18),
        const SizedBox(height: 20),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerPlaceHolderWidget(width: 78, height: 78),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 6),
                    ShimmerPlaceHolderWidget(width: 160, height: 14),
                    SizedBox(height: 8),
                    ShimmerPlaceHolderWidget(width: 85, height: 12),
                    SizedBox(height: 18),
                    ShimmerPlaceHolderWidget(width: 50, height: 14),
                  ],
                ),
              ],
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 20),
        ),
      ],
    );
  }
}
