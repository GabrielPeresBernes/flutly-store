import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

import '../theme/tokens/color_tokens.dart';
import '../widgets/main_scaffold.dart';

extension ShowAppBottomSheetExtension on BuildContext {
  /// Displays a modal bottom sheet with app styling.
  Future<void> showAppBottomSheet({
    /// The widget to display inside the bottom sheet.
    ///
    /// [AppBottomSheetWidget] is recommended for consistent styling.
    required Widget child,

    /// Whether the bottom sheet can be dismissed by tapping outside or
    /// swiping down.
    bool isDismissible = true,
  }) {
    return showModalBottomSheet<void>(
      context: rootScaffoldKey.currentContext ?? this,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      backgroundColor: AppColors.white,
      isScrollControlled: true,
      shape: const SmoothRectangleBorder(
        borderRadius: SmoothBorderRadius.only(
          topLeft: SmoothRadius(cornerRadius: 30, cornerSmoothing: .5),
          topRight: SmoothRadius(cornerRadius: 30, cornerSmoothing: .5),
        ),
      ),
      builder: (_) => child,
    );
  }
}
