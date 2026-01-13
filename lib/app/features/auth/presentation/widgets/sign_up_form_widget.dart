import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../shared/widgets/inputs/app_reactive_text_field_widget.dart';
import '../bloc/auth_cubit.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({
    super.key,
    required this.cubit,
  });

  final AuthCubit cubit;

  @override
  State<SignUpFormWidget> createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: widget.cubit.signUpForm,
      child: Column(
        children: [
          AppReactiveTextFieldWidget(
            formControlName: 'name',
            hintText: 'auth.fields.name'.tr(),
            prefixIcon: 'profile',
            validationMessages: {
              ValidationMessage.required: (_) =>
                  'auth.validation.name_required'.tr(),
            },
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 15),
          AppReactiveTextFieldWidget(
            formControlName: 'email',
            hintText: 'auth.fields.email'.tr(),
            prefixIcon: 'mail',
            validationMessages: {
              ValidationMessage.required: (_) =>
                  'auth.validation.email_required'.tr(),
              ValidationMessage.email: (_) =>
                  'auth.validation.email_invalid'.tr(),
            },
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 15),
          AppReactiveTextFieldWidget(
            formControlName: 'password',
            hintText: 'auth.fields.password'.tr(),
            prefixIcon: 'lock_2',
            obscureText: !_showPassword,
            suffixIcon: _showPassword ? 'eye_off' : 'eye',
            onSuffixPressed: () {
              setState(() => _showPassword = !_showPassword);
            },
            validationMessages: {
              ValidationMessage.required: (_) =>
                  'auth.validation.password_required'.tr(),
              ValidationMessage.minLength: (error) {
                final requiredLength =
                    (error as Map<String, Object>)['requiredLength'] as int?;

                return 'auth.validation.password_min_length'.tr(
                  namedArgs: {
                    'count': requiredLength?.toString() ?? '0',
                  },
                );
              },
            },
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 15),
          AppReactiveTextFieldWidget(
            formControlName: 'confirmPassword',
            hintText: 'auth.fields.confirm_password'.tr(),
            prefixIcon: 'lock_2',
            obscureText: true,
            validationMessages: {
              ValidationMessage.mustMatch: (_) =>
                  'auth.validation.passwords_no_match'.tr(),
            },
          ),
        ],
      ),
    );
  }
}
