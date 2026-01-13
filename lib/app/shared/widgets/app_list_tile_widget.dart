import 'package:flutter/material.dart';

import '../theme/tokens/color_tokens.dart';
import 'app_icon_widget.dart';

class AppListTileWidget extends StatefulWidget {
  const AppListTileWidget({
    super.key,
    required this.child,
    this.isSelected = false,
    this.actionIcon,
    this.onActionPressed,
    this.onTap,
  });

  final Widget child;
  final bool isSelected;
  final String? actionIcon;
  final VoidCallback? onActionPressed;
  final VoidCallback? onTap;

  @override
  State<AppListTileWidget> createState() => _AppListTileWidgetState();
}

class _AppListTileWidgetState extends State<AppListTileWidget> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value || widget.isSelected) {
      return;
    }

    if (value == false) {
      Future.delayed(
        const Duration(milliseconds: 150),
        () => setState(() => _pressed = false),
      );
    } else {
      setState(() => _pressed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasAction = widget.actionIcon != null;

    return AnimatedScale(
      scale: _pressed ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (_) => _setPressed(true),
            onTapUp: (_) {
              _setPressed(false);
              widget.onTap?.call();
            },
            onTapCancel: () => _setPressed(false),
            child: AnimatedContainer(
              width: double.infinity,
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? const Color(0xFFF7FAFD).withValues(alpha: 0.9)
                    : Colors.white,
                border: Border.all(
                  color: widget.isSelected
                      ? AppColors.primary
                      : AppColors.gray200,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 15, hasAction ? 55 : 15, 15),
                child: widget.child,
              ),
            ),
          ),
          if (hasAction)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: IconButton(
                onPressed: widget.onActionPressed,
                visualDensity: VisualDensity.comfortable,
                icon: AppIconWidget.svgAsset(widget.actionIcon!, size: 20),
              ),
            ),
        ],
      ),
    );
  }
}
