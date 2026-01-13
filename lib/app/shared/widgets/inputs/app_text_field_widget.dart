import 'package:flutter/material.dart';

import '../../extensions/text_theme_extension.dart';
import '../../theme/tokens/color_tokens.dart';
import '../app_icon_widget.dart';

class AppTextFieldWidget extends StatelessWidget {
  const AppTextFieldWidget({
    super.key,
    this.prefixIcon,
    this.onPrefixPressed,
    this.suffixIcon,
    this.onSuffixPressed,
    this.hintText,
    this.controller,
    this.onSubmitted,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
  });

  final String? prefixIcon;
  final VoidCallback? onPrefixPressed;
  final String? suffixIcon;
  final VoidCallback? onSuffixPressed;
  final String? hintText;
  final TextEditingController? controller;
  final void Function(String value)? onSubmitted;
  final void Function(String value)? onChanged;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: context.bodyMedium,
      decoration: InputDecoration(
        hintStyle: context.bodyMedium.copyWith(color: AppColors.gray100),
        prefixIcon: prefixIcon != null
            ? GestureDetector(
                onTap: onPrefixPressed,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 5),
                  child: AppIconWidget.svgAsset(
                    size: 20,
                    prefixIcon!,
                    color: AppColors.gray100,
                  ),
                ),
              )
            : null,
        suffixIcon: suffixIcon != null
            ? GestureDetector(
                onTap: onSuffixPressed,
                child: Padding(
                  padding: const EdgeInsets.only(right: 15, left: 5),
                  child: AppIconWidget.svgAsset(
                    size: 20,
                    suffixIcon!,
                    color: AppColors.gray100,
                  ),
                ),
              )
            : null,
        hintText: hintText,
      ),
    );
  }
}
