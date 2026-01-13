import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../theme/tokens/color_tokens.dart';

class ShimmerPlaceHolderWidget extends StatelessWidget {
  const ShimmerPlaceHolderWidget({
    super.key,
    this.width,
    this.height,
    this.color = AppColors.gray400,
    this.borderRadius = 4,
  });

  final Color color;
  final double? width;
  final double? height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
