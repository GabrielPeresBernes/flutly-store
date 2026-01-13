import 'package:flutter/material.dart';

import '../../../../../shared/widgets/shimmer_place_holder_widget.dart';

class ProductLoadingWidget extends StatelessWidget {
  const ProductLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 34),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerPlaceHolderWidget(width: 80, height: 15),
              SizedBox(height: 16),
              ShimmerPlaceHolderWidget(height: 22, width: 200),
              SizedBox(height: 12),
              ShimmerPlaceHolderWidget(height: 15, width: 120),
              SizedBox(height: 24),
              ShimmerPlaceHolderWidget(height: 20, width: 180),
              SizedBox(height: 42),
              ShimmerPlaceHolderWidget(
                width: double.infinity,
                height: 48,
                borderRadius: 10,
              ),
              // const SizedBox(height: 40),
              // Container(
              //   height: 20,
              //   width: 100,
              //   decoration: BoxDecoration(
              //     color: AppColors.gray400,
              //     borderRadius: BorderRadius.circular(6),
              //   ),
              // ),
              // const SizedBox(height: 12),
              // Container(
              //   height: 60,
              //   decoration: BoxDecoration(
              //     color: AppColors.gray400,
              //     borderRadius: BorderRadius.circular(6),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
