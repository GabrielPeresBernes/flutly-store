import 'package:flutter/material.dart';

import '../errors/app_exception.dart';
import '../extensions/text_theme_extension.dart';
import '../theme/tokens/color_tokens.dart';
import 'app_icon_widget.dart';
import 'buttons/app_outlined_button_widget.dart';

class ErrorMessageWidget extends StatelessWidget {
  const ErrorMessageWidget({
    super.key,
    required this.error,
    this.onRetry,
    this.compact = false,
  });

  final AppException error;
  final VoidCallback? onRetry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: compact ? 50 : 80,
          height: compact ? 50 : 80,
          alignment: Alignment.center,
          decoration: compact
              ? null
              : const BoxDecoration(
                  color: AppColors.gray400,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
          child: const AppIconWidget.svgAsset('alert_triangle', size: 50),
        ),
        if (!compact)
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Text(
              'Something went wrong',
              style: context.labelLarge,
              textAlign: TextAlign.center,
            ),
          ),
        SizedBox(height: compact ? 20 : 30),
        Text(
          error.message,
          style: context.bodyMedium,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: compact ? 20 : 40),
        if (!compact)
          Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.gray400),
                bottom: BorderSide(color: AppColors.gray400),
              ),
            ),
            child: ExpansionTile(
              title: Text("Debug Info", style: context.bodyMedium),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    error.details.toString(),
                    style: context.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        if (onRetry != null)
          Padding(
            padding: EdgeInsets.only(
              top: compact ? 20 : 50,
              bottom: 130,
            ),
            child: AppOutlinedButtonWidget(
              label: 'Try Again',
              onPressed: onRetry!,
            ),
          ),
      ],
    );
  }
}
