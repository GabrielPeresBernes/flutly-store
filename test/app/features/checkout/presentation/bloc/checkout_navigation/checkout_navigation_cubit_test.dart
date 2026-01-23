import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/features/checkout/presentation/bloc/checkout_navigation/checkout_navigation_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  blocTest<CheckoutNavigationCubit, CheckoutNavigationState>(
    'goToNextStep advances and keeps progress at review before placing order',
    build: CheckoutNavigationCubit.new,
    act: (cubit) {
      cubit.goToNextStep();
      cubit.goToNextStep();
      cubit.goToNextStep();
    },
    expect: () => [
      const CheckoutNavigationToStep(step: CheckoutStep.payment),
      const CheckoutNavigationToStep(step: CheckoutStep.review),
      const CheckoutNavigationToStep(step: CheckoutStep.placingOrder),
    ],
    verify: (cubit) {
      expect(cubit.stepProgressController.currentStep, 2);
    },
  );

  blocTest<CheckoutNavigationCubit, CheckoutNavigationState>(
    'goToPreviousStep moves back and updates progress',
    build: CheckoutNavigationCubit.new,
    act: (cubit) {
      cubit.goToNextStep();
      cubit.goToNextStep();
      cubit.goToPreviousStep();
    },
    expect: () => [
      const CheckoutNavigationToStep(step: CheckoutStep.payment),
      const CheckoutNavigationToStep(step: CheckoutStep.review),
      const CheckoutNavigationToStep(step: CheckoutStep.payment),
    ],
    verify: (cubit) {
      expect(cubit.stepProgressController.currentStep, 1);
    },
  );
}
