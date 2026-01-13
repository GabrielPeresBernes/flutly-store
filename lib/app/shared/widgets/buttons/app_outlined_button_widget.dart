import 'package:flutter/material.dart';

import '../../extensions/text_theme_extension.dart';
import '../../theme/tokens/color_tokens.dart';
import '../app_icon_widget.dart';

class AppOutlinedButtonWidget extends StatelessWidget {
  const AppOutlinedButtonWidget({
    super.key,
    this.onPressed,
    this.label,
    this.prefixIcon,
    this.suffixIcon,
    this.style,
  }) : height = 40,
       width = null;

  const AppOutlinedButtonWidget.icon({
    super.key,
    this.onPressed,
    this.style,
    required String icon,
  }) : label = null,
       prefixIcon = icon,
       suffixIcon = null,
       height = 50,
       width = 50;

  final String? label;
  final VoidCallback? onPressed;
  final String? prefixIcon;
  final String? suffixIcon;
  final ButtonStyle? style;
  final double height;
  final double? width;

  Color _getForegroundColor(BuildContext context) =>
      style?.foregroundColor?.resolve({
        if (onPressed == null) WidgetState.disabled else WidgetState.focused,
      }) ??
      Theme.of(context).outlinedButtonTheme.style?.foregroundColor?.resolve({
        if (onPressed == null) WidgetState.disabled else WidgetState.focused,
      }) ??
      AppColors.black;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = _getForegroundColor(context);

    return SizedBox(
      height: height,
      width: width,
      child: OutlinedButton(
        onPressed: onPressed,
        style: style,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            if (prefixIcon != null)
              AppIconWidget.svgAsset(
                prefixIcon!,
                size: 20,
                color: foregroundColor,
              ),
            if (label != null)
              Text(
                label!,
                style: context.bodyMedium.copyWith(color: foregroundColor),
              ),
            if (suffixIcon != null)
              AppIconWidget.svgAsset(
                suffixIcon!,
                size: 20,
                color: foregroundColor,
              ),
          ],
        ),
      ),
    );
  }
}
