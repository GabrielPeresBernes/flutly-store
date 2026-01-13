import 'package:flutter/material.dart';

import '../../../../shared/extensions/text_theme_extension.dart';
import '../../../../shared/theme/tokens/color_tokens.dart';

class ProfileSectionWidget extends StatelessWidget {
  const ProfileSectionWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      child: Text(
        title,
        style: context.bodyMedium.copyWith(color: AppColors.gray100),
      ),
    );
  }
}
