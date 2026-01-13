import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step_progress/step_progress.dart';

part 'checkout_navigation_state.dart';

enum CheckoutStep {
  delivery('checkout.steps.delivery.title', 'checkout.steps.delivery.action', 0),
  payment('checkout.steps.payment.title', 'checkout.steps.payment.action', 1),
  review('checkout.steps.review.title', 'checkout.steps.review.action', 2),
  placingOrder(
    'checkout.steps.placing_order.title',
    'checkout.steps.placing_order.action',
    3,
  );

  const CheckoutStep(
    this.titleKey,
    this.actionKey,
    this.stepIndex,
  );

  final String titleKey;
  final String actionKey;
  final int stepIndex;

  String get title => titleKey.tr();
  String get action => actionKey.tr();
}

class CheckoutNavigationCubit extends Cubit<CheckoutNavigationState> {
  CheckoutNavigationCubit()
    : stepProgressController = StepProgressController(
        initialStep: 0,
        totalSteps: 3,
      ),
      super(const CheckoutNavigationInitial());

  final StepProgressController stepProgressController;

  void goToNextStep() {
    final nextStepIndex = state.step.stepIndex + 1;

    final nextStep = CheckoutStep.values[nextStepIndex];

    if (nextStep != CheckoutStep.placingOrder) {
      stepProgressController.setCurrentStep(nextStep.stepIndex);
    }

    emit(CheckoutNavigationToStep(step: nextStep));
  }

  void goToPreviousStep() {
    final previousStepIndex = state.step.stepIndex - 1;

    final previousStep = CheckoutStep.values[previousStepIndex];

    stepProgressController.setCurrentStep(previousStep.stepIndex);

    emit(CheckoutNavigationToStep(step: previousStep));
  }

  @override
  Future<void> close() {
    stepProgressController.dispose();
    return super.close();
  }
}
