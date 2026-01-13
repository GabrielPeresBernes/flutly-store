import 'package:flutter/material.dart';

import '../../../../../shared/widgets/shimmer_place_holder_widget.dart';

class ShippingLoadingWidget extends StatelessWidget {
  const ShippingLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 1,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, index) {
            return const ShimmerPlaceHolderWidget(
              height: 72,
              width: double.infinity,
              borderRadius: 10,
            );
          },
        ),
      ],
    );
  }
}
