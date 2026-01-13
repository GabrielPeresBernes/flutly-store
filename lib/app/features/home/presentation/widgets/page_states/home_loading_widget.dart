import 'package:flutter/widgets.dart';

import '../../../../../shared/theme/tokens/color_tokens.dart';
import '../../../../../shared/widgets/shimmer_place_holder_widget.dart';

class HomeLoadingWidget extends StatelessWidget {
  const HomeLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2.2,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              separatorBuilder: (context, index) => const SizedBox(width: 15),
              itemBuilder: (context, index) => ShimmerPlaceHolderWidget(
                width: 330,
                height: 180,
                color: AppColors.gray200.withValues(alpha: .2),
                borderRadius: 10,
              ),
            ),
          ),
          ...List.generate(
            2,
            (_) => Column(
              children: [
                const SizedBox(height: 26),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      ShimmerPlaceHolderWidget(
                        width: 140,
                        height: 16,
                        color: AppColors.gray200.withValues(alpha: .2),
                      ),
                      const Spacer(),
                      ShimmerPlaceHolderWidget(
                        width: 60,
                        height: 16,
                        color: AppColors.gray200.withValues(alpha: .2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                AspectRatio(
                  aspectRatio: 1.7,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 15),
                    itemBuilder: (context, index) => ShimmerPlaceHolderWidget(
                      width: 155,
                      height: 231,
                      color: AppColors.gray200.withValues(alpha: .2),
                      borderRadius: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
