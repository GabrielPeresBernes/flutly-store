import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_progress/step_progress.dart';

import '../../../../shared/extensions/text_theme_extension.dart';
import '../../../../shared/theme/tokens/color_tokens.dart';
import '../../../../shared/widgets/app_icon_widget.dart';
import '../bloc/checkout_navigation/checkout_navigation_cubit.dart';

class CheckoutStepProgress extends StatelessWidget {
  const CheckoutStepProgress({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CheckoutNavigationCubit>();

    return StepProgress(
      controller: cubit.stepProgressController,
      totalSteps: 3,
      stepNodeSize: 18,
      width: 95,
      theme: const StepProgressThemeData(
        stepAnimationDuration: Duration(milliseconds: 300),
        stepNodeStyle: StepNodeStyle(
          activeDecoration: BoxDecoration(
            color: AppColors.primary,
          ),
        ),
        stepLineStyle: StepLineStyle(
          lineThickness: 2,
          activeColor: AppColors.primary,
        ),
      ),
      nodeIconBuilder: (index, status) {
        return index <= cubit.stepProgressController.currentStep
            ? const AppIconWidget.svgAsset(
                'check_step',
                size: 10,
                color: AppColors.white,
              )
            : Text(
                '${index + 1}',
                style: context.labelSmall.copyWith(
                  color: AppColors.white,
                  fontSize: 10,
                ),
              );
      },
    );
  }
}
