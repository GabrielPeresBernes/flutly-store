import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/features/checkout/presentation/bloc/checkout_shipping/checkout_shipping_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../utils/test_utils.dart';

void main() {
  setUpAll(() async {
    await TestUtils.setUpLocalization();
  });

  blocTest<CheckoutShippingCubit, CheckoutShippingState>(
    'getShippings emits loading then loaded with sample shipping',
    build: CheckoutShippingCubit.new,
    act: (cubit) => cubit.getShippings(),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      isA<CheckoutShippingLoading>(),
      isA<CheckoutShippingLoaded>().having(
        (state) => state.shippings.length,
        'shippings',
        1,
      ),
    ],
  );
}
