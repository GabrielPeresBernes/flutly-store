import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/widgets/app_bottom_sheet_widget.dart';
import '../../../../shared/widgets/buttons/app_elevated_button_widget.dart';
import '../bloc/auth_cubit.dart';
import 'sign_up_form_widget.dart';

class SignUpBottomSheetWidget extends StatelessWidget {
  const SignUpBottomSheetWidget({
    super.key,
    required this.cubit,
  });

  final AuthCubit cubit;

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetWidget(
      title: 'auth.actions.create_account'.tr(),
      body: Column(
        children: [
          SignUpFormWidget(cubit: cubit),
          const SizedBox(height: 32),
          BlocBuilder<AuthCubit, AuthState>(
            bloc: cubit,
            builder: (context, state) {
              return AppElevatedButtonWidget(
                isLoading: state is AuthLoading,
                suffixIcon: state is AuthSigned ? 'check' : null,
                label: 'auth.actions.sign_up'.tr(),
                onPressed: cubit.signUpWithEmail,
              );
            },
          ),
        ],
      ),
    );
  }
}
