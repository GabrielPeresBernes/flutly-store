import 'package:flutter/material.dart';

import '../../../../../shared/widgets/shimmer_place_holder_widget.dart';

class AddressLoadingWidget extends StatelessWidget {
  const AddressLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 2,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, index) {
            return const ShimmerPlaceHolderWidget(
              height: 72,
              width: double.infinity,
              borderRadius: 10,
            );
          },
        ),
        const SizedBox(height: 20),
        const ShimmerPlaceHolderWidget(height: 18, width: 100),
        const SizedBox(height: 16),
      ],
    );
  }
}
