import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/features/checkout/domain/entities/address.dart';
import 'package:flutly_store/app/features/checkout/domain/entities/shipping.dart';
import 'package:flutly_store/app/features/checkout/presentation/bloc/checkout/checkout_cubit.dart';
import 'package:flutly_store/app/features/checkout/presentation/bloc/checkout_address/checkout_address_cubit.dart';
import 'package:flutly_store/app/features/checkout/presentation/bloc/checkout_shipping/checkout_shipping_cubit.dart';
import 'package:flutly_store/app/features/checkout/presentation/widgets/bottom_sheets/checkout_delivery_body_widget.dart';
import 'package:flutly_store/app/features/checkout/presentation/widgets/page_states/address_loaded_widget.dart';
import 'package:flutly_store/app/features/checkout/presentation/widgets/page_states/address_loading_widget.dart';
import 'package:flutly_store/app/features/checkout/presentation/widgets/page_states/shipping_loaded_widget.dart';
import 'package:flutly_store/app/features/checkout/presentation/widgets/page_states/shipping_loading_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../../utils/test_utils.dart';

class MockCheckoutCubit extends MockCubit<CheckoutState>
    implements CheckoutCubit {}

class MockCheckoutAddressCubit extends MockCubit<CheckoutAddressState>
    implements CheckoutAddressCubit {}

class MockCheckoutShippingCubit extends MockCubit<CheckoutShippingState>
    implements CheckoutShippingCubit {}

void main() {
  late CheckoutCubit checkoutCubit;
  late CheckoutAddressCubit addressCubit;
  late CheckoutShippingCubit shippingCubit;

  const address = Address(
    title: 'Home',
    street: 'Main St',
    city: 'Springfield',
    state: 'SP',
    zipCode: '00000',
    country: 'BR',
  );

  const shipping = Shipping(
    name: 'Standard',
    cost: 0,
    duration: '2 days',
  );

  setUpAll(() async {
    await TestUtils.setUpLocalization();
    registerFallbackValue(address);
    registerFallbackValue(shipping);
  });

  setUp(() {
    checkoutCubit = MockCheckoutCubit();
    addressCubit = MockCheckoutAddressCubit();
    shippingCubit = MockCheckoutShippingCubit();

    when(() => addressCubit.getAddresses()).thenAnswer((_) async {});

    when(() => shippingCubit.getShippings()).thenAnswer((_) async {});

    when(() => checkoutCubit.selectAddress(any())).thenReturn(null);

    when(() => checkoutCubit.selectShipping(any())).thenReturn(null);
  });

  Future<void> pumpApp(
    WidgetTester tester, {
    required Stream<CheckoutAddressState> addressStream,
    required Stream<CheckoutShippingState> shippingStream,
  }) {
    whenListen(
      checkoutCubit,
      Stream.value(const CheckoutInitial()),
      initialState: const CheckoutInitial(),
    );
    whenListen(
      addressCubit,
      addressStream,
      initialState: const CheckoutAddressInitial(),
    );
    whenListen(
      shippingCubit,
      shippingStream,
      initialState: const CheckoutShippingInitial(),
    );

    return TestUtils.pumpApp(
      tester,
      providers: [
        BlocProvider<CheckoutCubit>.value(value: checkoutCubit),
        BlocProvider<CheckoutAddressCubit>.value(value: addressCubit),
        BlocProvider<CheckoutShippingCubit>.value(value: shippingCubit),
      ],
      child: const CheckoutDeliveryBodyWidget(),
    );
  }

  testWidgets('renders loading widgets and requests data', (tester) async {
    await pumpApp(
      tester,
      addressStream: Stream.value(const CheckoutAddressLoading()),
      shippingStream: Stream.value(const CheckoutShippingLoading()),
    );
    await tester.pump();

    expect(find.byType(AddressLoadingWidget), findsOneWidget);
    expect(find.byType(ShippingLoadingWidget), findsOneWidget);
    verify(() => addressCubit.getAddresses()).called(1);
    verify(() => shippingCubit.getShippings()).called(1);
  });

  testWidgets('renders loaded widgets and selects defaults', (tester) async {
    await pumpApp(
      tester,
      addressStream: Stream.value(
        const CheckoutAddressLoaded(addresses: [address]),
      ),
      shippingStream: Stream.value(
        const CheckoutShippingLoaded(shippings: [shipping]),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AddressLoadedWidget), findsOneWidget);
    expect(find.byType(ShippingLoadedWidget), findsOneWidget);
    verify(() => checkoutCubit.selectAddress(address)).called(1);
    verify(() => checkoutCubit.selectShipping(shipping)).called(1);
  });
}
