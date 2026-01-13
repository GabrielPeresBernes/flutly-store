import 'package:flutter/material.dart';

import '../../../../shared/theme/tokens/color_tokens.dart';
import '../../../../shared/widgets/app_icon_widget.dart';

class SocialSignInButtonWidget extends StatelessWidget {
  const SocialSignInButtonWidget({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final String icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Material(
        color: AppColors.white,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            width: 52,
            height: 52,
            padding: const EdgeInsets.all(16),
            child: AppIconWidget.svgAsset(icon, size: 20),
          ),
        ),
      ),
    );
  }
}
