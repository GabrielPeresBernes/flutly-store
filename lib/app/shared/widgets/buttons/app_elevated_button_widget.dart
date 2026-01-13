import 'package:flutter/material.dart';

import '../../extensions/text_theme_extension.dart';
import '../../theme/tokens/color_tokens.dart';
import '../app_icon_widget.dart';

class AppElevatedButtonWidget extends StatelessWidget {
  const AppElevatedButtonWidget({
    super.key,
    required this.label,
    required this.onPressed,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.textAlign = TextAlign.center,
  });

  final String label;
  final VoidCallback onPressed;
  final String? prefixIcon;
  final String? suffixIcon;
  final bool isLoading;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (prefixIcon != null)
              Align(
                alignment: Alignment.centerLeft,
                child: AppIconWidget.svgAsset(
                  prefixIcon!,
                  size: 25,
                  color: AppColors.white,
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    textAlign: textAlign,
                    style: textAlign == TextAlign.center
                        ? context.labelLarge.copyWith(color: AppColors.white)
                        : context.labelMedium.copyWith(color: AppColors.white),
                  ),
                ),
              ],
            ),
            if (suffixIcon != null && !isLoading)
              Align(
                alignment: Alignment.centerRight,
                child: AppIconWidget.svgAsset(
                  suffixIcon!,
                  size: 25,
                  color: AppColors.white,
                ),
              ),
            if (isLoading)
              const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
