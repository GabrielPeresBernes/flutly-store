import 'package:flutter/material.dart';

import '../../../../shared/widgets/shimmer_place_holder_widget.dart';

class CartSummaryLoadingWidget extends StatelessWidget {
  const CartSummaryLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ShimmerPlaceHolderWidget(width: 80, height: 12),
          ShimmerPlaceHolderWidget(width: 90, height: 16),
        ],
      ),
    );
  }
}
