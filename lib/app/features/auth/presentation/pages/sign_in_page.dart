import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/router/router.dart';
import '../../../../shared/bloc/app_cubit.dart';
import '../../../../shared/extensions/show_app_bottom_sheet_extension.dart';
import '../../../../shared/extensions/show_app_snack_bar_extension.dart';
import '../../../../shared/extensions/text_theme_extension.dart';
import '../../../../shared/theme/tokens/color_tokens.dart';
import '../../../../shared/widgets/app_icon_widget.dart';
import '../../../../shared/widgets/buttons/app_elevated_button_widget.dart';
import '../../auth.dart';
import '../widgets/social_sign_in_button_widget.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({
    super.key,
    this.isIOSOverrideForTesting,
  });

  final bool? isIOSOverrideForTesting;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is AuthFailure) {
          context.showAppSnackBar(
            message: state.exception.message,
            type: SnackBarType.error,
          );
        }

        if (state is AuthSigned) {
          if (state.operation == AuthOperation.signUp) {
            context.showAppSnackBar(
              message: 'auth.messages.account_created'.tr(),
              type: SnackBarType.success,
            );
          }

          // Small delay to show the success state
          await Future<void>.delayed(const Duration(milliseconds: 300));

          context.router.pop();

          if (state.operation == AuthOperation.signUp) {
            context.router.pop();
          }

          context.read<AppCubit>().refreshUser();
        }
      },
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/auth_background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: Theme.of(context).inputDecorationTheme
                        .copyWith(
                          filled: true,
                          fillColor: AppColors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                  ),
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            const SizedBox(height: 80),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const AppIconWidget.svgAsset('logo', size: 40),
                                const SizedBox(width: 10),
                                Text(
                                  'auth.branding.app_name'.tr(),
                                  style: context.labelLarge.copyWith(
                                    fontSize: 51,
                                    letterSpacing: 0.4,
                                    color: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'auth.branding.tagline'.tr(),
                              style: context.bodySmall.copyWith(
                                fontWeight: FontWeight.w300,
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SignInFormWidget(),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'auth.actions.forgot_password'.tr(),
                                style: context.labelMedium.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            BlocBuilder<AuthCubit, AuthState>(
                              builder: (context, state) {
                                return AppElevatedButtonWidget(
                                  isLoading: state is AuthLoading,
                                  suffixIcon: state is AuthSigned
                                      ? 'check'
                                      : null,
                                  label: 'auth.actions.login'.tr(),
                                  onPressed: () => cubit.signInWithProvider(
                                    AuthProvider.email,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 12,
                              children: [
                                if (isIOSOverrideForTesting ?? Platform.isIOS)
                                  SocialSignInButtonWidget(
                                    icon: 'apple',
                                    onPressed: () => cubit.signInWithProvider(
                                      AuthProvider.apple,
                                    ),
                                  ),
                                SocialSignInButtonWidget(
                                  icon: 'google',
                                  onPressed: () => cubit.signInWithProvider(
                                    AuthProvider.google,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () => context
                                  .showAppBottomSheet(
                                    child: SignUpBottomSheetWidget(
                                      cubit: cubit,
                                    ),
                                  )
                                  .whenComplete(cubit.signUpForm.reset),
                              child: RichText(
                                text: TextSpan(
                                  text: 'auth.prompts.no_account'.tr(),
                                  style: context.bodyMedium.copyWith(
                                    color: AppColors.white,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'auth.actions.sign_up'.tr(),
                                      style: context.labelMedium.copyWith(
                                        color: AppColors.link,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
