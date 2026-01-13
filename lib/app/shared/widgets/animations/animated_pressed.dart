import 'package:flutter/material.dart';

class AnimatedPressed extends StatefulWidget {
  const AnimatedPressed({
    super.key,
    required this.child,
    this.onTap,
  });

  final Widget child;
  final VoidCallback? onTap;

  @override
  State<AnimatedPressed> createState() => _AnimatedPressedState();
}

class _AnimatedPressedState extends State<AnimatedPressed> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) {
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
    return AnimatedScale(
      scale: _pressed ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) {
          _setPressed(false);
          widget.onTap?.call();
        },
        onTapCancel: () => _setPressed(false),
        child: widget.child,
      ),
    );
  }
}
