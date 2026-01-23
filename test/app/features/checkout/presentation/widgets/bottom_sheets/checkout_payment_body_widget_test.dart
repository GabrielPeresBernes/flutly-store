import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/features/checkout/domain/entities/payment_card.dart';
import 'package:flutly_store/app/features/checkout/presentation/bloc/checkout/checkout_cubit.dart';
import 'package:flutly_store/app/features/checkout/presentation/bloc/checkout_payment/checkout_payment_cubit.dart';
import 'package:flutly_store/app/features/checkout/presentation/widgets/bottom_sheets/checkout_payment_body_widget.dart';
import 'package:flutly_store/app/features/checkout/presentation/widgets/page_states/payment_loaded_widget.dart';
import 'package:flutly_store/app/features/checkout/presentation/widgets/page_states/payment_loading_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../utils/test_utils.dart';

class MockCheckoutCubit extends MockCubit<CheckoutState>
    implements CheckoutCubit {}

class MockCheckoutPaymentCubit extends MockCubit<CheckoutPaymentState>
    implements CheckoutPaymentCubit {}

void main() {
  late CheckoutCubit checkoutCubit;
  late CheckoutPaymentCubit paymentCubit;

  const card = PaymentCard(
    name: 'User',
    last4Digits: '1234',
    expirationDate: '12/30',
    token: 'token',
    brand: CardBrand.visa,
  );

  setUpAll(() async {
    await TestUtils.setUpLocalization();
    registerFallbackValue(card);
  });

  setUp(() {
    checkoutCubit = MockCheckoutCubit();
    paymentCubit = MockCheckoutPaymentCubit();

    when(() => paymentCubit.getPaymentCards()).thenAnswer((_) async {});

    when(() => checkoutCubit.selectPayment(any())).thenReturn(null);
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    required Stream<CheckoutPaymentState> paymentStream,
  }) {
    whenListen(
      checkoutCubit,
      Stream.value(const CheckoutInitial()),
      initialState: const CheckoutInitial(),
    );
    whenListen(
      paymentCubit,
      paymentStream,
      initialState: const CheckoutPaymentInitial(),
    );

    return TestUtils.pumpApp(
      tester,
      providers: [
        BlocProvider<CheckoutCubit>.value(value: checkoutCubit),
        BlocProvider<CheckoutPaymentCubit>.value(value: paymentCubit),
      ],
      child: const CheckoutPaymentBodyWidget(),
    );
  }

  testWidgets('renders loading widget and requests cards', (tester) async {
    await pumpApp(
      tester,
      paymentStream: Stream.value(const CheckoutPaymentLoading()),
    );
    await tester.pump();

    expect(find.byType(PaymentLoadingWidget), findsOneWidget);
    verify(() => paymentCubit.getPaymentCards()).called(1);
  });

  testWidgets('renders loaded widget and selects default card', (tester) async {
    await pumpApp(
      tester,
      paymentStream: Stream.value(
        const CheckoutPaymentLoaded(paymentCards: [card]),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PaymentLoadedWidget), findsOneWidget);
    verify(() => checkoutCubit.selectPayment(card)).called(1);
  });
}
