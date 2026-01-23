import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/core/injector/injector.dart';
import 'package:flutly_store/app/core/injector/lib/providers/injector_provider.dart';
import 'package:flutly_store/app/features/cart/domain/entities/cart.dart';
import 'package:flutly_store/app/features/cart/presentation/bloc/cart_cubit.dart';
import 'package:flutly_store/app/features/checkout/presentation/bloc/checkout/checkout_cubit.dart';
import 'package:flutly_store/app/features/checkout/presentation/bloc/checkout_address/checkout_address_cubit.dart';
import 'package:flutly_store/app/features/checkout/presentation/bloc/checkout_navigation/checkout_navigation_cubit.dart';
import 'package:flutly_store/app/features/checkout/presentation/bloc/checkout_payment/checkout_payment_cubit.dart';
import 'package:flutly_store/app/features/checkout/presentation/bloc/checkout_shipping/checkout_shipping_cubit.dart';
import 'package:flutly_store/app/features/checkout/presentation/widgets/bottom_sheets/checkout_bottom_sheet_widget.dart';
import 'package:flutly_store/app/features/checkout/presentation/widgets/bottom_sheets/checkout_delivery_body_widget.dart';
import 'package:flutly_store/app/features/checkout/presentation/widgets/bottom_sheets/checkout_payment_body_widget.dart';
import 'package:flutly_store/app/features/checkout/presentation/widgets/bottom_sheets/checkout_placing_order_body_widget.dart';
import 'package:flutly_store/app/features/checkout/presentation/widgets/checkout_action_button_widget.dart';
import 'package:flutly_store/app/features/checkout/presentation/widgets/checkout_step_progress.dart';
import 'package:flutly_store/app/shared/widgets/app_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:step_progress/step_progress.dart';

import '../../../../../../fakes/fake_injector_provider.dart';
import '../../../../../../utils/test_utils.dart';

class MockCheckoutNavigationCubit extends MockCubit<CheckoutNavigationState>
    implements CheckoutNavigationCubit {}

class MockCheckoutCubit extends MockCubit<CheckoutState>
    implements CheckoutCubit {}

class MockCheckoutAddressCubit extends MockCubit<CheckoutAddressState>
    implements CheckoutAddressCubit {}

class MockCheckoutShippingCubit extends MockCubit<CheckoutShippingState>
    implements CheckoutShippingCubit {}

class MockCheckoutPaymentCubit extends MockCubit<CheckoutPaymentState>
    implements CheckoutPaymentCubit {}

class MockCartCubit extends MockCubit<CartState> implements CartCubit {}

void main() {
  late CheckoutNavigationCubit navigationCubit;
  late CheckoutCubit checkoutCubit;
  late CheckoutAddressCubit addressCubit;
  late CheckoutShippingCubit shippingCubit;
  late CheckoutPaymentCubit paymentCubit;
  late CartCubit cartCubit;

  setUpAll(() async {
    await TestUtils.setUpLocalization();
  });

  setUp(() {
    navigationCubit = MockCheckoutNavigationCubit();
    checkoutCubit = MockCheckoutCubit();
    addressCubit = MockCheckoutAddressCubit();
    shippingCubit = MockCheckoutShippingCubit();
    paymentCubit = MockCheckoutPaymentCubit();
    cartCubit = MockCartCubit();

    final injectorProvider = FakeInjectorProvider();

    CoreInjector.configureForTests(injectorProvider);

    injectorProvider
      ..registerFactory<CheckoutNavigationCubit>(() => navigationCubit)
      ..registerFactory<CheckoutCubit>(() => checkoutCubit)
      ..registerFactory<CheckoutAddressCubit>(() => addressCubit)
      ..registerFactory<CheckoutShippingCubit>(() => shippingCubit)
      ..registerFactory<CheckoutPaymentCubit>(() => paymentCubit);

    when(() => navigationCubit.stepProgressController).thenReturn(
      StepProgressController(initialStep: 0, totalSteps: 3),
    );

    when(() => cartCubit.cart).thenReturn(Cart.empty());

    when(() => addressCubit.getAddresses()).thenAnswer((_) async {});

    when(() => shippingCubit.getShippings()).thenAnswer((_) async {});

    when(() => paymentCubit.getPaymentCards()).thenAnswer((_) async {});

    when(() => navigationCubit.goToPreviousStep()).thenReturn(null);
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    required CheckoutNavigationState navigationState,
    CheckoutState checkoutState = const CheckoutInitial(),
  }) {
    whenListen(
      navigationCubit,
      Stream.value(navigationState),
      initialState: navigationState,
    );
    whenListen(
      checkoutCubit,
      Stream.value(checkoutState),
      initialState: checkoutState,
    );
    whenListen(
      addressCubit,
      Stream.value(const CheckoutAddressInitial()),
      initialState: const CheckoutAddressInitial(),
    );
    whenListen(
      shippingCubit,
      Stream.value(const CheckoutShippingInitial()),
      initialState: const CheckoutShippingInitial(),
    );
    whenListen(
      paymentCubit,
      Stream.value(const CheckoutPaymentInitial()),
      initialState: const CheckoutPaymentInitial(),
    );
    whenListen(
      cartCubit,
      Stream.value(const CartInitial()),
      initialState: const CartInitial(),
    );

    return TestUtils.pumpApp(
      tester,
      providers: [BlocProvider<CartCubit>.value(value: cartCubit)],
      child: const CheckoutBottomSheetWidget(),
    );
  }

  testWidgets('shows delivery body and triggers data fetch', (tester) async {
    await pumpApp(
      tester,
      navigationState: const CheckoutNavigationInitial(),
    );
    await tester.pump();

    expect(find.byType(CheckoutDeliveryBodyWidget), findsOneWidget);
    expect(find.byType(CheckoutStepProgress), findsOneWidget);
    expect(find.byType(CheckoutActionButtonWidget), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is AppIconWidget && widget.icon == 'assets/icons/close.svg',
      ),
      findsOneWidget,
    );

    verify(() => addressCubit.getAddresses()).called(1);
    verify(() => shippingCubit.getShippings()).called(1);
  });

  testWidgets('shows payment body and back action', (tester) async {
    await pumpApp(
      tester,
      navigationState: const CheckoutNavigationToStep(
        step: CheckoutStep.payment,
      ),
    );
    await tester.pump();

    expect(find.byType(CheckoutPaymentBodyWidget), findsOneWidget);
    expect(find.byType(CheckoutStepProgress), findsOneWidget);
    expect(find.byType(CheckoutActionButtonWidget), findsOneWidget);

    final backIcon = find.byWidgetPredicate(
      (widget) =>
          widget is AppIconWidget &&
          widget.icon == 'assets/icons/arrow_left.svg',
    );
    await tester.tap(
      find.ancestor(of: backIcon, matching: find.byType(IconButton)),
    );
    await tester.pump();

    verify(() => paymentCubit.getPaymentCards()).called(1);
    verify(() => navigationCubit.goToPreviousStep()).called(1);
  });

  testWidgets('shows placing order body without actions', (tester) async {
    await pumpApp(
      tester,
      navigationState: const CheckoutNavigationToStep(
        step: CheckoutStep.placingOrder,
      ),
      checkoutState: const CheckoutPlacingOrderUpdate(
        status: OrderStatus.verifying,
      ),
    );
    await tester.pump();

    expect(find.byType(CheckoutPlacingOrderBodyWidget), findsOneWidget);
    expect(find.byType(CheckoutStepProgress), findsNothing);
    expect(find.byType(CheckoutActionButtonWidget), findsNothing);
    expect(find.byType(IconButton), findsNothing);
  });
}
