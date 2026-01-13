import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../shared/widgets/inputs/app_reactive_text_field_widget.dart';
import '../bloc/auth_cubit.dart';

class SignInFormWidget extends StatefulWidget {
  const SignInFormWidget({super.key});

  @override
  State<SignInFormWidget> createState() => _SignInFormWidgetState();
}

class _SignInFormWidgetState extends State<SignInFormWidget> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return ReactiveForm(
      formGroup: context.read<AuthCubit>().signInForm,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppReactiveTextFieldWidget(
            formControlName: 'email',
            hintText: 'auth.fields.email'.tr(),
            prefixIcon: 'mail',
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20),
          AppReactiveTextFieldWidget(
            formControlName: 'password',
            hintText: 'auth.fields.password'.tr(),
            prefixIcon: 'lock_2',
            suffixIcon: _showPassword ? 'eye_off' : 'eye',
            obscureText: !_showPassword,
            onSuffixPressed: () {
              setState(() => _showPassword = !_showPassword);
            },
          ),
        ],
      ),
    );
  }
}
