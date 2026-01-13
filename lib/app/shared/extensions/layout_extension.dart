import 'package:flutter/material.dart';

/// Layout-related extensions for BuildContext
extension LayoutExtension on BuildContext {
  double get bottomBarOffset => MediaQuery.of(this).padding.bottom + 20;

  double get bottomBarHeight => MediaQuery.of(this).padding.bottom;

  double get keyboardHeight => MediaQuery.of(this).viewInsets.bottom;
}
