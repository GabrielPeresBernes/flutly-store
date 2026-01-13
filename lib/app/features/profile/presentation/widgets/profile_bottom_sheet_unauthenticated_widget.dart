import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/router/router.dart';
import '../../../../shared/widgets/app_bottom_sheet_widget.dart';
import '../../../../shared/widgets/buttons/app_elevated_button_widget.dart';
import '../../../../shared/widgets/buttons/app_outlined_button_widget.dart';
import '../../../auth/infra/routes/auth_route.dart';

class ProfileBottomSheetUnauthenticatedWidget extends StatelessWidget {
  const ProfileBottomSheetUnauthenticatedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetWidget(
      title: 'profile.report_bug.auth_required.title'.tr(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'profile.report_bug.auth_required.message'.tr(),
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 35),
          AppElevatedButtonWidget(
            label: 'profile.report_bug.auth_required.sign_in'.tr(),
            onPressed: () {
              Navigator.of(context).pop();
              context.router.push(const AuthRoute());
            },
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: AppOutlinedButtonWidget(
              label: 'profile.report_bug.auth_required.cancel'.tr(),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
