import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/router/router.dart';
import '../../../../shared/bloc/app_cubit.dart';
import '../../../../shared/extensions/show_app_bottom_sheet_extension.dart';
import '../../../../shared/extensions/text_theme_extension.dart';
import '../../../../shared/theme/tokens/color_tokens.dart';
import '../../../../shared/widgets/app_icon_widget.dart';
import '../../../../shared/widgets/navigation_bars/app_top_navigation_bar.dart';
import '../../../auth/infra/routes/auth_route.dart';
import '../../constants/profile_constants.dart';
import '../../infra/routes/report_bug_route.dart';
import '../../profile.dart';
import '../widgets/profile_bottom_sheet_unauthenticated_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppCubit>();

    return Scaffold(
      appBar: AppTopNavigationBar(
        title: 'profile.title'.tr(),
        showLeading: false,
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<AppCubit, AppState>(
          buildWhen: (previous, current) =>
              current is AppUserRefreshing || current is AppUserRefreshed,
          builder: (context, state) {
            final isLoading = state is AppUserRefreshing;

            final credentials = state is AppUserRefreshed
                ? state.credentials
                : null;

            final isAuthenticated = credentials != null;

            return Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: isAuthenticated
                            ? AppColors.secondary
                            : AppColors.gray100,
                        child: isAuthenticated
                            ? Text(
                                credentials.name.substring(0, 2).toUpperCase(),
                                style: context.labelLarge.copyWith(
                                  color: AppColors.white,
                                  fontSize: 32,
                                ),
                              )
                            : const AppIconWidget.svgAsset(
                                'profile',
                                size: 40,
                                color: AppColors.white,
                              ),
                      ),
                      const SizedBox(width: 26),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isAuthenticated
                                  ? credentials.name
                                  : 'profile.user.guest'.tr(),
                              style: context.bodyLarge,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              isAuthenticated
                                  ? credentials.email
                                  : 'profile.user.sign_in_prompt'.tr(),
                              style: context.bodyMedium.copyWith(
                                color: AppColors.gray100,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColors.gray300),
                    ),
                  ),
                  child: Column(
                    children: [
                      ProfileSectionWidget(
                        title: 'profile.sections.general'.tr(),
                      ),
                      if (isAuthenticated)
                        ProfileItemWidget(
                          title: 'profile.actions.sign_out'.tr(),
                          isLoading: isLoading,
                          onTap: () => context.read<AppCubit>().signOut(),
                        ),
                      if (!isAuthenticated)
                        ProfileItemWidget(
                          title: 'profile.actions.sign_in'.tr(),
                          onTap: () => context.router.push(const AuthRoute()),
                        ),
                    ],
                  ),
                ),
                ProfileSectionWidget(title: 'profile.sections.support'.tr()),
                ProfileItemWidget(
                  title: 'profile.actions.report_bug'.tr(),
                  onTap: () {
                    if (!context.read<AppCubit>().isUserAuthenticated) {
                      context.showAppBottomSheet(
                        child: const ProfileBottomSheetUnauthenticatedWidget(),
                      );
                      return;
                    }

                    context.router.push(const ReportBugRoute());
                  },
                ),
                if (isAuthenticated)
                  Column(
                    children: [
                      ProfileSectionWidget(
                        title: 'profile.sections.account'.tr(),
                      ),
                      ProfileItemWidget(
                        title: 'profile.actions.edit_profile'.tr(),
                        onTap: () =>
                            context.router.push(const EditProfileRoute()),
                      ),
                      ProfileItemWidget(
                        title: 'profile.actions.delete_account'.tr(),
                        onTap: () => launchUrl(
                          Uri.parse(ProfileConstants.deleteAccountUrl),
                        ),
                      ),
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 24,
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      iconButtonTheme: IconButtonThemeData(
                        style: IconButton.styleFrom(
                          side: const BorderSide(color: AppColors.gray300),
                          foregroundColor: AppColors.gray100,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        IconButton.outlined(
                          icon: const AppIconWidget.svgAsset(
                            'linkedin',
                            color: AppColors.gray100,
                            size: 20,
                          ),
                          onPressed: () => launchUrl(
                            Uri.parse(ProfileConstants.linkedInUrl),
                          ),
                        ),
                        const SizedBox(width: 12),
                        IconButton.outlined(
                          icon: const AppIconWidget.svgAsset(
                            'github',
                            color: AppColors.gray100,
                            size: 20,
                          ),
                          onPressed: () => launchUrl(
                            Uri.parse(ProfileConstants.githubUrl),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          cubit.appFullVersion,
                          style: context.bodyMedium.copyWith(
                            color: AppColors.gray100,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
