import 'package:flutter/material.dart';

import '../../extensions/text_theme_extension.dart';
import '../../theme/tokens/color_tokens.dart';

class ProductListTitleWidget extends StatelessWidget {
  const ProductListTitleWidget({
    super.key,
    required this.title,
    required this.onTap,
  });

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: context.bodyLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: onTap,
          child: SizedBox(
            width: 48,
            child: Text(
              'See All',
              style: context.bodyMedium.copyWith(
                color: AppColors.gray100,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
