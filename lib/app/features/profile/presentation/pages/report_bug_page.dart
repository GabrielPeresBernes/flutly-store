import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../shared/extensions/layout_extension.dart';
import '../../../../shared/extensions/show_app_snack_bar_extension.dart';
import '../../../../shared/extensions/text_theme_extension.dart';
import '../../../../shared/theme/tokens/color_tokens.dart';
import '../../../../shared/widgets/buttons/app_elevated_button_widget.dart';
import '../../../../shared/widgets/inputs/app_reactive_dropdown_field_widget.dart';
import '../../../../shared/widgets/inputs/app_reactive_text_field_widget.dart';
import '../../../../shared/widgets/navigation_bars/app_top_navigation_bar.dart';
import '../bloc/profile_cubit.dart';
import '../widgets/dynamic_list_field_widget.dart';

class ReportBugPage extends StatelessWidget {
  const ReportBugPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();

    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileFailure) {
          return context.showAppSnackBar(
            message: state.exception.message,
            type: SnackBarType.error,
          );
        }

        if (state is ProfileBugReported) {
          context.showAppSnackBar(
            message: 'profile.report_bug.success_message'.tr(),
            type: SnackBarType.success,
          );
        }
      },
      child: Scaffold(
        extendBody: true,
        appBar: AppTopNavigationBar(
          title: 'profile.report_bug.title'.tr(),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24, 34, 24, context.bottomBarOffset),
            child: ReactiveForm(
              formGroup: cubit.bugReportForm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  AppReactiveTextFieldWidget(
                    label: 'profile.report_bug.fields.description_label'.tr(),
                    formControlName: 'description',
                    hintText: 'profile.report_bug.fields.description_hint'.tr(),
                    maxLines: 3,
                    validationMessages: {
                      ValidationMessage.required: (_) =>
                          'profile.report_bug.fields.description_required'.tr(),
                      ValidationMessage.maxLength: (error) {
                        final requiredLength =
                            (error as Map<String, Object>)['requiredLength']
                                as int?;

                        return 'profile.report_bug.fields.description_max_length'
                            .tr(
                              namedArgs: {
                                'length': '$requiredLength',
                              },
                            );
                      },
                    },
                    keyboardType: TextInputType.multiline,
                  ),
                  DynamicListFieldWidget(
                    label: 'profile.report_bug.fields.steps_label'.tr(),
                    hintText: 'profile.report_bug.fields.steps_empty'.tr(),
                    formArray:
                        cubit.bugReportForm.control('stepsToReproduce')
                            as FormArray<String>,
                  ),
                  AppReactiveTextFieldWidget(
                    label: 'profile.report_bug.fields.expected_label'.tr(),
                    formControlName: 'expectedBehavior',
                    hintText: 'profile.report_bug.fields.expected_hint'.tr(),
                    maxLines: 2,
                    validationMessages: {
                      ValidationMessage.maxLength: (error) {
                        final requiredLength =
                            (error as Map<String, Object>)['requiredLength']
                                as int?;

                        return 'profile.report_bug.fields.description_max_length'
                            .tr(
                              namedArgs: {
                                'length': '$requiredLength',
                              },
                            );
                      },
                    },
                  ),
                  AppReactiveDropdownFieldWidget(
                    label: 'profile.report_bug.fields.issue_type_label'.tr(),
                    formControlName: 'issueType',
                    hintText: 'profile.report_bug.fields.issue_type_hint'.tr(),
                    items: [
                      DropdownMenuItem(
                        value: 'visual_issue',
                        child: Text(
                          'profile.report_bug.issue_types.visual'.tr(),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'feature_not_working',
                        child: Text(
                          'profile.report_bug.issue_types.feature_not_working'
                              .tr(),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'crash_freeze',
                        child: Text(
                          'profile.report_bug.issue_types.crash_freeze'.tr(),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'performance',
                        child: Text(
                          'profile.report_bug.issue_types.performance'.tr(),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'other',
                        child: Text(
                          'profile.report_bug.issue_types.other'.tr(),
                        ),
                      ),
                    ],
                  ),
                  AppReactiveTextFieldWidget(
                    label: 'profile.report_bug.fields.screen_label'.tr(),
                    formControlName: 'screen',
                    hintText: 'profile.report_bug.fields.screen_hint'.tr(),
                  ),
                  AppReactiveDropdownFieldWidget(
                    label: 'profile.report_bug.fields.frequency_label'.tr(),
                    formControlName: 'frequency',
                    hintText: 'profile.report_bug.fields.frequency_hint'.tr(),
                    items: [
                      DropdownMenuItem(
                        value: 'once',
                        child: Text(
                          'profile.report_bug.frequency_options.once'.tr(),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'sometimes',
                        child: Text(
                          'profile.report_bug.frequency_options.sometimes'.tr(),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'every_time',
                        child: Text(
                          'profile.report_bug.frequency_options.every_time'
                              .tr(),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.gray400,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.gray200),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Text(
                          'profile.report_bug.info.usage'.tr(),
                          style: context.bodySmall,
                        ),
                        Text(
                          'profile.report_bug.info.sensitive'.tr(),
                          style: context.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      return AppElevatedButtonWidget(
                        label: 'profile.report_bug.actions.send'.tr(),
                        onPressed: cubit.reportBug,
                        isLoading: state is ProfileLoading,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
