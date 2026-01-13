import 'package:flutter/material.dart';

import '../extensions/layout_extension.dart';
import '../extensions/text_theme_extension.dart';
import 'app_icon_widget.dart';

class AppBottomSheetWidget extends StatelessWidget {
  const AppBottomSheetWidget({
    super.key,
    required this.body,
    required this.title,
    this.showTrailing = true,
    this.trailingIcon,
    this.onTrailingPressed,
    this.spacing = 0,
  });

  final Widget body;
  final String title;
  final double spacing;
  final bool showTrailing;
  final String? trailingIcon;
  final VoidCallback? onTrailingPressed;

  @override
  Widget build(BuildContext context) {
    final bottomHeight = context.keyboardHeight > 0
        ? context.keyboardHeight
        : context.bottomBarHeight;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, bottomHeight + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: spacing,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title, style: context.headlineMedium),
                const Spacer(),
                if (showTrailing)
                  IconButton(
                    icon: AppIconWidget.svgAsset(
                      trailingIcon ?? 'close',
                      size: 24,
                    ),
                    onPressed:
                        onTrailingPressed ?? () => Navigator.pop(context),
                  ),
              ],
            ),
            const SizedBox(height: 25),
            body,
          ],
        ),
      ),
    );
  }
}
