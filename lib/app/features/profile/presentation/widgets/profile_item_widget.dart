import 'package:flutter/material.dart';

import '../../../../shared/extensions/text_theme_extension.dart';
import '../../../../shared/theme/tokens/color_tokens.dart';

class ProfileItemWidget extends StatelessWidget {
  const ProfileItemWidget({
    super.key,
    required this.title,
    required this.onTap,
    this.isLoading = false,
  });

  final String title;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.gray300),
          ),
        ),
        child: Row(
          children: [
            Text(title, style: context.bodyMedium),
            const SizedBox(width: 16),
            if (isLoading)
              const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                  color: AppColors.black,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
