import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../extensions/text_theme_extension.dart';
import '../../theme/tokens/color_tokens.dart';
import '../app_icon_widget.dart';

class AppReactiveTextFieldWidget extends StatelessWidget {
  const AppReactiveTextFieldWidget({
    super.key,
    this.formControlName,
    this.formControl,
    this.label,
    this.prefixIcon,
    this.onPrefixPressed,
    this.suffixIcon,
    this.onSuffixPressed,
    this.hintText,
    this.controller,
    this.obscureText = false,
    this.validationMessages,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.textInputAction,
    this.maxLines = 1,
  }) : assert(
         formControlName != null || formControl != null,
         'Either formControlName or formControl must be provided',
       );

  final String? label;
  final String? prefixIcon;
  final VoidCallback? onPrefixPressed;
  final String? suffixIcon;
  final VoidCallback? onSuffixPressed;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? formControlName;
  final FormControl<String>? formControl;
  final bool obscureText;
  final Map<String, String Function(Object)>? validationMessages;
  final bool readOnly;
  final TextInputAction? textInputAction;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final formGroup = ReactiveForm.of(context) as FormGroup?;

    final control =
        formControl ?? formGroup?.control(formControlName!) as FormControl?;

    final isDisabled = control?.disabled ?? false;

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          if (label != null) Text(label!, style: context.bodyMedium),
          ReactiveTextField<String>(
            maxLines: maxLines,
            controller: controller,
            obscureText: obscureText,
            formControlName: formControlName,
            formControl: formControl,
            keyboardType: keyboardType,
            validationMessages: validationMessages,
            readOnly: readOnly,
            textInputAction: textInputAction,
            style: context.bodyMedium.copyWith(
              color: isDisabled ? AppColors.gray200 : AppColors.black,
            ),
            decoration: InputDecoration(
              hintStyle: context.bodyMedium.copyWith(
                color: isDisabled ? AppColors.gray200 : AppColors.gray100,
              ),
              prefixIcon: prefixIcon != null
                  ? GestureDetector(
                      onTap: onPrefixPressed,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 5),
                        child: AppIconWidget.svgAsset(
                          size: 20,
                          prefixIcon!,
                          color: isDisabled
                              ? AppColors.gray200
                              : AppColors.gray100,
                        ),
                      ),
                    )
                  : null,
              suffixIcon: suffixIcon != null
                  ? GestureDetector(
                      onTap: onSuffixPressed,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15, left: 5),
                        child: AppIconWidget.svgAsset(
                          size: 20,
                          suffixIcon!,
                          color: isDisabled
                              ? AppColors.gray200
                              : AppColors.gray100,
                        ),
                      ),
                    )
                  : null,
              hintText: hintText,
            ),
          ),
        ],
      ),
    );
  }
}
