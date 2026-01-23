part of 'checkout_navigation_cubit.dart';

sealed class CheckoutNavigationState extends Equatable {
  const CheckoutNavigationState({
    this.step = CheckoutStep.delivery,
  });

  final CheckoutStep step;

  @override
  List<Object?> get props => [step];
}

final class CheckoutNavigationInitial extends CheckoutNavigationState {
  const CheckoutNavigationInitial();
}

final class CheckoutNavigationToStep extends CheckoutNavigationState {
  const CheckoutNavigationToStep({required super.step});
}
