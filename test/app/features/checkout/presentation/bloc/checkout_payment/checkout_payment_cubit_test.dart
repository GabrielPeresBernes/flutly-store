import 'package:bloc_test/bloc_test.dart';
import 'package:flutly_store/app/features/checkout/presentation/bloc/checkout_payment/checkout_payment_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../../utils/test_utils.dart';

void main() {
  setUpAll(() async {
    await TestUtils.setUpLocalization();
  });

  blocTest<CheckoutPaymentCubit, CheckoutPaymentState>(
    'getPaymentCards emits loading then loaded with sample cards',
    build: CheckoutPaymentCubit.new,
    act: (cubit) => cubit.getPaymentCards(),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      isA<CheckoutPaymentLoading>(),
      isA<CheckoutPaymentLoaded>().having(
        (state) => state.paymentCards.length,
        'cards',
        2,
      ),
    ],
  );
}
