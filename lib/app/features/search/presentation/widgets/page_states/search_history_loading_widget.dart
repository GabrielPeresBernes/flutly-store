import 'package:flutter/widgets.dart';

import '../../../../../shared/widgets/shimmer_place_holder_widget.dart';

class SearchHistoryLoadingWidget extends StatelessWidget {
  const SearchHistoryLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ShimmerPlaceHolderWidget(width: 140, height: 18),
        const SizedBox(height: 26),
        ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return const Row(
              children: [
                ShimmerPlaceHolderWidget(width: 20, height: 20),
                SizedBox(width: 10),
                ShimmerPlaceHolderWidget(width: 180, height: 20),
                Spacer(),
                ShimmerPlaceHolderWidget(width: 12, height: 20),
                SizedBox(width: 8),
              ],
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 28),
        ),
        const SizedBox(height: 38),
      ],
    );
  }
}
