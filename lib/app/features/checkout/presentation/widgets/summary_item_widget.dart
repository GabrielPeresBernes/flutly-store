import 'package:flutter/material.dart';

import '../../../../shared/extensions/text_theme_extension.dart';
import '../../../../shared/theme/tokens/color_tokens.dart';

class SummaryItemWidget extends StatelessWidget {
  const SummaryItemWidget({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.bodyMedium.copyWith(
            color: AppColors.gray100,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
