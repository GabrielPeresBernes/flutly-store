import 'package:flutter/material.dart';

import '../widgets/app_snack_bar_widget.dart';

enum SnackBarType {
  info,
  success,
  error,
}

extension ShowAppSnackBarExtension on BuildContext {
  /// Displays app snack bar with given message and type
  void showAppSnackBar({
    required String message,
    required SnackBarType type,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) => ScaffoldMessenger.of(this).showSnackBar(
    SnackBar(
      content: AppSnackBarWidget(
        message: message,
        type: type,
        actionLabel: actionLabel,
        onAction: onAction,
        duration: duration,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      duration: duration,
      padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
      margin: EdgeInsets.zero,
      animation: CurvedAnimation(
        parent: AnimationController(
          vsync: ScaffoldMessenger.of(this),
          duration: const Duration(milliseconds: 200),
        ),
        curve: Curves.easeIn,
      ),
    ),
  );
}
