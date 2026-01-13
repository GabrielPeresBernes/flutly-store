import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

import '../extensions/show_app_snack_bar_extension.dart';
import '../extensions/text_theme_extension.dart';
import '../theme/tokens/color_tokens.dart';

class AppSnackBarWidget extends StatefulWidget {
  const AppSnackBarWidget({
    super.key,
    required this.message,
    required this.type,
    required this.duration,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final SnackBarType type;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Duration duration;

  @override
  State<AppSnackBarWidget> createState() => _AppSnackBarWidgetState();
}

class _AppSnackBarWidgetState extends State<AppSnackBarWidget>
    with SingleTickerProviderStateMixin {
  var _progress = 0.0;

  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );

    _animationController
      ..addListener(() => setState(() => _progress = _progressAnimation.value))
      ..forward();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getColor() {
    switch (widget.type) {
      case SnackBarType.info:
        return AppColors.primary;
      case SnackBarType.success:
        return AppColors.secondary;
      case SnackBarType.error:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: _progress < 1.0 ? 1.0 : 0.0,
      curve: Curves.easeOut,
      child: Container(
        decoration: ShapeDecoration(
          color: AppColors.white,
          shape: SmoothRectangleBorder(
            borderRadius: SmoothBorderRadius(
              cornerRadius: 10,
              cornerSmoothing: .5,
            ),
          ),
          shadows: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(1),
        child: ClipSmoothRect(
          radius: SmoothBorderRadius(
            cornerRadius: 10,
            cornerSmoothing: .5,
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 1,
                left: 0,
                right: 0,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: LinearProgressIndicator(
                    minHeight: 2,
                    value: _progress,
                    backgroundColor: _getColor().withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.white,
                    ),
                  ),
                ),
              ),
              Container(
                height: 55,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: ShapeDecoration(
                  shape: SmoothRectangleBorder(
                    side: BorderSide(color: _getColor()),
                    borderRadius: SmoothBorderRadius(
                      cornerRadius: 10,
                      cornerSmoothing: .5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(widget.message, style: context.bodyMedium),
                    ),
                    if (widget.actionLabel != null && widget.onAction != null)
                      SizedBox(
                        height: 30,
                        child: OutlinedButton(
                          onPressed: widget.onAction,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.black,
                            side: const BorderSide(color: AppColors.gray200),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                          ),
                          child: Text(
                            widget.actionLabel!,
                            style: context.bodyMedium,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
