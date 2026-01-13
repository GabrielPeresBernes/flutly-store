import 'package:flutter/material.dart';

import '../../../../../shared/theme/tokens/color_tokens.dart';
import '../../../../../shared/widgets/shimmer_place_holder_widget.dart';
import '../../../utils/catalog_utils.dart';

final _productCardColor = AppColors.gray200.withValues(alpha: .2);

class CatalogInitialLoadingWidget extends StatelessWidget {
  const CatalogInitialLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final catalogUtils = CatalogUtils(context);

    return Column(
      spacing: catalogUtils.axisSpacing,
      children: List.generate(
        3,
        (_) => AspectRatio(
          aspectRatio: catalogUtils.rowAspectRatio,
          child: Row(
            spacing: catalogUtils.axisSpacing,
            children: [
              Expanded(
                child: ShimmerPlaceHolderWidget(
                  width: double.infinity,
                  height: double.infinity,
                  color: _productCardColor,
                  borderRadius: 10,
                ),
              ),
              Expanded(
                child: ShimmerPlaceHolderWidget(
                  width: double.infinity,
                  height: double.infinity,
                  color: _productCardColor,
                  borderRadius: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
