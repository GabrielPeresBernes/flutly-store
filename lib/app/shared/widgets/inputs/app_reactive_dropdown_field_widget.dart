import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../extensions/text_theme_extension.dart';
import '../../theme/tokens/color_tokens.dart';

class AppReactiveDropdownFieldWidget extends StatelessWidget {
  const AppReactiveDropdownFieldWidget({
    super.key,
    required this.formControlName,
    required this.items,
    this.label,
    this.hintText,
  });

  final String formControlName;
  final List<DropdownMenuItem<dynamic>> items;
  final String? label;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        if (label != null) Text(label!, style: context.bodyMedium),
        ReactiveDropdownField(
          formControlName: formControlName,
          borderRadius: const SmoothBorderRadius.all(
            SmoothRadius(cornerRadius: 10, cornerSmoothing: .5),
          ),
          style: context.bodyMedium,
          hint: hintText != null
              ? Text(
                  hintText!,
                  style: context.bodyMedium.copyWith(
                    color: AppColors.gray100,
                  ),
                )
              : null,
          items: items,
        ),
      ],
    );
  }
}
