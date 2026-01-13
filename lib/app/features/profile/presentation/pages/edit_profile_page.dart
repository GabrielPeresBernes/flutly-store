import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../../shared/bloc/app_cubit.dart';
import '../../../../shared/extensions/show_app_snack_bar_extension.dart';
import '../../../../shared/widgets/buttons/app_elevated_button_widget.dart';
import '../../../../shared/widgets/inputs/app_reactive_text_field_widget.dart';
import '../../../../shared/widgets/navigation_bars/app_top_navigation_bar.dart';
import '../bloc/profile_cubit.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();

    return Scaffold(
      extendBody: true,
      appBar: AppTopNavigationBar(title: 'profile.edit.title'.tr()),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileFailure) {
            context.showAppSnackBar(
              message: state.exception.message,
              type: SnackBarType.error,
            );
          }

          if (state is ProfileUpdated) {
            context.showAppSnackBar(
              message: 'profile.edit.updated_success'.tr(),
              type: SnackBarType.success,
            );
            context.read<AppCubit>().refreshUser();
          }
        },
        builder: (context, state) {
          final isLoading = state is ProfileLoading;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ReactiveForm(
              formGroup: cubit.editProfileForm,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  AppReactiveTextFieldWidget(
                    formControlName: 'name',
                    hintText: 'profile.fields.name'.tr(),
                    prefixIcon: 'profile',
                    readOnly: isLoading,
                    validationMessages: {
                      ValidationMessage.required: (_) =>
                          'profile.validation.name_required'.tr(),
                    },
                  ),
                  const SizedBox(height: 20),
                  AppReactiveTextFieldWidget(
                    formControlName: 'email',
                    hintText: 'profile.fields.email'.tr(),
                    prefixIcon: 'mail',
                    readOnly: true,
                  ),
                  const SizedBox(height: 20),
                  AppReactiveTextFieldWidget(
                    formControlName: 'currentPassword',
                    hintText: 'profile.fields.current_password'.tr(),
                    obscureText: true,
                    prefixIcon: 'lock_2',
                    readOnly: isLoading,
                    validationMessages: {
                      ValidationMessage.minLength: (_) =>
                          'profile.validation.password_min_length'.tr(),
                      'passwordChange': (_) =>
                          'profile.validation.password_change_current'.tr(),
                    },
                  ),
                  const SizedBox(height: 20),
                  AppReactiveTextFieldWidget(
                    formControlName: 'newPassword',
                    hintText: 'profile.fields.new_password'.tr(),
                    obscureText: true,
                    prefixIcon: 'lock_2',
                    readOnly: isLoading,
                    validationMessages: {
                      ValidationMessage.minLength: (_) =>
                          'profile.validation.password_min_length'.tr(),
                      'passwordChange': (_) =>
                          'profile.validation.password_change_new'.tr(),
                    },
                  ),
                  const SizedBox(height: 20),
                  AppReactiveTextFieldWidget(
                    formControlName: 'confirmNewPassword',
                    hintText: 'profile.fields.confirm_new_password'.tr(),
                    obscureText: true,
                    prefixIcon: 'lock_2',
                    readOnly: isLoading,
                    validationMessages: {
                      ValidationMessage.mustMatch: (_) =>
                          'profile.validation.passwords_no_match'.tr(),
                    },
                  ),
                  const SizedBox(height: 30),
                  AppElevatedButtonWidget(
                    label: 'profile.actions.save'.tr(),
                    onPressed: cubit.updateProfile,
                    isLoading: isLoading,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
