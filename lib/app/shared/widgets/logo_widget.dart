import 'package:flutter/material.dart';

import '../extensions/text_theme_extension.dart';
import '../theme/tokens/color_tokens.dart';
import 'app_icon_widget.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AppIconWidget.svgAsset('logo', size: 22),
        const SizedBox(width: 8),
        Text(
          'Flutly',
          style: context.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          'Store',
          style: context.bodyLarge.copyWith(
            fontWeight: FontWeight.w300,
            fontSize: 19,
            color: AppColors.gray100,
          ),
        ),
      ],
    );
  }
}
